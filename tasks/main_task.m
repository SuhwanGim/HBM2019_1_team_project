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
            case {'button_box'}            
           
        end
    end
end

%% GLOBAL vaiable
global theWindow W H window_num; % window property
global white red red_Alpha orange bgcolor yellow; % color
global window_rect lb rb tb bb scale_H% rating scale
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
% "HID KEY 12345"
device(2).product = '932';
device(2).vendorID= [1240 6171];
    
Participant  = IDkeyboards(device(2));


% ===== Scanner trigger 
device(3).product = 'KeyWarrior8 Flex';
device(3).vendorID= 1984;
scanner = IDkeyboards(device(3));
% % Getkeyborad
% % PsychHID('kbwait'm,
%% SETUP: Screen
Screen('Clear');
Screen('CloseAll');
window_num = 0;
if testmode
    window_rect = [0 0 1600 900]; % in the test mode, use a little smaller screen [but, wide resoultions]    
    Screen('Preference', 'SkipSyncTests', 1);
    fontsize = 32;
else
    screens = Screen('Screens');
    window_num = screens(end); % the last window
    Screen('Preference', 'SkipSyncTests', 1);
    window_info = Screen('Resolution', window_num);
    window_rect = [0 0 1920 1080];
    %window_rect = [0 0 window_info.width window_info.height]; % full screen
    fontsize = 32;
    HideCursor();
end
W = window_rect(3); %width of screen
H = window_rect(4); %height of screen


tb = H/5+100;           % in 800, it's 310
bb = H/2+100;           % in 800, it's 450, bb-tb = 340
scale_H = (bb-tb).*0.25;

% For overall rating scale
lb = 5*W/18; %
rb = 13*W/18; %s

bgcolor = 80;
white = 255;
red = [255 0 0];
red_Alpha = [255 164 0 130]; % RGB + A(Level of tranceprency: for social Cue)
orange = [255 164 0];
yellow = [255 220 0];


%% SETUP: Parameters
font = 'NanumBarunGothic';
stimText = '+';
%% START: Screen
theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8'); % text encoding
Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % For using transparency e.g., alpha value of [R G B alpha]
Screen('TextSize', theWindow, fontsize);
Screen('TextFont', theWindow, font); % setting font
try        
    %% SETUP: INSTRUCTION BEFORE START
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('space'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_experiment;
        end
        display_expmessage('실험자는 모든 것이 잘 준비되었는지 체크해주세요 (Trigger, USB, etc). \n 모두 준비되었으면 SPACE BAR를 눌러주세요.'); % until space; see subfunctions
    end
    
    
    while (1)
        
        % if this is for fMRI experiment, it will start with "s",
        % but if behavioral, it will start with "r" key.
        if dofmri            
            [~,~,keyCode] = KbCheck(scanner);
            if keyCode(KbName('s'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
        else            
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('r'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
        end
        display_runmessage(1, 1, dofmri); % until 5 or r; see subfunctions
    end
    
    % do fMRI
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
        [starttime, endtime] = run_movie(movie_files);
        dat.dat{trial_i}.Movie_dura = endtime - starttime;
        dat.dat{trial_i}.Movie_EndTime=GetSecs; 
        
        % --------------------------------------------------------- %
        %         3. ISI1
        % --------------------------------------------------------- %
        fixPoint(trial_t, ts.ITI(trial_i,2) + ts.ITI(trial_i,1) + dat.dat{trial_i}.Movie_dura , white, '+') % ITI
        dat.dat{trial_i}.ISI1_EndTime=GetSecs; 
        
        % --------------------------------------------------------- %
        %         4. MATH PROBLEM 
        % --------------------------------------------------------- %
        secs = 30;
        [dat.dat{trial_i}.math_response_keyCode, dat.dat{trial_i}.Movie_dura, dat.dat{trial_i}.Math_StartTime, dat.dat{trial_i}.Math_EndTime] ...
            = showMath(ts.math_img{trial_i}, ts.math_alt(trial_i,:), secs); % showMath(mathpath, secs, varargin)
        %dat.dat{trial_i}.Math_EndTime=GetSecs;
        
        % --------------------------------------------------------- %
        %         5. ISI2
        % --------------------------------------------------------- %
        fixPoint(trial_t, ts.ITI(trial_i,3) + ts.ITI(trial_i,2) + ts.ITI(trial_i,1) + dat.dat{trial_i}.Movie_dura + dat.dat{trial_i}.Movie_dura , white, '+') % ITI
        dat.dat{trial_i}.ISI2_EndTime=GetSecs; 
        
        % --------------------------------------------------------- %
        %         6. Resting-state
        % --------------------------------------------------------- %
        %fixPoint(trial_t, ts.ITI(trial_i,3), white, '+') % ITI
        resting_time();
        dat.dat{trial_i}.resting_EndTime=GetSecs;
        
        % --------------------------------------------------------- %
        %         7. ISI3
        % --------------------------------------------------------- %
        fixPoint(trial_t, ts.ITI(trial_i,4)+ts.ITI(trial_i,3) + ts.ITI(trial_i,2) + ts.ITI(trial_i,1) + dat.dat{trial_i}.Movie_dura + dat.dat{trial_i}.Movie_dura +10, white, '+') % ITI
        dat.dat{trial_i}.ISI3_EndTime=GetSecs; 
        
        % --------------------------------------------------------- %
        %         8. Short Quiz
        % --------------------------------------------------------- %
        [starttime, reseponse , dura_t, endtime] = movie_quiz(ts.quiz_cond{trial_i});
        dat.dat{trial_i}.ShortQuiz_EndTime=GetSecs; 
        % --------------------------------------------------------- %
        %         9. ISI4
        % --------------------------------------------------------- %
        fixPoint(trial_t, ts.ITI(trial_i,5), white, '+') % ITI
        dat.dat{trial_i}.ISI4_EndTime=GetSecs; 

        % --------------------------------------------------------- %
        %        10. REPORT level of stress  (one to ten)
        % --------------------------------------------------------- %
        
        dat.dat{trial_i}.ReportStress_EndTime=GetSecs;         
        
        % -----------------%
        %  End of trial (save data)
        % -----------------%
        dat.dat{trial_i}.TrialEndTimestamp=GetSecs; 
        save(dat.datafile, '-append', 'dat');
    end
    
    %% FINALZING EXPERIMENT    
    dat.RunEndTime = GetSecs;
    DrawFormattedText(theWindow, double(stimText), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    
    waitsec_fromstarttime(dat.RunEndTime, 10);              
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
    IOport('CloseALL');
    
catch err
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
% diplay_expmessage("");
% type each MESSAGE

global theWindow white bgcolor window_rect; % rating scale

EXP_start_text = double(msg);

% display
Screen(theWindow,'FillRect',bgcolor, window_rect);
DrawFormattedText(theWindow, EXP_start_text, 'center', 'center', white, [], [], [], 1.5);
Screen('Flip', theWindow);

end

%% ------------------------------------------ %
%           TASK                              %
%  ------------------------------------------ %

function fixPoint(t_time, seconds, color, stimText)
global theWindow;
% stimText = '+';
% Screen(theWindow,'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double(stimText), 'center', 'center', color, [], [], [], 1.2);
Screen('Flip', theWindow);
waitsec_fromstarttime(t_time, seconds);
end


function [starttime, endtime] = run_movie(moviefile)

% moviefile: fullpath of movie file
global theWindow 
%moviefile = fullfile(pwd,'examples1.mov');
playmode = 1;

%
starttime = GetSecs;
%
[moviePtr, dura] = Screen('OpenMovie', theWindow, moviefile);
Screen('SetMovieTimeIndex', moviePtr,0);
Screen('PlayMovie', moviePtr, playmode); %Screen('PlayMovie?')% 0 == Stop playback, 1 == Normal speed forward, -1 == Normal speed backward,
t = GetSecs; 
while GetSecs-t < dura %(~done) %~KbCheck
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', theWindow, moviePtr);
    Screen('DrawTexture', theWindow, tex);
    Screen('Flip', theWindow)
    Screen('Close', tex);
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        %done = 1;
        break;
    end
    
    
    % Update display:
    
end
Screen('PlayMovie', moviePtr,0);
Screen('CloseMovie',moviePtr);
endtime = GetSecs;
end

function [response, dura_t, starttime, endtime] = showMath(mathpath, math_alt, secs)


global theWindow Participant white
global lb rb tb bb scale_H
t = GetSecs; starttime = t;

% read read ima
ima=imread(mathpath);
% read alt
altSeq = math_alt;
total_str = [];
for i=1:4
    total_str = [total_str ['(' num2str(i) '): ' altSeq{i} '    ']];
end
 


while GetSecs - t < secs
    
    % options
    [~, t1, keyCode, ~] = KbCheck(Participant);
    if GetSecs - t > 10 % of 30secs
        % Draw quiz         
        Screen('PutImage', theWindow, ima); % put image on screen
        DrawFormattedText(theWindow, double(total_str), 'center', bb+200, white, [], [], [], 1.2); % 4 seconds
        Screen('Flip', theWindow)        
                 
        
        if (keyCode(KbName('1!')) || keyCode(KbName('2@')) || keyCode(KbName('3#')) || keyCode(KbName('4$'))) == 1
            dura_t = t1 - t;
            %DrawFormattedText(theWindow, double(mathTxt), 'center', 'center', white, [], [], [], 1.2); % 4 seconds
            response = KbName(keyCode);
            Screen('Flip', theWindow);            
            break;
            % get keycodes keyCode
        else 
            response = 0;
            dura_t = 0;
        end
    else
        % Draw img
        Screen('PutImage', theWindow, ima); % put image on screen
        % Draw scale
        Screen('Flip', theWindow)
        
    end
    
end

while GetSecs - t < secs
    DrawFormattedText(theWindow, ' ', 'center', 'center', white, [], [], [], 1.2); % null screen 
    Screen('Flip', theWindow)
end

endtime = GetSecs;
end


function [starttime, endtime] = resting_time()

global theWindow 
starttime = GetSecs;

DrawFormattedText(theWindow, double('퀴즈 전 쉬는 시간: 10초'), 'center', 'center', white, [], [], [], 1.2); % 4 seconds
%Screen('PutImage', theWindow, ima); % put image on screen
Screen('Flip', theWindow)

while GetSecs - starttime < 10
    % 
end

endtime = GetSecs;
end

function [starttime, response , dura_t, endtime] = movie_quiz(img)

global theWindow Participant white
global lb rb tb bb scale_H
t = GetSecs; starttime = t;

% read read ima
ima=imread(img);
secs = 5;
while GetSecs - t < secs
    
    % options
    [~, t1, keyCode, ~] = KbCheck(Participant);
    
    % Draw quiz
    Screen('PutImage', theWindow, ima); % put image on screen    
    Screen('Flip', theWindow)
    
    
    if (keyCode(KbName('1!')) || keyCode(KbName('2@')) || keyCode(KbName('3#')) || keyCode(KbName('4$'))) == 1
        dura_t = t1 - t;
        %DrawFormattedText(theWindow, double(mathTxt), 'center', 'center', white, [], [], [], 1.2); % 4 seconds
        response = KbName(keyCode);
        Screen('Flip', theWindow);
        break;
        % get keycodes keyCode
    else
        response = 0;
        dura_t = 0;
    end
    
    
    
end



while GetSecs - t < secs
    DrawFormattedText(theWindow, ' ', 'center', 'center', white, [], [], [], 1.2); % null screen
    Screen('Flip', theWindow)
end

endtime = GetSecs;

end


function [starttime, reseponse , dura_t, endtime] = stressResponse()

end
