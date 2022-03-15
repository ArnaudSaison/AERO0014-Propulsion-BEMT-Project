function [res, p] = BEM(p)
%BEM (Blade Element Method) computes the properties of a given propeller
%   

% Starting values for iterations
p.init_v_a3 = p.v_inf;                  % [m/s]         downstream velocity
p.init_v_u2p = 0;                       % [m/s]         propeller exit velocity

% loop until exit condition: error function or iteration limit
for j = 1:p.nb_pos
    
    % Initialization
    res.v_a3(j) = p.init_v_a3;
    res.v_u2p(j) = p.init_v_u2p;
    
    % Apply the BEM on this section
    res = section(res, p, j);
    
end

% Log
printTot(res, p);

% Integration of the results over the whole propeller
res.T = integrate(res.dT, p.r);
res.C = integrate(res.dC, p.r);
res.P = integrate(res.dP, p.r);

% Log
printInt(res, p);

% Coefficients
[res.C_T, res.C_P, res.eta_P, res.J] = coeffs(res, p);

% Log
printCoeffs(res, p);

end