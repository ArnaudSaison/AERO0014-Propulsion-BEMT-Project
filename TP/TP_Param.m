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
