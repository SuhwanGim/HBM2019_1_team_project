%% load data 
basedir = '/Users/WIWIFH/Dropbox/github/experiment/HBM2019_1_team_project/results_data';
total_dat = []; 
for sub_i=1:2
    for run_i=1:6
        temp_dat =[];
        datFile = fullfile(basedir,sprintf('EST%04d_RUN%02d_01-Jun-2019.mat',sub_i,run_i));
        temp_dat=load(datFile);
        ts{sub_i}=temp_dat.dat.ts;
        runTime{sub_i}{run_i} = temp_dat.dat.RunStartTime;
        total_dat{sub_i}.dat(((run_i-1)*5+1):((run_i)*5)) = temp_dat.dat.dat(((run_i-1)*5+1):((run_i)*5)); 
    end
end

%% Duration
% 1) Trial duration
% 2) Movie duration
% 3) Math duration
% 4) Resting duration
% 5) Short quiz duration

% 6) math quiz condition (1 = Easy     / 2 = Difficulty);
% 7) movie condition     (1 = Postivie / 2 = Neutral);
dur_dat = [];
for sub_i = 1:2
    for trial_i = 1:30
        temp_t = [];
        temp_t = total_dat{sub_i}.dat{trial_i};
        dur_dat{sub_i}(1,trial_i) = temp_t.TrialEndTimestamp - temp_t.TrialStartTimestamp; %trial duration
        dur_dat{sub_i}(2,trial_i) = temp_t.Movie_EndTime - temp_t.ITI_EndTime; %movie duration
        if temp_t.rt == 0
            dur_dat{sub_i}(3,trial_i) = temp_t.Math_EndTime - temp_t.Math_StartTime;           
        else
            dur_dat{sub_i}(3,trial_i) = temp_t.rt;
        end
        dur_dat{sub_i}(4,trial_i) = temp_t.resting_EndTime - temp_t.ISI2_EndTime;
        if temp_t.ShortQuiz_response_duration == 0
            dur_dat{sub_i}(5,trial_i) = temp_t.ShortQuiz_Dration;
        else
            dur_dat{sub_i}(5,trial_i) =  temp_t.ShortQuiz_EndTime - temp_t.ISI3_EndTime;
        end
        
        
    end
    dur_dat{sub_i}(6,:) = ts{sub_i}.math_cond; %math quiz conditoin    (1 = Easy     / 2 = Difficulty);
    dur_dat{sub_i}(7,:) = ts{sub_i}.mv_cond; %movie condition          (1 = Postivie / 2 = Neutral);
end
%% Onsets
% 1) movie start
% 2) math start
% 3) resting start
% 4) short quiz strat

ons_dat = [];
for sub_i=1:2    
    for run_i = 1:6 
        start_t = runTime{sub_i}{run_i}; %disdaq = 10 secs
        for trial_i = ((run_i-1)*5+1):((run_i)*5)
            temp_t = total_dat{sub_i}.dat{trial_i};
            ons_dat{sub_i}(1,trial_i) = temp_t.ITI_EndTime - start_t; % movie
            ons_dat{sub_i}(2,trial_i) = temp_t.ISI1_EndTime - start_t; % math 
            ons_dat{sub_i}(3,trial_i) = temp_t.ISI2_EndTime - start_t; % resting
            ons_dat{sub_i}(4,trial_i) = temp_t.ISI3_EndTime - start_t; % short quiz
        end
        
    end
end
%plot(1:30,ons_dat{1} + dur_dat{1}(2:5,:),'o')
%%

save('onsets_duration.mat','dur_dat','ons_dat');
%% Names  
% 1) 
name_dat = [];
for sub_i =1:2
    if ts.math_cond 
    name_dat{sub_i} = ts
    end
end

    

%% names


