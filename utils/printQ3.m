function printQ3(T, P, eta_P, collective, engine_power)
%PRINTQ1 prints the thrust, power and propulsive efficiency
%   res: results
%   p: parameters
%

disp('<strong>Question 3</strong>')
disp( '----------------------------------------------------')
disp(['theta [°]  | ', num2str(rad2deg(collective))])
disp( '----------------------------------------------------')
disp(['Thrust [N] | ', num2str(T)])
disp(['Power [hp] | ', num2str(P/746), ...
      ' -> ', num2str(P/engine_power*100, '%.1f'), '% of engine power (', ...
      num2str(engine_power/746), ' hp)'])
disp(['eta_P [-]  | ', num2str(eta_P)])
disp( '----------------------------------------------------')
disp( ' ')
disp( ' ')
disp( ' ')

end