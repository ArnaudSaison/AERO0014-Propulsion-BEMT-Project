function [res] = section(res, p, j)
%SECTION computes the properties of the propeller for a small section dr
%   p: contains the parameters
%   j: index of the section currently studied
% 

% Initializing the loop
i.i = 1;

% Initializing the last value
last.v_a3(j) = res.v_a3(j) * 2 + 100;
last.v_u2p(j) = res.v_u2p(j) * 2 + 100;

% Log
dispLog(['v_a3    ', num2str(res.v_a3)], p.verb2);
dispLog(['v_u2p   ', num2str(res.v_u2p)], p.verb2);
dispLog(' ', p.verb2);

% Loop
while i.i < p.i.max ...
      && (abs((res.v_a3(j) - last.v_a3(j)) / last.v_a3(j)) > p.i.tol ...
      || abs((res.v_u2p(j) - last.v_u2p(j)) / last.v_u2p(j)) > p.i.tol)

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
    res.dm_dot(j) = 2 * pi * p.r(j) * p.rho * res.v_a2(j);

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
    res.v_a3(j) = p.v_inf + res.dF_a(j) / res.dm_dot(j);
    res.v_u2p(j) = res.dF_u(j) / res.dm_dot(j);

    % incrementation
    i.i = i.i + 1;
    
    % Log
    printSec(res, j, p);
end

% Log
dispLog(['Iterations: ', num2str(i.i)], p.verb2);
if i.i >= p.i.max
    dispLog('Did not converge', p.verb2);
    
    warning(['Iteration ', num2str(j), ' (at ', num2str(p.r(j)), ' cm) did not converge after ', num2str(i.i), ' iterations.'])
end
dispLog('----------------------------------------------------', p.verb2)

end