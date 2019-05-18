function main_task(SID,runNumber, varargin)
% 
%   ** Descrip ** 
% This function is for running experimental paradigm (Post-encoding stress
% effect on episodic memory). The four steps is included here. 
% (disdaq = 10 secs).
%
%    1) Movie clip: Neutral and Emotional
%    2) Math problem: Difficulty and Easy
%    3) Report: level of stress and quiz for previous movie clips
%
%   ** Requirements **
%    1) Latest PsychophysicsToolbox
%    2) Mac OS 
%   ** (optional)
%    3) Labjack driver (for biopac)
%
%
%
%   ====================================================================%
%   ** Usage **
%       main_task('EST001', 'fmri','biopac');
%   ** Input **
%       - SID: name of subject 
%   ** Optional Input **
%       - 'test': Lower reslutions. (1280 720 px)
%       - 'fmri': If you run this function in MRI settings. This option can
%       receive 's' trigger from sync box.
%       - 'biopac': For sending biopac sync signal. 
%   ====================================================================

%% Parse varargin
testmode = false;
USE_BIOPAC = false;
dofmri = false;
USE_EYELINK = false;
start_trial = 1;
for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            case {'test'}
                testmode = true;
            case {'fmri'}
                dofmri = true;
            case {'biopac','Biopac','BIOPAC','bio','BIopac'}
                USE_BIOPAC = true;
                channel_n = 3;
                biopac_channel = 0;
                ljHandle = BIOPAC_setup(channel_n); % BIOPAC SETUP
%             case {'eyelink', 'eye', 'eyetrack'}
%                 USE_EYELINK = true;
        end
    end
end

%% GLOBAL vaiable
global theWindow W H; % window property
global white red red_Alpha orange bgcolor yellow; % color
global window_rect % rating scale
global fontsize;
%% SETUP: DATA and Subject INFO
savedir = 'results_data';
[fname,start_trial, SID] = subjectinfo_check(SID,runNumber,savedir); % subfunction %start_trial
if exist(fname, 'file'), load(fname); end
% save data using the canlab_dataset object  % ??
dat.version = 'EPST_v1_05-18-2019_Suhwan';
dat.subject = SID;
dat.datafile = fname;
dat.starttime = datestr(clock, 0); % date-time
dat.starttime_getsecs = GetSecs; % in the same format of timestamps for each trial
dat.runNumber = runNumber;
save(dat.datafile,'dat');
%% SETUP: Screen
Screen('Clear');
Screen('CloseAll');
window_num = 0;
if testmode
    window_rect = [1 1 1280 720]; % in the test mode, use a little smaller screen [but, wide resoultions]    
    fontsize = 20;
else
    screens = Screen('Screens');
    window_num = screens(end); % the last window
    Screen('Preference', 'SkipSyncTests', 1);
    window_info = Screen('Resolution', window_num);
    window_rect = [0 0 window_info.width window_info.height]; % full screen
    fontsize = 32;
    HideCursor();
end
W = window_rect(3); %width of screen
H = window_rect(4); %height of screen

bgcolor = 80;
white = 255;
red = [255 0 0];
red_Alpha = [255 164 0 130]; % RGB + A(Level of tranceprency: for social Cue)
orange = [255 164 0];
yellow = [255 220 0];


%% SETUP: Parameters
stimText = '+';
%% START: Screen
theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8'); % text encoding
Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % For using transparency e.g., alpha value of [R G B alpha]
Screen('TextSize', theWindow, fontsize);

