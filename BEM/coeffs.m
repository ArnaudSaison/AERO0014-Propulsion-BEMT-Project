function [C_T, C_P, eta_P, J] = coeffs(res, p)
%COEFFS computes the thrust and power coefficients and propulsive efficiency
%   res: results of the BEM code
%   p: parameters
%

C_T = 4 * res.T / (p.D^2 * p.rho * p.Omega_n^2 * p.D^2);     % thrust coefficient
C_P = 4 * res.P / (p.rho * p.Omega_n^3 * p.D^5);             % power coefficient
eta_P = res.T * p.v_inf / res.P;                                    % propulsive efficiency
J = p.v_inf / (p.Omega / (2*pi) * p.D);                             % advance ratio

end