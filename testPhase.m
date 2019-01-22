function [TP] = testPhase(TP, startT, stopT, win, pa_handle, texture, activeKeys)
    infoText= 'TESTPHASE \n \n Entscheide bitte jeweils per Knopfdruck (1-5),\n ob der Satz grammatikalisch richtig oder falsch ist. \n\n Druecke einen Knopf um fortzufahren';
    DrawFormattedText(win, infoText, 'center', 'center', [0 0 0]); % Indicate beginning of first TP
    Screen(win, 'flip');
    KbWait; % waiting for keyboard 
    KbReleaseWait;
    DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
    Screen(win, 'flip');
    WaitSecs(1);

    % Reads the n items from the previously defined TP structure array 
    for t=startT:stopT
        %Defining trigger names for log file
        trigger_1_1=TP(t).trig_1_1;
        trigger_1_2=TP(t).trig_1_2;
        trigger_2_1=TP(t).trig_2_1;
        trigger_2_2=TP(t).trig_2_2;
        trigger_3_1=TP(t).trig_3_1;
        trigger_3_2=TP(t).trig_3_2;

        %A1
        PsychPortAudio('FillBuffer', pa_handle, evalin('base',strcat((TP(t).syll_1_1),'_'))); % loads data into buffer, first syllable
        TP(t).s11_start=toc; %saving timing of sound play to log file
        ppdev_mex('Write', 1, trigger_1_1);
        WaitSecs(0.005);
        ppdev_mex('Write', 1, 0);
        PsychPortAudio('Start', pa_handle, 1); %starts sound immediatley
        PsychPortAudio('Stop', pa_handle, 1); 
        %A2
        PsychPortAudio('FillBuffer', pa_handle, evalin('base',strcat((TP(t).syll_1_2),'_'))); %second syllable
        TP(t).s12_start=toc; 
        ppdev_mex('Write', 1, trigger_1_2);
        WaitSecs(0.005);
        ppdev_mex('Write', 1, 0);
        PsychPortAudio('Start', pa_handle, 1);
        PsychPortAudio('Stop', pa_handle, 1);
        %X1
        PsychPortAudio('FillBuffer', pa_handle, evalin('base',strcat((TP(t).syll_2_1),'_'))); %third syllable
        TP(t).s21_start=toc; 
        ppdev_mex('Write', 1, trigger_2_1);
        WaitSecs(0.005);
        ppdev_mex('Write', 1, 0);
        PsychPortAudio('Start', pa_handle, 1);
        PsychPortAudio('Stop', pa_handle, 1);
        %X2
        PsychPortAudio('FillBuffer', pa_handle, evalin('base',strcat((TP(t).syll_2_2),'_'))); %fourth syllable
        TP(t).s22_start=toc; 
        ppdev_mex('Write', 1, trigger_2_2);
        WaitSecs(0.005);
        ppdev_mex('Write', 1, 0);
        PsychPortAudio('Start', pa_handle, 1);
        PsychPortAudio('Stop', pa_handle, 1);
        %B1
        PsychPortAudio('FillBuffer', pa_handle, evalin('base',strcat((TP(t).syll_3_1),'_'))); %fifth syllable
        TP(t).s31_start=toc; 
        ppdev_mex('Write', 1, trigger_3_1);
        WaitSecs(0.005);
        ppdev_mex('Write', 1, 0);
        PsychPortAudio('Start', pa_handle, 1);
        PsychPortAudio('Stop', pa_handle, 1); 
        %B2
        PsychPortAudio('FillBuffer', pa_handle, evalin('base',strcat((TP(t).syll_3_2),'_'))); %sixth syllable
        TP(t).s32_start=toc; 
        ppdev_mex('Write', 1, trigger_3_2);
        WaitSecs(0.005);
        ppdev_mex('Write', 1, 0);
        PsychPortAudio('Start', pa_handle, 1);
        PsychPortAudio('Stop', pa_handle, 1);

        Screen('DrawTexture', win, texture); % loads testphase scalar gfx on the screen to indicate button press
        startRW = Screen(win,'flip'); %collect time of start response window
        trigger_4 = trigger_3_2+1; 
        ppdev_mex('Write', 1, trigger_4); %sends a seventh trigger for when button press cue appears
        WaitSecs(0.005);
        ppdev_mex('Write', 1, 0);
        
        RestrictKeysForKbCheck(activeKeys);%make sure only certain buttons allowes
        [secs, keyCode]=KbWait; %collecting time
        endRW=secs; %collect time of end response window (response)
        TP(t).RT=endRW-startRW; % Store the reaction time
        KBresponse=KbName(keyCode); %collect keypress response
        KbReleaseWait; % wait for key release
        TP(t).response=KBresponse; %collect the pressed key and store it in log file
        clear startRW;
        clear endRW;
        RestrictKeysForKbCheck([]); %enable all keys again
        Screen(win,'flip'); %show response cue
        WaitSecs(0.5); %pause of 1000ms between items
        DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
        Screen(win, 'flip');
        WaitSecs(0.5);   
    end