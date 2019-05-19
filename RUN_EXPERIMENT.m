%%
clc; clear; 

%% SETTINGS: Path
addpath(genpath(pwd));
%% SETTINGS: Subject name and optional input
SID = 'EST001'; % SID = 'TEST';
argTxt = {'test','fmri','biopac'};
[ts, TR] = generate_exp_cond();
%% ===================================================================== %%

% ------------ BEFORE YOU START EXPERIMENT,                    ---------- %

% ------------ PLEASE, CHECKT OUT YOUR AN "EXPERIMENT SETTINGS" --------- %

% ======================================================================= %
%% RUN
%
main_task(SID,ts, 1, argTxt);
%%
main_task(SID,ts, 2, argTxt);
%%
main_task(SID,ts, 3, argTxt);
%%
main_task(SID,ts, 4, argTxt);
%%
main_task(SID,ts, 5, argTxt);
