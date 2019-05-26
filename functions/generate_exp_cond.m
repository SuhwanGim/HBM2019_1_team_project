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

%% SETUP: stimuli_path

%/Users/WIWIFH/Dropbox/github/experiment/movie_clips/N2.mp
basedir = '/Users/WIWIFH/Dropbox/github/experiment';
mv_name={'P1.mp4','N1.mp4','P2.mp4','N2.mp4','P3.mp4','N3.mp4',...
    'P4.mp4','N4.mp4','P5.mp4','N5.mp4'};
img_name = {'1.png','2.png','3.png','4.png','5.png','6.png',...
    '7.png','8.png','9.png','10.png'};
easy_img_name = fullfile(basedir,'Math_simuli','Math_Stimuli_easy',img_name);
hard_img_name = fullfile(basedir,'Math_simuli','Math_Stimuli_hard',img_name);
%% SETUP: condition
pot = [5 5 5 5 5; 3 7 5 5 5; 3 7 3 7 5; 4 6 4 6 5];
mv = repmat([1 2],1,5);     %1 = Positive %2 = neutral
math_p = repmat([1 2],1,5); %1 = Easy     %2 = hard
short_quiz = 1;
ITI = []; math_cond = []; quiz_cond = []; mv_cond =[]; math_img =repmat({''},1,nTrial);
% Generate sequences
for i=1:nTrial 
    rng('shuffle');
    mv_clip_name{i} = fullfile(basedir,'movie_clips',mv_name{i});    
    ITI=[ITI; pot(randperm(size(pot,1),1),randperm(5,5))];
    quiz_cond = [quiz_cond short_quiz(1)];
end
%math_cond = [math_cond math_p(randperm(2,1))];
% randomization: math 
c = randperm(nTrial); math_cond = math_p(c); 
math_img(math_cond == 1) = easy_img_name(randperm(5));
math_img(math_cond == 2) = hard_img_name(randperm(5));
% randomization: movie clip
c = randperm(nTrial); mv_cond = mv(c); mv_name = mv_name(c);

%% Save sequences
ts.ITI = ITI;
ts.math_cond = math_cond;
ts.quiz_cond = quiz_cond;
ts.mv_cond = mv_cond;
ts.mv_name = mv_name;
ts.math_img = math_img;
ts.descript = { 'ITI(trial_i,:): Total 25 secs' ;...
    'mv_cond(trial_i): Valence of Movie Clip (1=Postive / 2=Neutral)'; ...
    'mv_name{trial_i}: name of clip';...
    'math_img{trial_i}: fullpath of math img';...
    'math_cond(trial_i): Level of Math problem (1=Easy / 2= Difficulty)'; ...
    'quiz_cond(trial_i): quiz (1=quiz)'; ...
    'Suhwan Gim (2019.05.18)'};
ts.date = date;
end
