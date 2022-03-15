% -------------------------------------------------------------------------
% Propeller: Hartzell HC-C2YK-1BF/8477-8R
% -------------------------------------------------------------------------
p.n = 2;                                % [#]               nb of blades (can be changed)
p.D = 76            *2.54/100;          % [in]->[m]         diameter = 2 * p.R
p.R = p.D / 2;                          % [m]               radius = p.D / 2
p.Omega = 2400      /60*2*pi;           % [RPM]->[rad/s]    constant speed (can be changed)
p.collective = 0    /180*pi;            % [deg]->[rad]      collective pitch (can be changed)
p.root_cutout = 0.15;                   % [%]               space taken by the hub
p.root_chord = 5    *2.54/100;          % [in]->[m]         chord at the root radially
p.tip_chord = 2     *2.54/100;          % [in]->[m]         chord at the tip
p.root_stagger = 40 /180*pi;            % [deg]->[rad]      stagger angle at the root
p.tip_stagger = 2   /180*pi;            % [deg]->[rad]      stagger angle at the tip

% Assumption that the blade is made of single profile with polar approx
p.C_L =@(aoa, Re) 0.1101 * aoa + 0.4409;                    % [-]@[°][-]   lift coeff
p.C_D =@(aoa, Re) 0.0006 * aoa^2 - 0.0042 * aoa + 0.0050;   % [-]@[°][-]   drag coeff

% Sections
p.nb_pos = 200;                                             % [#]	number of positions along the propeller
p.pos = linspace(p.root_cutout,1,p.nb_pos);                 % [-]	positions = x/R
p.r = p.pos * p.R;                                          % [m]	positions = x

p.stagger = (p.tip_stagger - p.root_stagger) * p.pos + p.root_stagger;  % [rad]     stagger angle
p.chord = (p.tip_chord - p.root_chord) * p.pos + p.root_chord;          % [m]       chord

