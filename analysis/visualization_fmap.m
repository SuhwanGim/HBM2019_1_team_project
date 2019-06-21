%% SETUP
mask =  which('gray_matter_mask.nii');
% input_contrasts{1} = {{'Movie_'}}; %movie effect 
% input_contrasts{2} = {{'Math_'}}; %Math effect
% input_contrasts{3} = {{'RESTING'}}; %Resting effect
% input_contrasts{4} = {{'QUIZ'}}; %Quiz effect
% 
% input_contrasts{5} = {{'Math_Diff'} {'Math_Easy'}}; %High math -low math
% input_contrasts{6} = {{'Movie_pos'} {'Movie_neutral'}}; %pos movie - neut movie
% input_contrasts{7} = {{'RESTINGMATH_EASY'} {'RESTINGMATH_DIFF'}}; %Resting
% 
% input_contrasts{8} = {{'RESTINGMATH_DIFF'} {'RESTINGMATH_EASY'}}; %Resting math
% input_contrasts{9} = {{'RESTINGMATH_EASY_MOV_POS' 'RESTINGMATH_DIFF_MOV_POS'} {'RESTINGMATH_EASY_MOV_NEUT''RESTINGMATH_DIFF_MOV_NEUT'}}; %MOVIE effect
%
% input_contrasts{10} = {{'RESTINGMATH_EASY_MOV_POS' 'RESTINGMATH_DIFF_MOV_NEUT'} {'RESTINGMATH_EASY_MOV_NEUT' 'RESTINGMATH_DIFF_MOV_POS'}}; %Resting move
% 
% input_contrasts{11} = {{'QUIZMATH_EASY'} {'QUIZMATH_DIFF'}}; %Resting math
% 
% input_contrasts{12} = {{'QUIZMATH_EASY_MOV_POS' 'QUIZMATH_DIFF_MOV_POS'} {'QUIZMATH_EASY_MOV_NEUT' 'QUIZMATH_DIFF_MOV_NEUT'}}; %Resting math
% input_contrasts{13} = {{'QUIZMATH_EASY_MOV_POS' 'QUIZMATH_DIFF_MOV_NEUT'} {'QUIZMATH_EASY_MOV_NEUT' 'QUIZMATH_DIFF_MOV_POS'}}; %Resting math
%% ========================================== %%
%             sub_1                            %
% ============================================ %
cd('/Users/WIWIFH/Dropbox/github/experiment/HBM2019_1_team_project/image/fmap/sub_1');
%%
dat=[];
close all;
% 1. Math activity (Diff - Easy) 
dat = fmri_data('Math_diff_easy.nii',mask);
write(dat)
brain_activations_wani(region(dat),'all')
h = suptitle('Math: Easy vs. Diff');
h.FontSize = 32;
saveas(gcf, 'Math_diff_easy.png');
%% 2. Resting activity (Math diff and > easy)
close all;
dat = [];
dat = fmri_data('Resting_math_diff_easy.nii', mask);
write(dat);
brain_activations_wani(region(dat),'all');
h = suptitle('Resting: Diff vs. easy');
h.FontSize = 32;
saveas(gcf, 'Resting_math_diff_easy.png');
%% 3. Resting activity (Movie Pos vs neu)
close all;
dat = [];
dat = fmri_data('Resting_movie_pos_neu.nii', mask);
write(dat);
brain_activations_wani(region(dat),'all');
h = suptitle('Resting: Pos vs. Neu');
h.FontSize = 32;
saveas(gcf, 'Resting_movie_pos_neu.png');
%% 4. Resting activith (anova-typed)
close all;
dat = [];
dat = fmri_data('Resting_anova.nii', mask);
write(dat);
brain_activations_wani(region(dat),'all');
h = suptitle('Resting: ANOVA');
h.FontSize = 32;
saveas(gcf, 'Resting_anova.png');
%% 5. Resting activity
close all;
dat = [];
dat = fmri_data('Main_resting.nii', mask);
write(dat);
brain_activations_wani(region(dat),'all');
h = suptitle('Resting: main effects');
h.FontSize = 32;
 saveas(gcf, 'Main_resting.png');
 %% 6. short quiz
