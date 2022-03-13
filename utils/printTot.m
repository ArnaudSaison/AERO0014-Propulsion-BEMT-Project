function printTot(res, p)
%PRINTTOT prints the results for the whole propeller
%   res: results
%   p: parameters
%

dispLog( '----------------------------------------------------', p.verb1, '')
dispLog(['position   | ', num2str(p.pos)], p.verb1, '')
dispLog( '----------------------------------------------------', p.verb1, '')
dispLog(['beta_2 [°] | ', num2str(rad2deg(res.beta_2))], p.verb1, '')
dispLog(['aoa [°]    | ', num2str(rad2deg(res.aoa))], p.verb1, '')
dispLog(['Thrust [N] | ', num2str(res.dT)], p.verb1, '')
dispLog(['Power [kW] | ', num2str(res.dP/1e3)], p.verb1, '')
dispLog( '----------------------------------------------------', p.verb1, '')

end

