% Aerospace Propulsion: Arnaud Saison 2022/22/02
% 
% BEM code
% 

%%
clear all; close all; clc; %warning off;
verb = 0;


%% ========================================================================
% Parameters
% =========================================================================
% -------------------------------------------------------------------------
% Propeller: Diamong DA-40 NG
% -------------------------------------------------------------------------
p.n = 3;                                % [#]       nb of blades
p.D = 1.9;                              % [m]       diameter = 2 * R (radius)
p.R = p.D / 2;                          % [m]       
p.Omega = 2300 / 60 * 2*pi;             % [rad/s]   constant speed
p.v_inf = 230/3.6;                      % [m/s]     cruise speed
p.altitude = 14000/3.281;               % [m]       altitude
p.collective = 28 / 180 * pi;           % [rad]     collective pitch

[~, ~, ~, b] = atmosisa(p.altitude);
p.rho = b;                              % [kg/m^3]  density at design altitude
p.mu = 1.680e-5;                        % [kg/(m s)]dynamic viscosity

% Assumption that the blade is made of single profile with polar approx:
p.C_L =@(aoa, Re) 0.1 * aoa;              % [-]@[°]   lift coeff
p.C_D =@(aoa, Re) 0.0001 * aoa^2 + 0.0053;% [-]@[°]   drag coeff

% Sections
p.pos =     [0.25, 0.5, 0.75];          % [-]       positions = x/R
p.r =       p.pos * p.R;                % [m]       positions = x
p.stagger = [30, 12, 4] / 180 * pi;     % [rad]     stagger angle
p.chord =   [0.1, 0.05, 0.03];          % [m]       chord

p.nb_pos = length(p.pos);               % [#]       number of sections

% Starting values
p.init_v_a3 = p.v_inf;                  % [m/s]     downstream velocity
p.init_v_u2p = 0;                       % [m/s]     propeller exit velocity


% -------------------------------------------------------------------------
% Itaration parameters
% -------------------------------------------------------------------------
i.tol = 1e-5;                           % [-]       tolerance = relative change in velocity components
i.max = 50;                             % [#]       maximum number of iterations
i.i = 1;                                % [#]       iteration count
%j = 1;                                 % [#]       position along radius


%% ========================================================================
% BEM iterative process
% =========================================================================
%
% Methodology: using BEM, compute relative flow angle, angle of attack,
% element thrust, and element power at each section.
%
% Integration is performed afterwards on these values to find total thrust 
% and power.
%

% loop until exit condition: error function or iteration limit
for j = 1:p.nb_pos
    
    % Initialization
    i.i = 1;
    
    res.v_a3(j) = p.init_v_a3;
    res.v_u2p(j) = p.init_v_u2p;
    
    last.v_a3(j) = res.v_a3(j) * 2 + 100;
    last.v_u2p(j) = res.v_u2p(j) * 2 + 100;
    
    dispLog(['v_a3    ', num2str(res.v_a3)], verb)
    dispLog(['v_u2p   ', num2str(res.v_u2p)], verb)
    dispLog(' ', verb)
    
    % Loop
    while i.i < i.max ...
          && (abs((res.v_a3(j) - last.v_a3(j)) / last.v_a3(j)) > i.tol ...
          || abs((res.v_u2p(j) - last.v_u2p(j)) / last.v_u2p(j)) > i.tol)
        
        % saving results from last iteration
        last.v_a3(j) = res.v_a3(j);
        last.v_u2p(j) = res.v_u2p(j);
      
        % 2)
        % velocity components at prop disk
        res.v_a2(j) = (p.v_inf + res.v_a3(j))/2;
        res.w_a2(j) = res.v_a2(j);
        res.v_u2(j) = res.v_u2p(j) / 2;
        res.w_u2(j) = res.v_u2(j) - p.Omega * p.r(j);

        % 3)
        % mass flow from axial velocity
        res.dmp(j) = 2 * pi * p.r(j) * p.rho * res.v_a2(j);

        % 4)
        % Using relative velocity components, compute velocity magnitude and flow angle
        res.w_2(j) = sqrt(res.w_a2(j)^2 + res.w_u2(j)^2);
        res.beta_2(j) = atan2(res.w_u2(j), res.w_a2(j));

        % The angle of attack and Reynolds nb based on velocity magnitude and flow angle
        res.local_pitch(j) = p.stagger(j) + p.collective;
        res.aoa(j) = res.local_pitch(j) - (pi/2 + res.beta_2(j));
        res.Re(j) = p.rho * res.w_2(j) * p.chord(j) / p.mu;

        % Lift and drag coefficient based on aoa and Reynolds nb
        res.C_D(j) = p.C_D(rad2deg(res.aoa(j)), res.Re(j));
        res.C_L(j) = p.C_L(rad2deg(res.aoa(j)), res.Re(j));

        % Lift and drag per unit span dr = 1 m, based on coefficients and velocity magnitude
        res.dL(j) = res.C_L(j) * p.n * p.chord(j) * 1/2 * p.rho * res.w_2(j)^2;
        res.dD(j) = res.C_D(j) * p.n * p.chord(j) * 1/2 * p.rho * res.w_2(j)^2;

        % Thrust and torque are found geometrically
        res.dF_a(j) = - (res.dL(j) * sin(res.beta_2(j)) + res.dD(j) * cos(res.beta_2(j)));
        res.dF_u(j) = (res.dL(j) * cos(res.beta_2(j)) - res.dD(j) * sin(res.beta_2(j)));

        res.dT(j) = res.dF_a(j);
        res.dC(j) = p.r(j) * res.dF_u(j);
        
        res.dP(j) = p.Omega * res.dC(j);

        % 5)
        % new approximations for absolute velocity components
        res.v_a3(j) = p.v_inf + res.dF_a(j) / res.dmp(j);
        res.v_u2p(j) = res.dF_u(j) / res.dmp(j);

        % incrementation
        i.i = i.i + 1;
        
        dispLog(['beta_2  ', num2str(rad2deg(res.beta_2))], verb)
        dispLog(['aoa     ', num2str(rad2deg(res.aoa))], verb)
        dispLog(['v_a3    ', num2str(res.v_a3)], verb)
        dispLog(['v_u2p   ', num2str(res.v_u2p)], verb)
        dispLog(' ', verb)
    end
    
    dispLog(['Iterations: ', num2str(i.i)], verb);
    
    if i.i > i.max
        dispLog('Did not converge', verb);
    end
    
    dispLog('----------------------------------------------------', verb)
    
end

dispLog(' ')
dispLog(' ')
dispLog(' ')

disp( '----------------------------------------------------')
disp(['position   | ', num2str(p.pos)])
disp( '----------------------------------------------------')
disp(['beta_2 [°] | ', num2str(rad2deg(res.beta_2))])
disp(['aoa [°]    | ', num2str(rad2deg(res.aoa))])
disp(['Thrust [N] | ', num2str(res.dT)])
disp(['Power [kW] | ', num2str(res.dP/1e3)])
disp( '----------------------------------------------------')


%% ========================================================================
% Summation process
% =========================================================================

% loop of summation to approximate integral
res.T = 0;
res.C = 0;
res.P = 0;

for j = 1:p.nb_pos-1
    res.T = res.T + (res.dT(j) + res.dT(j+1)) / 2 * (p.r(j+1) - p.r(j));
    res.C = res.C + (res.dC(j) + res.dC(j+1)) / 2 * (p.r(j+1) - p.r(j));
    res.P = res.P + (res.dP(j) + res.dP(j+1)) / 2 * (p.r(j+1) - p.r(j));
end

% res.T = intProp(res.dT, p.r);
% res.C = intProp(res.dC, p.r);
% res.P = intProp(res.dP, p.r);
% 
% res.T = trapz(res.dT, p.r);
% res.C = trapz(res.dC, p.r);
% res.P = trapz(res.dP, p.r);


disp( '----------------------------------------------------')
disp(['T [N]      | ', num2str(res.T)])
disp(['C [N/m]    | ', num2str(res.C)])
disp(['P [kW]     | ', num2str(res.P/1e3)])
disp( '----------------------------------------------------')













