function printInt(res, p)
%PRINTINT prints the results after integration
%   res: results
%   p: parameters
%   

dispLog( '----------------------------------------------------', p.verb1, '')
dispLog(['T [N]      | ', num2str(res.T)], p.verb1, '')
dispLog(['C [N/m]    | ', num2str(res.C)], p.verb1, '')
dispLog(['P [kW]     | ', num2str(res.P/1e3)], p.verb1, '')
dispLog( '----------------------------------------------------', p.verb1, '')

end

