function [ts, TR] = generate_exp_cond(varargin)
% generate trial sequences, total seconds of sequences and number TR
%
% 
% ** Trial sequences **
%   1. ITI            : 3,5,7
%   2. MOVIE CLIP     : Neutral(1) / Postivie (2)
%   3. ISI1           : 3,5,7
%   4. MATH PROBLEM   : Easy (1) / Difficulty (2)
%   5. ISI2           : 3,5,7
%   6. Short Quiz     : one cond
%   7. ISI3           : 3,5,7
%
% ** Overall ITI **: 20 secs
% 

%% Parse varargin
TR = 0.46;
nTrial = 10;
for i = 1:length(varargin)
    if ischar(varargin{i})
        switch lower(varargin{i})
            case {'tr'}
                TR = varargin{i+1};
            case {'ntrial'}
                nTrial = varargin{i+1};            
        end
    end
end

%% SETUP
pot = [5 5 5 5; 3 7 5 5; 3 7 3 7];
mv = repmat([1 2],1,5); %1 = Positive %2 = neutral
%/Users/WIWIFH/Dropbox/github/experiment/movie_clips/N2.mp
basedir = '/Users/WIWIFH/Dropbox/github/experiment/movie_clips/';
mv_name={'P1.mp4','N1.mp4','P2.mp4','N2.mp4','P3.mp4','N3.mp4',...
    'P4.mp4','N4.mp4','P5.mp4','N5.mp4'};
math_p = repmat([1 2],1,5);
short_quiz = 1;
ITI = []; math_cond = []; quiz_cond = []; mv_cond =[];
% Generate sequences
for i=1:nTrial 
    mv_clip_name{i} = fullfile(basedir,mv_name{i});
    ITI=[ITI; pot(randperm(3,1),:)];
    quiz_cond = [quiz_cond short_quiz(1)];
end
%math_cond = [math_cond math_p(randperm(2,1))];
% randomization: math 
c = randperm(nTrial); math_cond = math_p(c); 
% randomization: movie clip
c = randperm(nTrial); mv_cond = mv(c); mv_name = mv_name(c);

%% Save sequences
ts.ITI = ITI;
ts.math_cond = math_cond;
ts.quiz_cond = quiz_cond;
ts.mv_cond = mv_cond;
ts.mv_name = mv_name;
ts.descript = { 'ITI(trial_i,:): Total 20 secs' ;...
    'mv_cond(trial_i): Valence of Movie Clip (1=Postive / 2=Neutral)'; ...
    'mv_name{trial_i}: name of clip';...
    'math_cond(trial_i): Level of Math problem (1=Easy / 2= Difficulty)'; ...
    'quiz_cond(trial_i): quiz (1=quiz)'; ...
    'Suhwan Gim (2019.05.18)'};
ts.date = date;
end
