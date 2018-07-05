function [LP] = learningPhase(LP, numLearnTrials, win, pa_handle, pause_dur)
    DrawFormattedText(win, 'ZUHOERPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of first LP
    Screen(win, 'flip'); %Show text on screen
    KbWait; % waiting for keyboard 
    KbReleaseWait;
    DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
    Screen(win, 'flip');
    WaitSecs(1); %waiting one second before LP starts

    for k=1:numLearnTrials %specify how many rows to be read from the structure, i.e. how big is the first block?
        %Defining variables for the triggers in the structure
        trigger_1_1=LP(k).trig_1_1;
        trigger_1_2=LP(k).trig_1_2;
        trigger_2_1=LP(k).trig_2_1;
        trigger_2_2=LP(k).trig_2_2;
        trigger_3_1=LP(k).trig_3_1;
        trigger_3_2=LP(k).trig_3_2;
        %A1
        PsychPortAudio('FillBuffer', pa_handle, evalin('base',strcat((LP(k).syll_1_1),'_'))); % loads data into buffer, first syllable from the LP structure above 
        LP(k).s11_start=toc; %saves timing of sound play to a new column (s1_start) in the log file
        ppdev_mex('Write', 1, trigger_1_1); %writes the trigger as specified in LP(k).trig1 (e.g. 5)
        WaitSecs(0.005); %very short duration of the trigger (as we want one exact point in time)
        ppdev_mex('Write', 1, 0); %stops sending trigger, set back to 0
        PsychPortAudio('Start', pa_handle, 1); %starts sound immediatley
        PsychPortAudio('Stop', pa_handle, 1); %plays sound till the end of the sound file, make sure you do not have any silences at the end!!
        if(pause_dur > 0)
         WaitSecs(pause_dur); 
        end 
        %A2
        PsychPortAudio('FillBuffer', pa_handle, evalin('base',strcat((LP(k).syll_1_2),'_'))); %second syllable
        LP(k).s12_start=toc;
        ppdev_mex('Write', 1, trigger_1_2);
        WaitSecs(0.005);
        ppdev_mex('Write', 1, 0);
        PsychPortAudio('Start', pa_handle, 1);
        PsychPortAudio('Stop', pa_handle, 1);
        if(pause_dur > 0)
         WaitSecs(pause_dur); 
        end     
        %X1
        PsychPortAudio('FillBuffer', pa_handle, evalin('base',strcat((LP(k).syll_2_1),'_'))); %third syllable
        LP(k).s21_start=toc;
        ppdev_mex('Write', 1, trigger_2_1);
        WaitSecs(0.005);
        ppdev_mex('Write', 1, 0);
        PsychPortAudio('Start', pa_handle, 1);
        PsychPortAudio('Stop', pa_handle, 1);
        if(pause_dur > 0)
         WaitSecs(pause_dur); 
        end
        %X2
        PsychPortAudio('FillBuffer', pa_handle, evalin('base',strcat((LP(k).syll_2_2),'_'))); %fourth syllable
        LP(k).s22_start=toc;
        ppdev_mex('Write', 1, trigger_2_2);
        WaitSecs(0.005);
        ppdev_mex('Write', 1, 0);
        PsychPortAudio('Start', pa_handle, 1);
        PsychPortAudio('Stop', pa_handle, 1);
        if(pause_dur > 0)
         WaitSecs(pause_dur); 
        end
        %B1
        PsychPortAudio('FillBuffer', pa_handle, evalin('base',strcat((LP(k).syll_3_1),'_'))); %fifth syllable
        LP(k).s31_start=toc;
        ppdev_mex('Write', 1, trigger_3_1);
        WaitSecs(0.005);
        ppdev_mex('Write', 1, 0);
        PsychPortAudio('Start', pa_handle, 1);
        PsychPortAudio('Stop', pa_handle, 1);
        if(pause_dur > 0)
         WaitSecs(pause_dur); 
        end
        %B2
        PsychPortAudio('FillBuffer', pa_handle, evalin('base',strcat((LP(k).syll_3_2),'_'))); %sixth syllable
        LP(k).s32_start=toc;
        ppdev_mex('Write', 1, trigger_3_2);
        WaitSecs(0.005);
        ppdev_mex('Write', 1, 0);
        PsychPortAudio('Start', pa_handle, 1);
        PsychPortAudio('Stop', pa_handle, 1);
        if(pause_dur > 0)
         WaitSecs(pause_dur); 
        end
    end