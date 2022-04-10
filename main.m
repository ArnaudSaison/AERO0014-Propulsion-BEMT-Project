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
%   The project files also contain the resolution of exercise 5 from the
%   first exercise session.
% 
% User guide:
%   'main.m'            solves the 3 questions for the project
%   'propParam.m'       contains all the parameters of the propeller
%   'projParam.m'       contains all the parameters to answer the questions 
%                       of the project
% 
% File Structure:
%   BEM/
%       'BEM.m'         runs all the code needed to solve a propeller
%       'propeller.m'   solves all the sections of the propeller
%       'section.m'     solves a particular section of the propeller
%       'intProp.m'     integrates parameters over the whole propeller
%   TP/
%       'TP1EX5.m'      solves exercise 5 of the first exercise session of 
%                       the course
%       'TP_Param.m'    contains all parameters to solve the exercise
%   utils/
%       'coeffCleanup.m'removes impossible values in the coefficients
%       'dispLog.m'     function to properly display logs that can be
%                       turned off
%       'fig2pdf.M'     converts a figure to pdf given its size
%       'printCoeffs.m' prints C_T, C_P and eta
%       'printFigs.m'   displays all the figures (contains all figure
%                       parameters)
%       'printInt.m'    prints the results after integration
%       'printQ1.m'     prints the results of question 1
%       'printQ3.m'     prints the results of question 3
%       'printSec.m'    prints section results
%       'printTot.m'    prints propeller results
% 
% Data Structure: (stored in Q1, Q2 an Q3 structures)
%   p                   containes all parameters
%   res                 contains results
%

%% ========================================================================
% Intialization
% =========================================================================
addpath(genpath('.')); % use restoredefaultpath to reinitialize
clc; close all; clear;

% 1 to display logs in command window (verbose mode) / 0 for no log
p.verb1 = 0; % debugging
p.verb2 = 0; % less important debugging
p.pdf = 1;   % generate PDF of figures (takes a few seconds and might make MATLAB crash !!!)
p.pdf_folder = './Figures/'; % folde in which these PDF figures are stored


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
    [Q1.res, p] = BEM(p);

    Q1.T(col) = Q1.res.T;
    Q1.P(col) = Q1.res.P;
    Q1.eta_P(col) = Q1.res.eta_P;
    Q1.eta(col) = Q1.res.eta;
end
clear col;

printQ1(Q1.T, Q1.P, Q1.eta_P, Q1.eta, p.collectives, Q1.res.J)


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
        Q2.eta(col, speed) = res.eta;
    end
    
    Q2.J(speed) = res.J;
end
clear speed col;

% cleaning up the data to removing impossible values
Q2.C_T = coeffCleanup(Q2.C_T, -1, 0, 10);
Q2.C_P = coeffCleanup(Q2.C_P, -1, 0, 10);
Q2.eta = coeffCleanup(Q2.eta, -1, 0, 1);

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

% starting values of the method (known boundaries)
Q3.a = 0 /180*pi;
Q3.b = 90 /180*pi;

Q3.i = 1;

while p.Q3_max_iter >= Q3.i && (Q3.b - Q3.a) > p.Q3_tol
    % using middle value
    p.collective = (Q3.a + Q3.b) / 2;
    [Q3.res, p] = BEM(p);
    
    % choosing new boundaries
    if p.drag_force < Q3.res.T
        Q3.b = p.collective;
        
    else % greater than searched value
        Q3.a = p.collective;
        
    end
    
    % iteration increment
    Q3.i = Q3.i+1;
end

if p.Q3_max_iter >= Q3.i
    disp(['Q3 converged after ', num2str(Q3.i), ' iterations']);
else
    warning('Q3 did not converge')
end

Q3.p = p;
clear p;

printQ3(Q3.res.T, Q3.res.P, Q3.res.eta, Q3.p.collective, Q3.p.engine_max_power);






