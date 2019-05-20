
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
%% SETUP: SCREEN
Screen('Clear');
Screen('CloseAll');
window_num = 0; %default
window_rect = [1 1 1280 720]; % in the test mode, use a little smaller screen [but, wide resoultions]    
fontsize = 20;
% color
bgcolor = 80; 
white = 255;
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
    
    % END
    Screen('Clear');
    Screen('CloseAll');
catch
    ShowCursor
    sca
end