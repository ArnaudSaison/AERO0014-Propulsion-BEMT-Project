function printQ1(T, P, eta_P, collective)
%PRINTQ1 prints the thrust, power and propulsive efficiency
%   res: results
%   p: parameters
%

disp('<strong>Question 1</strong>')
disp( '---------------------------------------------------------')
disp(['theta [°]  | ', num2str(rad2deg(collective), '%-12.0f')])
disp( '---------------------------------------------------------')
disp(['Thrust [N] | ', num2str(T, '%-12.2f')])
disp(['Power [hp] | ', num2str(P/746, '%-12.2f')])
disp(['eta_P [%]  | ', num2str(eta_P*100, '%-12.2f')])
disp( '---------------------------------------------------------')
disp( ' ')
disp( ' ')
disp( ' ')

end

