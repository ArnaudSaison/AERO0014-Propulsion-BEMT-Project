function [C_T, C_P, eta, eta_P, J] = coeffs(res, p)
%COEFFS computes the thrust and power coefficients and propulsive efficiency
%   res: results of the BEM code
%   p: parameters
%

eta  = res.T * p.v_inf / res.P;                          	% global efficiency

v_a1 = - res.dF_a ./ res.dm_dot + res.v_a3;                 % should be v_inf
eta_P = res.T * p.v_inf ./ integrate(res.dm_dot .* (res.v_a3.^2 - v_a1.^2)/2, p.r); % propulsive efficiency

C_T = 4 * res.T / (p.D^2 * p.rho * p.Omega_n^2 * p.D^2);   	% thrust coefficient
C_P = 4 * res.P / (p.rho * p.Omega_n^3 * p.D^5);           	% power coefficient
J = p.v_inf / (p.Omega_n * p.D);                          	% advance ratio

end