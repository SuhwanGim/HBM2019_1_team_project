%% SETUP: Load and mask name

load(which('cluster_Fan_Net_r280.mat'),'cluster_Fan_Net');
fanMask = fmri_data(which('Fan_et_al_atlas_r280.nii'));
%%
%sequent_memory = {'posterior parietal cortex'};
sequent_memory = {'superior parietal lobule (BA7','superior parietal lobule (BA5'};              
               
SE_mask_idx = []; SF_mask_idx = [];
for i=1:280
    for se_i = 1:length(sequent_memory)
        if contains(cluster_Fan_Net.full_names(i),sequent_memory{se_i})
            SE_mask_idx = [SE_mask_idx i];
        end
    end
    
end

%orthviews(cluster_Fan_Net.r_2mm(SE_mask_idx));
brain_activations_wani(cluster_Fan_Net.r_2mm(SE_mask_idx),'all');