
%% ====================================================================== %
%                        1. Neurosynth
%  ====================================================================== %
filedir = '/Users/WIWIFH/Downloads';
filename1 = 'episodic_memory_association-test_z_FDR_0.01.nii';
filename2 = 'memory_encoding_association-test_z_FDR_0.01.nii';
episodic_memory_mask = fmri_data(fullfile(filedir,filename1),which('gray_matter_mask.nii'));
memory_encoding_mask = fmri_data(fullfile(filedir,filename2),which('gray_matter_mask.nii'));
%% Make data into mask
episodic_memory_mask.dat(memory_encoding_mask.dat ~= 0) = 1;
memory_encoding_mask.dat(memory_encoding_mask.dat ~= 0) = 1;
%% Write the nii
episodic_memory_mask.fullpath = fullfile('/Users/WIWIFH/Dropbox/github/experiment/HBM2019_1_team_project/','mask','episodic_memory_mask.nii');
memory_encoding_mask.fullpath = fullfile('/Users/WIWIFH/Dropbox/github/experiment/HBM2019_1_team_project/','mask','memory_encoding_memory_mask.nii');
write(episodic_memory_mask);
write(memory_encoding_mask);

%% ====================================================================== %
%                        2. Kim (2011) and eLife paper
%  ====================================================================== %
% 1. Paper를 참고 해서 각 네트워크를 Fan_mask에서 뽑아내고 
% 2. Consolidation에 해당하는 부분들을 따로 ttest를 하자
% 3. 아마 beta-img들을 aggregate해서 fmri_test/ttest를 돌리면 될 듯? 
% 4. 그리고 가능하면 Corrlation Matirx도 그려보자
% 5. 그리고 아마 Safari의 비슷한 페이퍼에 대한 것을 보고 비교하자
% 6. 그리고 Describe한 뒤에 끝 
%% SETUP: Load and mask name

load(which('cluster_Fan_Net_r280.mat'),'cluster_Fan_Net');
fanMask = fmri_data(which('Fan_et_al_atlas_r280.nii'));
sequent_memory = {'Lt. inferior frontal gyrus', ...
                   'fusiform gyrus', ...
                   'hippocampus', ...
                   'premotor', ...
                   'posterior parietal cortex'};
               
               
forget_memory = {'superior frontal gyrus', ...
                 'anterior midline cortex', ...
                 'posterior midline cortex', ...
                 'temporoparietal junction', ...
                 'superior frontal cortex'};
%%
SE_mask_idx = []; SF_mask_idx = [];
for i=1:280
    for se_i = 1:length(sequent_memory)
        if contains(cluster_Fan_Net.full_names(i),sequent_memory{se_i})
            SE_mask_idx = [SE_mask_idx i];
        end
    end
    for sf_i = 1:length(forget_memory)
        if contains(cluster_Fan_Net.full_names(i),forget_memory{sf_i})
            SF_mask_idx = [SF_mask_idx i];
        end
    end
    
end

%orthviews(cluster_Fan_Net.r_2mm(mask_idx));

