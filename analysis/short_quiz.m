
%% sub1
d = '/Users/WIWIFH/Dropbox/github/experiment/HBM2019_1_team_project/image/fmap/sub_1';
%sub1_img = fullfile(d, 'shortquiz_easy_diff.nii');
sub1_img = fullfile(d, 'short_quiz_main.nii');
dat = fmri_data(sub1_img,which('gray_matter_mask.nii'))
orthviews(dat);
%brain_activations_wani(dat,'all');


%% sub2
d1 = '/Users/WIWIFH/Dropbox/github/experiment/HBM2019_1_team_project/image/fmap/sub_2';
%sub2_img =  fullfile(d1, 'short_quiz_easy_diff.nii');
sub2_img =  fullfile(d1, 'short_quiz_main.nii');
dat = fmri_data(sub2_img,which('gray_matter_mask.nii'));
orthviews(dat);
%brain_activations_wani(dat,'all');



%% sub1
d = '/Users/WIWIFH/Dropbox/github/experiment/HBM2019_1_team_project/image/fmap/sub_1';
%sub1_img = fullfile(d, 'shortquiz_easy_diff.nii');
sub1_img = fullfile(d, 'Math_diff_easy.nii');
dat = fmri_data(sub1_img,which('gray_matter_mask.nii'))
orthviews(dat);
%brain_activations_wani(dat,'all');


%% sub2
d1 = '/Users/WIWIFH/Dropbox/github/experiment/HBM2019_1_team_project/image/fmap/sub_2';
%sub2_img =  fullfile(d1, 'short_quiz_easy_diff.nii');
sub2_img =  fullfile(d1, 'Math_diff_easy.nii');
dat = fmri_data(sub2_img,which('gray_matter_mask.nii'));
orthviews(dat);
%brain_activations_wani(dat,'all');
