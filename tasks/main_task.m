function main_task(SID,ts, runNumber, varargin)
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
%       - ts: trial sequencs
%       - runNumber
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
%start_trial = 1;
iscomp = 3; % default: macbook keyboard

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            case {'test'}
                testmode = true;
            case {'fmri'}
                dofmri = true;
%             case {'biopac','Biopac','BIOPAC','bio','BIopac'}
%                 USE_BIOPAC = true;
%                 channel_n = 3;
%                 biopac_channel = 0;
%                 ljHandle = BIOPAC_setup(channel_n); % BIOPAC SETUP
%             case {'eyelink', 'eye', 'eyetrack'}
%                 USE_EYELINK = true;
            case {'macbook'}
                iscomp = 3;
            case {'imac'}
                iscomp = 1;
           
        end
    end
end

%% GLOBAL vaiable
global theWindow W H window_num; % window property
global white red red_Alpha orange bgcolor yellow; % color
global window_rect % rating scale
global fontsize;
global Participant; % response box
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
dat.ts = ts;
save(dat.datafile,'dat');
%% SETUP: External device name for matching
% ===== Experimenter
if iscomp == 1
    device(1).product = 'Apple Keyboard';   % imac scanner (full keyboard)
    device(1).vendorID= 1452;
elseif iscomp == 2
    device(1).product = 'Magic Keyboard';   % imac vcnl (short keyboard)
    device(1).vendorID= 1452;
elseif iscomp == 3
    device(1).product = 'Apple Internal Keyboard / Trackpad';   % macbook
    device(1).vendorID= 1452;
% elseif iscomp == 4
%     device(1).product = 'Magic Keyboard';         % my pc
%     device(1).vendorID = 1452;
end

% ===== Participant's button box
device(2).product = '932';
device(2).vendorID= [1240 6171];
    
Participant  = IDKeyboards(device(2));

%while(1)
%      [keyIsDown, t1, keyCode, deltaSecs] = KbCheck(Participant);
%end

% ===== Scanner trigger 
device(3).product = 'KeyWarrior8 Flex';
device(3).vendorID= 1984;