try        
    %% SETUP: INSTRUCTION BEFORE START
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('space'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_experiment;
        end
        display_expmessage('실험자는 모든 것이 잘 준비되었는지 체크해주세요 (PATHWAY, BIOPAC, 등등). \n모두 준비되었으면 SPACE BAR를 눌러주세요.'); % until space; see subfunctions
    end
    
    % 1 seconds: BIOPAC
    while (1)
        [~,~,keyCode] = KbCheck;
        % if this is for fMRI experiment, it will start with "s",
        % but if behavioral, it will start with "r" key.
        if dofmri
            if keyCode(KbName('s'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
        else
            if keyCode(KbName('r'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
        end
        display_runmessage(1, 1, dofmri); % until 5 or r; see subfunctions
    end
    
    
    if dofmri
        dat.disdaq_sec = 10; 
        fmri_t = GetSecs;
        % gap between 5 key push and the first stimuli (disdaqs: dat.disdaq_sec)        
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        DrawFormattedText(theWindow, double('시작합니다...'), 'center', 'center', white, [], [], [], 1.2); % 4 seconds
        Screen('Flip', theWindow);
        dat.runscan_starttime = GetSecs;
        waitsec_fromstarttime(fmri_t, 4);
        
        % 6 seconds: Blank        
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(fmri_t, dat.disdaq_sec); % ADJUST THIS
    end
    
    % Turn on biopac signal
    if USE_BIOPAC
        bio_t = GetSecs;
        dat.biopac_triggertime = bio_t; %BIOPAC timestamp
        BIOPAC_trigger(ljHandle, biopac_channel, 'on');
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(bio_t, 2); % ADJUST THIS
    end
    
    % Turn off biopac signal
    if USE_BIOPAC
        BIOPAC_trigger(ljHandle, biopac_channel, 'off');
    end
        
    
    %% START: EXPERIMENT  
    dat.RunStartTime = GetSecs;
    for trial_i = start_trial:10
        % Start of Trial
        trial_t = GetSecs;
        dat.dat{trial_i}.TrialStartTimestamp=trial_t; 
        % 1. ITI
        
        dat.dat{trial_i}.ITI_EndTime=GetSecs; 
        % 2. MOVIE CLIP
        
        dat.dat{trial_i}.Movie_EndTime=GetSecs; 
        % 3. ISI1
        
        dat.dat{trial_i}.ISI1_EndTime=GetSecs; 
        % 4. MATH PROBLEM 
        
        dat.dat{trial_i}.Math_EndTime=GetSecs; 
        % 5. ISI2
        
        dat.dat{trial_i}.ISI2_EndTime=GetSecs; 
        % 6. Short Quiz
        
        dat.dat{trial_i}.ShortQuiz_EndTime=GetSecs; 
        % 7. ISI3
        
        dat.dat{trial_i}.ISI3_EndTime=GetSecs; 
        % 8. REPORT level of stress        
        
        dat.dat{trial_i}.ReportStress_EndTime=GetSecs; 
        
        % End of trial
        dat.dat{trial_i}.TrialEndTimestamp=GetSecs; 
        save(dat.datafile, '-append', 'dat');
    end
        
    
    
    
    %% FINALZING EXPERIMENT    
    dat.RunEndTime = GetSecs;
    DrawFormattedText(theWindow, double(stimText), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    
    waitsec_fromstarttime(t_time, 10);      
    save(dat.datafile, '-append', 'dat');
    
    if USE_BIOPAC %end BIOPAC
        bio_t = GetSecs;
        dat.biopac_endtime = bio_t;% biopac end timestamp
        BIOPAC_trigger(ljHandle, biopac_channel, 'on');
        waitsec_fromstarttime(bio_t, 0.2);
        BIOPAC_trigger(ljHandle, biopac_channel, 'off');
    end
    save(dat.datafile, '-append', 'dat');
    waitsec_fromstarttime(GetSecs, 2);
    %% END MESSAGE
    if runNumber == 5
        str = '실험이 종료되었습니다.\n 잠시만 기다려주세요 (space)';
    else
        str = '잠시만 기다려주세요 (space)';
    end
    display_expmessage(str);
    
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('q'))==1
            break
        elseif keyCode(KbName('space'))== 1
            break
        end
    end
    
    
    ShowCursor();
    Screen('Clear');
    Screen('CloseAll');
    
    
catch
    % ERROR
    disp(err);
    ShowCursor();
    for i = 1:numel(err.stack)
        disp(err.stack(i));
    end
    abort_experiment;
end


end

function display_runmessage(run_i, run_num, dofmri)

% MESSAGE FOR EACH RUN

% HERE: YOU CAN ADD MESSAGES FOR EACH RUN USING RUN_NUM and RUN_I

global theWindow white bgcolor window_rect; % rating scale

if dofmri
    if run_i <= run_num % you can customize the run start message using run_num and run_i
        Run_start_text = double('참가자가 준비되었으면 이미징을 시작합니다 (s).');
    end
else
    if run_i <= run_num
        Run_start_text = double('참가자가 준비되었으면, r을 눌러주세요.');
    end
end

% display
Screen(theWindow,'FillRect',bgcolor, window_rect);
DrawFormattedText(theWindow, Run_start_text, 'center', 'center', white, [], [], [], 1.5);
Screen('Flip', theWindow);

end

function abort_experiment(varargin)

% ABORT the experiment
%
% abort_experiment(varargin)

str = 'Experiment aborted.';

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'error'}
                str = 'Experiment aborted by error.';
            case {'manual'}
                str = 'Experiment aborted by the experimenter.';            
        end
    end
end


ShowCursor; %unhide mouse
Screen('CloseAll'); %relinquish screen control
disp(str); %present this text in command window

end

function display_expmessage(msg)
% diplay_expmessage("ad;slkja;l�Ҷ�Ҷ� \n���Ӥ��ո�����");
% type each MESSAGE

global theWindow white bgcolor window_rect; % rating scale

EXP_start_text = double(msg);

% display
Screen(theWindow,'FillRect',bgcolor, window_rect);
DrawFormattedText(theWindow, EXP_start_text, 'center', 'center', white, [], [], [], 1.5);
Screen('Flip', theWindow);

end