close all;
dat = [];
dat = fmri_data('short_quiz_main.nii', mask);
write(dat);
brain_activations_wani(region(dat),'all');
h = suptitle('Short Quiz: main effects');
h.FontSize = 32;
 saveas(gcf, 'short_quiz_main.png');
%% 7. short quiz Diff - easy
close all;
dat = [];
dat = fmri_data('shortquiz_easy_diff.nii', mask);
write(dat);
brain_activations_wani(region(dat),'all');
h = suptitle('Short Quiz: Easy vs. Diff');
h.FontSize = 32;
 saveas(gcf, 'shortquiz_easy_diff.png');
%% ========================================== %%
%             sub_2                            %
% ============================================ %
cd('/Users/WIWIFH/Dropbox/github/experiment/HBM2019_1_team_project/image/fmap/sub_2');
dat=[];
close all;
% 1. Math activity (Diff - Easy) 
dat = fmri_data('Math_diff_easy.nii',mask);
write(dat)
brain_activations_wani(region(dat),'all')
h = suptitle('Math: Easy vs. Diff');
h.FontSize = 32;
saveas(gcf, 'Math_diff_easy.png');
 %% 2. Resting activity (Math diff and > easy)
close all;
dat = [];
dat = fmri_data('resting_math_diff_easy.nii', mask);
write(dat);
brain_activations_wani(region(dat),'all');
h = suptitle('Resting: Easy vs. Diff');
h.FontSize = 32;
saveas(gcf, 'Resting_math_diff_easy.png');
%% 3. Resting activity (Movie Pos vs neu)
close all;
dat = [];
dat = fmri_data('resting_movie_pos_neutral.nii', mask);
write(dat);
brain_activations_wani(region(dat),'all');
h = suptitle('Resting: Pos vs neu');
h.FontSize = 32;
saveas(gcf, 'Resting_movie_pos_neu.png');
%% 4. Resting activith (anova-typed)
close all;
dat = [];
dat = fmri_data('resting_anova.nii', mask);
write(dat);
brain_activations_wani(region(dat),'all');
h = suptitle('Resting: ANOVA');
h.FontSize = 32;
saveas(gcf, 'Resting_anova.png');
%% 5. Resting activity
close all;
dat = [];
dat = fmri_data('resting_main.nii', mask);
write(dat);
brain_activations_wani(region(dat),'all');
h = suptitle('Resting: main effects');
h.FontSize = 32;
 saveas(gcf, 'resting_main.png');
%% 6. short quiz
close all;
dat = [];
dat = fmri_data('short_quiz_main.nii', mask);
write(dat);
brain_activations_wani(region(dat),'all');
h = suptitle('Short Quiz: main effects');
h.FontSize = 32;
 saveas(gcf, 'short_quiz_main.png');
%% 7. short quiz Diff - easy
close all;
dat = [];
dat = fmri_data('short_quiz_easy_diff.nii', mask);
write(dat);
brain_activations_wani(region(dat),'all');
h = suptitle('Short Quiz: Easy vs. Diff');
h.FontSize = 32;
 saveas(gcf, 'short_quiz_easy_diff.png');

 
%% ========================================== %%
%             MASK                             %
% ============================================ %
mask_episodic_memory = fmri_data(fullfile('/Users/WIWIFH/Dropbox/github/experiment/HBM2019_1_team_project/','mask','episodic_memory_mask.nii'),mask);
mask_memory_encoding = fmri_data(fullfile('/Users/WIWIFH/Dropbox/github/experiment/HBM2019_1_team_project/','mask','memory_encoding_memory_mask.nii'),mask);
%%
brain_activations_wani(region(mask_episodic_memory),'all');
%%
brain_activations_wani(region(mask_memory_encoding),'all');

 

