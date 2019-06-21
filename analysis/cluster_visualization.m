[rpos, rneg] = table(rdat);
trdat = table(rdat,'k',20);






list = which('ROI_MNI_V5_List.mat');
vol = which('ROI_MNI_V5_vol.mat');

autolabel_regions_using_atlas(rdat, atlas(which('ROI_MNI_V5.nii')),trdat);

%% Save clustger files
cl_dir = '/Users/WIWIFH/Dropbox/github/experiment/HBM2019_1_team_project/image/cluster/';
mask = which('gray_matter_mask.nii');

for sub_i=1:2
    subdir = sprintf('Sub%02d',sub_i);
    cl_fulldir = filenames(fullfile(cl_dir,subdir,'*.nii'));
    for file_i =1:length(cl_fulldir)        
        filename = []; dat =[]; rdat = []; 
        
        dat = fmri_data(cl_fulldir(file_i),mask);
        rdat=region(dat);        
        [cdir,name] = fileparts(cl_fulldir{file_i});
        filename = fullfile(cdir,[name, '.txt']);
        clusters = cluster_table_aal2(rdat, 0,0,'writefile',filename);
    end
      
end

%% Save cluster images
cl_dir = '/Users/WIWIFH/Dropbox/github/experiment/HBM2019_1_team_project/image/cluster/';
mask = which('gray_matter_mask.nii');

for sub_i=1:2
    subdir = sprintf('Sub%02d',sub_i);
    cl_fulldir = filenames(fullfile(cl_dir,subdir,'*.nii'));
    for file_i =1:length(cl_fulldir)        
        close all;
        filename = []; dat =[]; rdat = []; 
        
        dat = fmri_data(cl_fulldir(file_i),mask);
        rdat=region(dat);        
        [cdir,name] = fileparts(cl_fulldir{file_i});
        filename = fullfile(cdir,[name, '.png']);
        montage(rdat,'full');
        saveas(gcf,filename);
        %clusters = cluster_table_aal2(rdat, 0,0,'writefile',filename);
    end
      
end