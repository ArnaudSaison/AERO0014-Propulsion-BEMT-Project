% Aerospace Propulsion: Arnaud Saison 2022/22/02
% 
% BEM code
% 

%%
clear all; close all; clc; %warning off;
p.verb1 = 1;
p.verb2 = 0;

%%
% Initializing parameters
TP_Param;

% using the BEM function
[res, p] = BEM(p);
