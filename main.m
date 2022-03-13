% =========================================================================
% BEMT project
% =========================================================================
% Université de Liège
% AERO0014 Aerospace Propulsion
% Academic year: 2021-2022
% -------------------------------------------------------------------------
% Author: Arnaud Saison
% Date: 10 April 2022
% -------------------------------------------------------------------------
% Description:
%   Blade Element Momumentum Theroy. Computes the performance of a given
%   propeller using iterative processes and approximations.
% 
% User guide:
%   'main.m'            solves the questions of project
%   'propParam.m'       contains all the parameters of the propeller
%   'projParam.m'       contains all the parameters to answer the questions 
%                       of the project
% 
% File Structure:
%   BEM/
%       'BEM.m'     
%       'propeller.m'   solves all the sections of the propeller
%       'section.m'     solves a particular section of the propeller
%       'intProp.m'     integrates parameters over the whole propeller
%   TP/
%       'TP1EX5.m'      solves exercise 5 of the first exercise session of 
%                       the course
%   utils/
%       'dispLog.m'     function to properly display logs that can be
%                       turned off
%       'printSec.m'    print section results
%       'printTot.m'    print propeller results
%       'printProj.m'   print results of the project
%       'printFig.m'    print a figure to pdf
% 
% Data Structure:
%   p                   containes all parameters
%   p.proj              contains parameters only related to project
%   res                 contains results
%

%% ========================================================================
% Intialization
% =========================================================================
addpath(genpath('.')); % use restoredefaultpath to reinitialize
clc; close all; clear;

% 1 to display logs in command window (verbose mode) / 0 for no log
p.verb1 = 1; % important structured information
p.verb2 = 0; % less important debugging
p.pdf = 1;   % generate PDF of figures (takes a few seconds and might make MATLAB crash !!!)
p.pdfFolder = './Figures/'; % folde in which these PDF figures are stored


%% ========================================================================
% Question 1
% =========================================================================
% calculate the thrust, the power absorbed by the propeller and the 
% propulsive efficiency in cruise conditions for the following collective 
% pitches: 10, 20, 30 and 40 degree.

% Initializing parameters
propParam;
projParam;

% loop for the different collectives
for col = 1:length(p.collectives)
    p.collective = p.collectives(col);
    [res, p] = BEM(p);

    Q1.T(col) = res.T;
    Q1.P(col) = res.P;
    Q1.eta_P(col) = res.eta_P;
end
clear col;

printQ1(Q1.T, Q1.P, Q1.eta_P, p.collectives)


%% ========================================================================
% Question 2
% =========================================================================
% for these four collective pitches, plot the evolution of the thrust 
% coefficient, the power coefficient, the global efficiency of the 
% propeller with respect of the advance ratio (use airspeeds ranging 
% from 40 to 250 kts)

% Initializing parameters
propParam;
projParam;

for speed = 1:p.nb_airspeeds
    % changing the airspeed
    p.v_inf = p.airspeeds(speed);
    
    % loop for the different collectives
    for col = 1:p.nb_collectives
        p.collective = p.collectives(col);
        [res, p] = BEM(p);

        Q2.C_T(col, speed) = res.C_T;
        Q2.C_P(col, speed) = res.C_P;
        Q2.eta_P(col, speed) = res.eta_P;
    end
    
    Q2.J(speed) = res.J;
end
clear speed col;

% cleaning up the data to removing impossible values
Q2.C_T = coeffCleanup(Q2.C_T, -1);
Q2.C_P = coeffCleanup(Q2.C_P, -1);
Q2.eta_P = coeffCleanup(Q2.eta_P, -1);

% Printing the figures
printFigs(Q2, p, p.pdf);


%% ========================================================================
% Question 3
% =========================================================================
% determine the collective pitch setting required to generate exactly the 
% thrust needed for the cruise. Calculate the power absorbed by the 
% propeller and the global efficiency. Verify that cruise requires 
% roughly 75% of the maximum power of the engine.

% Initializing parameters
propParam;
projParam;



