function printQ3(T, P, eta, collective, engine_power)
%PRINTQ1 prints the thrust, power and propulsive efficiency
%   res: results
%   p: parameters
%

disp('<strong>Question 3</strong>')
disp( '----------------------------------------------------')
disp(['theta [°]  | ', num2str(rad2deg(collective), '%.2f')])
disp( '----------------------------------------------------')
disp(['Thrust [N] | ', num2str(T, '%.2f')])
disp(['Power [hp] | ', num2str(P/745.7, '%.2f'), ...
      ' -> ', num2str(P/engine_power*100, '%.2f'), '% of engine power (', ...
      num2str(engine_power/745.7, '%.2f'), ' hp)'])
disp(['eta   [%]  | ', num2str(eta*100, '%.2f')])
disp( '----------------------------------------------------')
disp( ' ')
disp( ' ')
disp( ' ')

end