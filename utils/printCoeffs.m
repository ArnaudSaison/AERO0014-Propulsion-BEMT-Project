function printCoeffs(res, p)
%PRINTCOEFFS prints the coefficients and efficiency
%   res: results
%   p: parameters
%

dispLog( '----------------------------------------------------', p.verb1, '')
dispLog(['C_T [-]    | ', num2str(res.C_T)], p.verb1, '')
dispLog(['C_P [-]    | ', num2str(res.C_P)], p.verb1, '')
dispLog(['eta [-]    | ', num2str(res.eta)], p.verb1, '')
dispLog( '----------------------------------------------------', p.verb1, '')

end

