function printSec(res, j, p)
%PRINTSEC prints the information on a particular section
%   res: results
%   j: studied section
%   p:parameters
%   

dispLog(['beta_2  ', num2str(rad2deg(res.beta_2(j)))], p.verb2)
dispLog(['aoa     ', num2str(rad2deg(res.aoa(j)))], p.verb2)
dispLog(['v_a3    ', num2str(res.v_a3(j))], p.verb2)
dispLog(['v_u2p   ', num2str(res.v_u2p(j))], p.verb2)
dispLog(' ', p.verb2)
dispLog(' ', p.verb2)
dispLog(' ', p.verb2)

end

