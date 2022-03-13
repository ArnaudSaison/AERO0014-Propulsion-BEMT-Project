% -------------------------------------------------------------------------
% Plane parameters
% -------------------------------------------------------------------------
p.v_inf = 160           /3600*1.852e3;  % [kts]->[m/s]  cruise speed (can be changed)
p.altitude = 4900       /3.281;      	% [m]           cruise altitude
p.drag_force = 1030;                    % [N]           drag at cruise conditions


% -------------------------------------------------------------------------
% Air properties
% -------------------------------------------------------------------------
[~, ~, ~, b] = atmosisa(p.altitude);
p.rho = b; clear b;                     % [kg/m^3]      density at design altitude
p.mu = 1.680e-5;                        % [kg/(m*s)]    dynamic viscosity


% -------------------------------------------------------------------------
% Itaration parameters
% -------------------------------------------------------------------------
p.i.tol = 1e-3;                      	% [-]           tolerance = relative change in velocity components
p.i.max = 50;                       	% [#]           maximum number of iterations


% -------------------------------------------------------------------------
% Questions data
% -------------------------------------------------------------------------
% Question 1
p.nb_collectives = 4;
p.min_collective = 10;
p.max_collective = 40;

p.collectives = linspace(p.min_collective,p.max_collective,p.nb_collectives) /180*pi;   
                                        % [deg]->[rad]  different collective pitches

% Question 2
p.nb_airspeeds = 50;
p.min_airspeed = 40;
p.max_airspeed = 250;

p.airspeeds = linspace(p.min_airspeed,p.max_airspeed,p.nb_airspeeds) ...
              /3600*1.852e3;            % [kts]->[m/s]  different cruise velocities

% Question 3
p.expected_power = 0.75;              	% [-]	percentage of engine power that should be used in cruise

