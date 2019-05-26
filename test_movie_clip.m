
% % Movie and multimedia playback functions:
% [ moviePtr [duration] [fps] [width] [height] [count] [aspectRatio]]=Screen('OpenMovie', windowPtr, moviefile [, async=0] [, preloadSecs=1] [, specialFlags1=0][, pixelFormat=4][, maxNumberThreads=-1][, movieOptions]);
% Screen('CloseMovie', moviePtr);
% [ texturePtr [timeindex]]=Screen('GetMovieImage', windowPtr, moviePtr, [waitForImage], [fortimeindex], [specialFlags = 0] [, specialFlags2 = 0]);
% [droppedframes] = Screen('PlayMovie', moviePtr, rate, [loop], [soundvolume]);
% timeindex = Screen('GetMovieTimeIndex', moviePtr);
% [oldtimeindex] = Screen('SetMovieTimeIndex', moviePtr, timeindex [, indexIsFrames=0]);
% moviePtr = Screen('CreateMovie', windowPtr, movieFile [, width][, height][, frameRate=30][, movieOptions][, numChannels=4][, bitdepth=8]);
% Screen('FinalizeMovie', moviePtr);
% Screen('AddFrameToMovie', windowPtr [,rect] [,bufferName] [,moviePtr=0] [,frameduration=1]);
% Screen('AddAudioBufferToMovie', moviePtr, audioBuffer);

%% Examples
%moviefile = fullfile(pwd,'examples1.mov');
moviefile = '/Users/WIWIFH/Dropbox/github/experiment/movie_clips/N2.mp4';
global theWindow W H; % window property
global white red red_Alpha orange bgcolor yellow; % color
global window_rect prompt_ex lb rb tb bb scale_H promptW promptH; % rating scale
global lb1 rb1 lb2 rb2;% For larger semi-circular
global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd; % anchors
%% SETUP: SCREEN
Screen('Clear');
Screen('CloseAll');
window_num = 0; %default
window_rect = [2 2 1440 800]; % in the test mode, use a little smaller screen [but, wide resoultions]    
fontsize = 20;
% color
bgcolor = 80; 
white = 255;

W = window_rect(3); %width of screen
H = window_rect(4); %height of screen

font = 'NanumBarunGothic';

bgcolor = 80;
white = 255;
red = [255 0 0];
red_Alpha = [255 164 0 130]; % RGB + A(Level of tranceprency: for social Cue)
orange = [255 164 0];
yellow = [255 220 0];

% rating scale left and right bounds 1/5 and 4/5
lb = 1.5*W/5; % in 1280, it's 384
rb = 3.5*W/5; % in 1280, it's 896 rb-lb = 512

% For cont rating scale 
lb1 = 1*W/18; %
rb1 = 17*W/18; %

% For overall rating scale
lb2 = 5*W/18; %
rb2 = 13*W/18; %s

% rating scale upper and bottom bounds
tb = H/5+100;           % in 800, it's 310
bb = H/2+100;           % in 800, it's 450, bb-tb = 340
scale_H = (bb-tb).*0.25;

anchor_xl = lb-80; % 284
anchor_xr = rb+20; % 916
anchor_yu = tb-40; % 170
anchor_yd = bb+20; % 710

% y location for anchors of rating scales -
anchor_y = H/2+10+scale_H;
%% OPEN: SCREEN
theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8'); % text encoding
Screen('Preference', 'SkipSyncTests', 1)
%Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % For using transparency e.g., alpha value of [R G B alpha]
Screen('TextSize', theWindow, fontsize);
try 
    % TEXT
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    DrawFormattedText(theWindow, double('시작합니다...'), 'center', 'center', white, [], [], [], 1.2); % 4 seconds    
    Screen('Flip',theWindow);
    WaitSecs(5);
    % MOVIE

    
    
    [moviePtr,dur]=Screen('OpenMovie', theWindow, moviefile);
    Screen('PlayMovie', moviePtr, 1); %Screen('PlayMovie?')% 0 == Stop playback, 1 == Normal speed forward, -1 == Normal speed backward,
    dur = 1;
    t = GetSecs;
    while (GetSecs - t) < dur
        % Wait for next movie frame, retrieve texture handle to it
        tex = Screen('GetMovieImage', theWindow, moviePtr);
        Screen('DrawTexture', theWindow, tex);
        % Valid texture returned? A negative value means end of movie reached:
        if tex<=0
            % We're done, break out of loop:
            break;
        end
                
        
        % Update display:
        Screen('Flip', theWindow)
        Screen('Close', tex);         
    end    
    Screen('CloseMovie',moviePtr);
    Screen('Flip', theWindow)
    %DrawFormattedText(theWindow, [double('Total movie duration: ') double(num2str(dur)) '\n' 'Program duration: ' double(num2str(GetSecs-t)) ' secs.'], 'center', 'center', white, [], [], [], 1.2); % 4 seconds    
    done = 1;
    while done
        [x,y,buttons] = GetMouse(theWindow);
        draw_scale_HBM();       
        Screen('DrawDots', theWindow, [x y], 15, orange, [0 0], 1);        
%         if x
%         end
%         if y
%         end
%         
        if buttons
            done = 0;
        end
        

    end
    
    Screen('Flip', theWindow)
    WaitSecs(5);
    
    % END
    Screen('Clear');
    Screen('CloseAll');
catch
    ShowCursor
    sca
end