% Getkeyborad
% PsychHID('kbwait'm,
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
        display_expmessage('Check out all stuffs (Trigger, USB, etc). \n If all ready, press (SPACE BAR) button.'); % until space; see subfunctions
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
        DrawFormattedText(theWindow, double('Experiment will start soon.'), 'center', 'center', white, [], [], [], 1.2); % 4 seconds
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
        
    %% ========================================================= %
    %                   TRIAL START
    % ========================================================== %
    dat.RunStartTime = GetSecs;
    for trial_i = (runNumber*2-1):(runNumber*2) % start_trial:10
        movie_files = [];
        % Start of Trial
        trial_t = GetSecs;
        dat.dat{trial_i}.TrialStartTimestamp=trial_t; 
        % --------------------------------------------------------- %
        %         1. ITI
        % --------------------------------------------------------- %
        fixPoint(trial_t, ts.ITI(trial_i,1), white, '+') % ITI
        dat.dat{trial_i}.ITI_EndTime=GetSecs; 
        
        % --------------------------------------------------------- %
        %         2. MOVIE CLIP
        % --------------------------------------------------------- %
        %moive_files(trial_i) = fullfile(pwd,'examples1.mov');
        movie_files = ts.mv_name{trial_i};
        run_movie(movie_files);
        dat.dat{trial_i}.Movie_EndTime=GetSecs; 
        
        % --------------------------------------------------------- %
        %         3. ISI1
        % --------------------------------------------------------- %
        fixPoint(trial_t, ts.ITI(trial_i,2), white, '+') % ITI
        dat.dat{trial_i}.ISI1_EndTime=GetSecs; 
        
        % --------------------------------------------------------- %
        %         4. MATH PROBLEM 
        % --------------------------------------------------------- %
        showMath(ts.math_cond, secs);
        dat.dat{trial_i}.Math_EndTime=GetSecs; 
        
        % --------------------------------------------------------- %
        %         5. ISI2
        % --------------------------------------------------------- %
        fixPoint(trial_t, ts.ITI(trial_i,3), white, '+') % ITI
        dat.dat{trial_i}.ISI2_EndTime=GetSecs; 
        
        % --------------------------------------------------------- %
        %         6. Short Quiz
        % --------------------------------------------------------- %
        
        dat.dat{trial_i}.ShortQuiz_EndTime=GetSecs; 
        % --------------------------------------------------------- %
        %         7. ISI3
        % --------------------------------------------------------- %
        fixPoint(trial_t, ts.ITI(trial_i,4), white, '+') % ITI
        dat.dat{trial_i}.ISI3_EndTime=GetSecs; 

        % --------------------------------------------------------- %
        % 8. REPORT level of stress  (one to ten)
        % --------------------------------------------------------- %
        
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
        str = 'Experiment is over.\n Please, wait for seconds.  (space).';
    else
        str = 'Please, wait for seconds (space)';
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
    IOport('CloseALL');
    
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

% ======================================================================= %
%                   IN-LINE FUNCTION                                      %
% ======================================================================= %

function display_runmessage(run_i, run_num, dofmri)

% MESSAGE FOR EACH RUN

% HERE: YOU CAN ADD MESSAGES FOR EACH RUN USING RUN_NUM and RUN_I

global theWindow white bgcolor window_rect; % rating scale

if dofmri
    if run_i <= run_num % you can customize the run start message using run_num and run_i
        Run_start_text = double('If participant ready, start scanning (s).');
    end
else
    if run_i <= run_num
        Run_start_text = double('If participant ready, press (r) button.');
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
% diplay_expmessage("");
% type each MESSAGE

global theWindow white bgcolor window_rect; % rating scale

EXP_start_text = double(msg);

% display
Screen(theWindow,'FillRect',bgcolor, window_rect);
DrawFormattedText(theWindow, EXP_start_text, 'center', 'center', white, [], [], [], 1.5);
Screen('Flip', theWindow);

end

function fixPoint(t_time, seconds, color, stimText)
global theWindow;
% stimText = '+';
% Screen(theWindow,'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double(stimText), 'center', 'center', color, [], [], [], 1.2);
Screen('Flip', theWindow);
waitsec_fromstarttime(t_time, seconds);
end


function [starttime, endtime] = run_movie(moviefile,varargin)

% moviefile: fullpath of movie file
global theWindow 
%moviefile = fullfile(pwd,'examples1.mov');
playmode =1;

%
starttime = GetSecs;
%
[moviePtr, dura] = Screen('OpenMovie', theWindow, moviefile);
Screen('SetMovieTimeIndex', moviePtr,0);
Screen('PlayMovie', moviePtr, playmode); %Screen('PlayMovie?')% 0 == Stop playback, 1 == Normal speed forward, -1 == Normal speed backward,
t = GetSecs; done = 0;
while t-GetSecs > dura %(~done) %~KbCheck
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', theWindow, moviePtr);
    Screen('DrawTexture', theWindow, tex);
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        %done = 1;
        break;
    end
    
    
    % Update display:
    Screen('Flip', theWindow)
    Screen('Close', tex);
end
Screen('PlayMovie', moviePtr,0);
Screen('CloseMovie',moviePtr);
endtime = GetSecs;
end

function [keyCode, dura_t, starttime, endtime] = showMath(mathTxt, secs, varargin)

global theWindow Participant white

%mathTxt = '38+67*2+12/3';%Temporally;
t = GetSecs; starttime = t;
while GetSecs - t < secs
    % Draw quiz or import quiz
    DrawFormattedText(theWindow, double(mathTxt), 'center', 'center', white, [], [], [], 1.2); % 4 seconds
    
    % Draw scale    
    Screen('Flip', theWindow)
    
    
    % options
    
    if GetSecs - t < secs
        [keyIsDown, t1, keyCode, ~] = KbCheck(Participant);
        
        if keyIsDown
            dura_t = t1 - t;
            DrawFormattedText(theWindow, double(mathTxt), 'center', 'center', white, [], [], [], 1.2); % 4 seconds
            Screen('Flip', theWindow)
            break;
            % get keycodes keyCode
        end        
    end
    
end

while GetSecs - t < secs
    DrawFormattedText(theWindow, ' ', 'center', 'center', white, [], [], [], 1.2); % null screen 
    Screen('Flip', theWindow)
end
endtime = GetSecs;
end