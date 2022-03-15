function printFigs(Q2, p, pdf)
%PRINTFIGS prints the figures for question 2
%   pdf: 1 = prints figures to PDF / 0 = doesn't

% optional argument
if nargin == 2
    pdf = 0;
end

% text for the legends since they are all the same
legend_text = append('\theta = ', string(num2str(rad2deg(p.collectives)')), '°');

% 
fig.thrust = figure('Name', 'Thust coefficient as a function of the advance ratio');
plot(Q2.J, Q2.C_T);
xlim([0, max(Q2.J)]);
ylim([0, max(Q2.C_T,[],'all')]);
legend(legend_text, 'Location', 'Southwest');
xlabel('Advance ratio J [-]')
ylabel('Thrust coefficient C_T [-]');

%
fig.power = figure('Name', 'Power coefficient as a function of the advance ratio');
plot(Q2.J, Q2.C_P);
xlim([0, max(Q2.J)]);
ylim([0, max(Q2.C_P,[],'all')]);
legend(legend_text, 'Location', 'Southwest');
xlabel('Advance ratio J [-]')
ylabel('Power coefficient C_P [-]');

%
fig.eff = figure('Name', 'Propulsive efficiency as a function of the advance ratio');
plot(Q2.J, Q2.eta_P);
xlim([0, max(Q2.J)]);
ylim([0, 1]);
legend(legend_text, 'Location', 'Southwest');
xlabel('Advance ratio J [-]')
ylabel('Propulsive efficiency \eta_P [-]');

% printing to PDF
if pdf == 1
    fig2pdf(fig.thrust, 'ThrustAdvanceRatio', 1, 1.5, p.pdf_folder);
    fig2pdf(fig.power, 'PowerAdvanceRatio', 1, 1.5, p.pdf_folder);
    fig2pdf(fig.eff, 'EfficiencyAdvanceRatio', 1, 1.5, p.pdf_folder);
end

end

