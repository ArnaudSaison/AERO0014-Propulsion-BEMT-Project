function [C_T, C_P, eta, eta_P, J] = coeffs(res, p)
%COEFFS computes the thrust and power coefficients and propulsive efficiency
%   res: results of the BEM code
%   p: parameters
%

u = res.v_u2(end) - res.w_u2(end);                          % tangential velocity
Delta_h = u * (res.v_u2p(end) - res.v_u2(end));             % enthalpy rise

eta  = res.T * p.v_inf / res.P;                          	% global efficiency
eta_h = (res.v_a3(end)^2 - p.v_inf^2) / (2*Delta_h);        % hydrodynamic efficiency
eta_P = eta / eta_h;                                        % propulsive efficiency

C_T = 4 * res.T / (p.D^2 * p.rho * p.Omega_n^2 * p.D^2);   	% thrust coefficient
C_P = 4 * res.P / (p.rho * p.Omega_n^3 * p.D^5);           	% power coefficient
J = p.v_inf / (p.Omega_n * p.D);                          	% advance ratio

end