%% Experiment script COSY
%Commented version; structured into 8 alternating learning and testing
%phases
%By Ivonne Weyers, 2017

clear all %clears all variables
close all %closes all windows
InitializePsychSound(0); %initializing sound driver
audio_port = 7; %specifying audio port
% genpath 'home/experiment/Desktop/Experiments_folder/COSY/ppdev-mex-master'
mex ppdev_mex.c %needed for triggers


%% Loading sound files
%When you have all your soundfiles ready, copy them into the same folder as
%your script and read them into Matlab by calling each of the filenames as
%indicated below. Maybe the transpose() part is not necessary, simply try
%and load one and see if it works.
bi=transpose(psychwavread('bi.wav'));
bu=transpose(psychwavread('bu.wav'));
da=transpose(psychwavread('da.wav'));
dae=transpose(psychwavread('dae.wav'));
doe=transpose(psychwavread('doe.wav'));
due=transpose(psychwavread('due.wav'));
wa=transpose(psychwavread('wa.wav'));
wae=transpose(psychwavread('wae.wav'));
woe=transpose(psychwavread('woe.wav'));
wue=transpose(psychwavread('wue.wav'));
ge=transpose(psychwavread('ge.wav'));
go=transpose(psychwavread('go.wav'));
ko=transpose(psychwavread('ko.wav'));
ku=transpose(psychwavread('ku.wav'));
la=transpose(psychwavread('la.wav'));
lae=transpose(psychwavread('lae.wav'));
loe=transpose(psychwavread('loe.wav'));
lue=transpose(psychwavread('lue.wav'));
ma=transpose(psychwavread('ma.wav'));
mae=transpose(psychwavread('mae.wav'));
moe=transpose(psychwavread('moe.wav'));
mue=transpose(psychwavread('mue.wav'));
na=transpose(psychwavread('na.wav'));
nae=transpose(psychwavread('nae.wav'));
noe=transpose(psychwavread('noe.wav'));
nue=transpose(psychwavread('nue.wav'));
pe=transpose(psychwavread('pe.wav'));
pi=transpose(psychwavread('pi.wav'));
ra=transpose(psychwavread('ra.wav'));
rae=transpose(psychwavread('rae.wav'));
roe=transpose(psychwavread('roe.wav'));
rue=transpose(psychwavread('rue.wav'));
sa=transpose(psychwavread('sa.wav'));
sae=transpose(psychwavread('sae.wav'));
soe=transpose(psychwavread('soe.wav'));
sue=transpose(psychwavread('sue.wav'));
ta=transpose(psychwavread('ta.wav'));
tae=transpose(psychwavread('tae.wav'));
toe=transpose(psychwavread('toe.wav'));
tue=transpose(psychwavread('tue.wav'));

%Once you have loaded all of your soundfiles into Matlab, check if they all
%appear as variables in the Workspace. In the Workspace window, select all
%the soundfile variables, clickt right and select "save as" and save them
%in one big mat file, e.g. sounds.mat.

load sounds.mat; %Load the sounds mat file and look at it by double clicking it in the Workspace, check if all sounds are there

%% Dialog box to gather participant data 
prompt={'Participant no.: ', 'List: '}; %Enter participant ID (always two digits!!) and list A, B, C or D
dlg_title='Participant Info';
num_lines=1;
partinfo=inputdlg(prompt,dlg_title);

%% Creating directory
mkdir(strcat('Sub_',char(partinfo(1)),char(partinfo(2)))); %creates a directory for each participant, e.g. 'Sub_01_A'
log_folder = strcat('/home/experiment/Desktop/Experiments_folder/COSY/Sub_',char(partinfo(1)),char(partinfo(2)), '/'); %specifies where the log file (with the button presses) is going to be saved, you have to change it to the directory you want to use.
list=strcat(char(partinfo(2))); %defines the variable list as the input of the second line of the prompt above

%% Defining different order of buttons for odd & even partno.
if mod(char(partinfo(1)), 2) == 1 %if part.no. is odd
    TP_pic=imread('tick1.jpg'); %load (left correct) button press cue
else %if part.no. is even
    TP_pic=imread('tick2.jpg'); %load (right correct) button press cue
end 

inst2=fileread('instructions2.txt'); %loads text from text file and saves it as variable inst2

%% Import the list with LEARNING PHASE items from the Excel file
%Saves it as a Matlab structure which allows you to access individual
%items in an array
[~,~,raw]=xlsread(strcat('LP_', list,'.xlsx'), 1, '', ''); %here you just change the name of the Excel file you want to import, here it's LP_ whatever you entered as list above and .xlsx
numTrials=768; %setting no. of trials in LP to 768
%In a for loop, you create denominations for each column from the original
%Excel file and read it into a structure line by line
%The structure is called LP.
for k=1:numTrials
    LP(k).stimno=cell2mat(raw(k,1)); %names the first structure column 'stimno', cell2mat used for numbers, 1 reads the first column
    LP(k).syl1=char(raw(k,2)); %char specifies text input, 2 reads the second column
    LP(k).syl2=char(raw(k,3)); %3 reads third column
    LP(k).syl3=char(raw(k,4));
    LP(k).trig1=cell2mat(raw(k,5));
    LP(k).trig2=cell2mat(raw(k,6));
    LP(k).trig3=cell2mat(raw(k,7));
end     

%Same for TESTING PHASE items from the Excel file

[~,~,raw]=xlsread(strcat('TP_', list, '.xlsx'), 1, '', ''); 
numTrials=192; %setting no. of trial in LP to 168
%Create denominations for each column in the original Excel file
for t=1:numTrials
    TP(t).stimno=cell2mat(raw(t,1));
    TP(t).syl1=char(raw(t,2));
    TP(t).syl2=char(raw(t,3));
    TP(t).syl3=char(raw(t,4));
    TP(t).trig1=cell2mat(raw(t,5));
    TP(t).trig2=cell2mat(raw(t,6));
    TP(t).trig3=cell2mat(raw(t,7));
end     

clear raw %you don't need the raw data anymore since you just created the arrays LP and TP

%% Open the experiment screen
tic %starts measuring time (important if you want reaction times for the button presses)
% define screen called "win" main screen window (0), color, on screen coordinates of window (full screen)
win= Screen('OpenWindow',0,[158 158 158], [0 0 1960 1020]); 
Priority(MaxPriority(win)); %window always in foreground
HideCursor(); %hides cursor during experiment
Screen('Preference', 'TextRenderer', 1); %uses high definition text renderer
Screen('TextSize', win, 27); %specifies font size
Screen('TextFont', win, 'Arial'); %specifies font
Screen('TextStyle', win, 0); %Specifies text color (0=black)

texture1=Screen('MakeTexture', win, TP_pic); %converts the previously loaded image (lines 80-82) into a texture which can later be displayed on the screen

%% open the parallel port  
%necessary to send triggers
ppdev_mex('Open', 1);
start=100;
ppdev_mex('Write', 1, start); %trigger 100 is sent at beginning of experiment
WaitSecs(0.001);
ppdev_mex('Write', 1, 0); %trigger always needs to be set back to 0, otherwise it continuously sends a number (and not only at one point in time)

%% Show instructions on the screen
DrawFormattedText(win, inst2 ,'center','center', 0); % uses the defined 'win' above and draws instructions on it
Screen(win,'flip'); % Flush the buffer, needed to display previously made changes to 'win'
KbWait; % waiting for keyboard press
KbReleaseWait; % KbWait could interfere with the key pressing of the response


clear inst2  %not needed anymore, just to make room

%% Begin Learning Phase 1

DrawFormattedText(win, 'ZUH??RPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of first LP
Screen(win, 'flip'); %Show text on screen
KbWait; % waiting for keyboard 
KbReleaseWait;
DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
Screen(win, 'flip');
WaitSecs(1); %waiting one second before LP starts

pahandle = PsychPortAudio('Open', audio_port, 1, [],[],1,[], [], []); %open audioport
for k=1:96 %specify how many rows to be read from the structure, i.e. how big is the first block?
    %Defining variables for the triggers in the structure
    trigger_1=LP(k).trig1;
    trigger_2=LP(k).trig2;
    trigger_3=LP(k).trig3;
    
    PsychPortAudio('FillBuffer', pahandle, eval(LP(k).syl1)); % loads data into buffer, first syllable from the LP structure above
    LP(k).s1_start=toc; %saves timing of sound play to a new column (s1_start) in the log file
    ppdev_mex('Write', 1, trigger_1); %writes the trigger as specified in LP(k).trig1 (e.g. 5)
    WaitSecs(0.005); %very short duration of the trigger (as we want one exact point in time)
    ppdev_mex('Write', 1, 0); %stops sending trigger, set back to 0
    PsychPortAudio('Start', pahandle, 1); %starts sound immediatley
    PsychPortAudio('Stop', pahandle, 1); %plays sound till the end of the sound file, make sure you do not have any silences at the end!!
%     WaitSecs(0.05) %pause of 50ms between sounds; you probably don't need
%     this if you want a continuous stream of sounds
    
    PsychPortAudio('FillBuffer', pahandle, eval(LP(k).syl2)); %second syllable
    LP(k).s2_start=toc;
    ppdev_mex('Write', 1, trigger_2);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);
    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1);
%     WaitSecs(0.05)
    
    PsychPortAudio('FillBuffer', pahandle, eval(LP(k).syl3)); %third syllable
    LP(k).s3_start=toc;
    ppdev_mex('Write', 1, trigger_3);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);
    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1);
%     WaitSecs(0.7) %pause of 700ms between items; you probably don't want
%     this either
end

%% Begin Testing Phase 1

DrawFormattedText(win, 'TESTPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of first TP
Screen(win, 'flip');
KbWait; % waiting for keyboard 
KbReleaseWait;
DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
Screen(win, 'flip');
WaitSecs(1);

% Reads the first 24 items from the previously defined TP structure array
for t=1:24
    %Defining trigger names for log file
    trigger_1=TP(t).trig1;
    trigger_2=TP(t).trig2;
    trigger_3=TP(t).trig3;

    PsychPortAudio('FillBuffer', pahandle, eval(TP(t).syl1)); % loads data into buffer, first syllable
    TP(t).s1_start=toc; %saving timing of sound play to log file
    ppdev_mex('Write', 1, trigger_1);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);
    PsychPortAudio('Start', pahandle, 1); %starts sound immediatley
    PsychPortAudio('Stop', pahandle, 1)
%     WaitSecs(0.05) %pause of 50ms between sounds
    
    PsychPortAudio('FillBuffer', pahandle, eval(TP(t).syl2)); %second syllable
    TP(t).s2_start=toc; 
    ppdev_mex('Write', 1, trigger_2);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);
    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1)
%     WaitSecs(0.05)
    
    PsychPortAudio('FillBuffer', pahandle, eval(TP(t).syl3)); %third syllable
    TP(t).s3_start=toc; 
    ppdev_mex('Write', 1, trigger_3);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);
    PsychPortAudio('Start', pahandle, 1);
%     WaitSecs(0.069) %here I have another trigger within a syllable,
%     ignore this part
%     ppdev_mex('Write', 1, 255);
%     WaitSecs(0.005);
%     ppdev_mex('Write', 1, 0);
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.9) %pause of 900ms between item and button press response
   
    Screen('DrawTexture', win, texture1); % loads correct, incorrect sign on the screen to indicate button press
    startRW = Screen(win,'flip'); %collect time of start response window
    trigger_4 = trigger_3+1; 
    ppdev_mex('Write', 1, trigger_4); %sends a fourth trigger for when button press cue appears
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);

    [secs, keyCode]=KbWait; %collecting time
    endRW=secs; %collect time of end response window (response)
    TP(t).RT=endRW-startRW; % Store the reaction time
    KBresponse=KbName(keyCode); %collect keypress response
    KbReleaseWait; % wait for key release
    TP(t).response=KBresponse; %collect the pressed key and store it in log file
    clear startRW
    clear endRW
    Screen(win,'flip'); %show response cue
    WaitSecs(0.5); %pause of 1000ms between items
    DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
    Screen(win, 'flip');
    WaitSecs(0.5);
    
end

%% Learning Phase 2

DrawFormattedText(win, 'ZUH??RPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of LP
Screen(win, 'flip');
KbWait; % waiting for keyboard 
KbReleaseWait;
DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
Screen(win, 'flip');
WaitSecs(1);

for k=97:192

    trigger_1=LP(k).trig1;
    trigger_2=LP(k).trig2;
    trigger_3=LP(k).trig3;
    
    PsychPortAudio('FillBuffer', pahandle, eval(LP(k).syl1)); % loads data into buffer, first syllable; eval executes MATLAB expression in text
    LP(k).s1_start=toc; %saving timing of sound play to log file
    ppdev_mex('Write', 1, trigger_1);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1); %starts sound immediatley
    PsychPortAudio('Stop', pahandle, 1);
%     WaitSecs(0.05) %pause of 50ms between sounds
    
    PsychPortAudio('FillBuffer', pahandle, eval(LP(k).syl2)); %second syllable
    LP(k).s2_start=toc;
    ppdev_mex('Write', 1, trigger_2);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1);
%     WaitSecs(0.05)
    
    PsychPortAudio('FillBuffer', pahandle, eval(LP(k).syl3)); %third syllable
    LP(k).s3_start=toc;
    ppdev_mex('Write', 1, trigger_3);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1);
%     WaitSecs(0.7) %pause of 700ms between items
end

%% Testing Phase 2

DrawFormattedText(win, 'TESTPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of first TP
Screen(win, 'flip');
KbWait; % waiting for keyboard 
KbReleaseWait;
DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
Screen(win, 'flip');
WaitSecs(1);

for t=25:48
    %Defining trigger names for log file
    trigger_1=TP(t).trig1;
    trigger_2=TP(t).trig2;
    trigger_3=TP(t).trig3;

    PsychPortAudio('FillBuffer', pahandle, eval(TP(t).syl1)); % loads data into buffer, first syllable
    TP(t).s1_start=toc; %saving timing of sound play to log file
    ppdev_mex('Write', 1, trigger_1);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1); %starts sound immediatley
    PsychPortAudio('Stop', pahandle, 1)
%     WaitSecs(0.05) %pause of 50ms between sounds
    
    PsychPortAudio('FillBuffer', pahandle, eval(TP(t).syl2)); %second syllable
    TP(t).s2_start=toc; 
    ppdev_mex('Write', 1, trigger_2);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1)
%     WaitSecs(0.05)
    
    PsychPortAudio('FillBuffer', pahandle, eval(TP(t).syl3)); %third syllable
    TP(t).s3_start=toc; 
    ppdev_mex('Write', 1, trigger_3);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.9) %pause of 900ms between item and response
   
    Screen('DrawTexture', win, texture1); % correct, incorrect sign
    startRW = Screen(win,'flip'); %collect time of start response window
    trigger_4 = trigger_3+1; 
    ppdev_mex('Write', 1, trigger_4);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);

    [secs, keyCode]=KbWait; %collecting time
    endRW=secs; %collect time of end response window (response)
    TP(t).RT=endRW-startRW; % Store the RT
    KBresponse=KbName(keyCode); %collect keypress response
    KbReleaseWait; % wait for key release
    TP(t).response=KBresponse; %collect the pressed key 
    clear startRW
    clear endRW
    Screen(win,'flip');
    WaitSecs(0.5); %pause of 1000ms between items
    DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
    Screen(win, 'flip');
    WaitSecs(0.5);
    
end

%% Learning Phase 3

DrawFormattedText(win, 'ZUH??RPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of LP
Screen(win, 'flip');
KbWait; % waiting for keyboard 
KbReleaseWait;
DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
Screen(win, 'flip');
WaitSecs(1);

for k=193:288
    %Defining trigger names for log file
    trigger_1=LP(k).trig1;
    trigger_2=LP(k).trig2;
    trigger_3=LP(k).trig3;
    
    PsychPortAudio('FillBuffer', pahandle, eval(LP(k).syl1)); % loads data into buffer, first syllable
    LP(k).s1_start=toc; %saving timing of sound play to log file
    ppdev_mex('Write', 1, trigger_1);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1); %starts sound immediatley
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.05) %pause of 50ms between sounds
    
    PsychPortAudio('FillBuffer', pahandle, eval(LP(k).syl2)); %second syllable
    LP(k).s2_start=toc;
    ppdev_mex('Write', 1, trigger_2);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.05)
    
    PsychPortAudio('FillBuffer', pahandle, eval(LP(k).syl3)); %third syllable
    LP(k).s3_start=toc;
    ppdev_mex('Write', 1, trigger_3);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.7) %pause of 700ms between items
end

%% Testing Phase 3

DrawFormattedText(win, 'TESTPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of first TP
Screen(win, 'flip');
KbWait; % waiting for keyboard 
KbReleaseWait;
DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
Screen(win, 'flip');
WaitSecs(1);

for t=49:72
    %Defining trigger names for log file
    trigger_1=TP(t).trig1;
    trigger_2=TP(t).trig2;
    trigger_3=TP(t).trig3;

    PsychPortAudio('FillBuffer', pahandle, eval(TP(t).syl1)); % loads data into buffer, first syllable
    TP(t).s1_start=toc; %saving timing of sound play to log file
    ppdev_mex('Write', 1, trigger_1);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1); %starts sound immediatley
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.05) %pause of 50ms between sounds
    
    PsychPortAudio('FillBuffer', pahandle, eval(TP(t).syl2)); %second syllable
    TP(t).s2_start=toc; 
    ppdev_mex('Write', 1, trigger_2);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.05)
    
    PsychPortAudio('FillBuffer', pahandle, eval(TP(t).syl3)); %third syllable
    TP(t).s3_start=toc; 
    ppdev_mex('Write', 1, trigger_3);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.9) %pause of 900ms between item and response
   
    Screen('DrawTexture', win, texture1); % correct, incorrect sign
    startRW = Screen(win,'flip'); %collect time of start response window
    trigger_4 = trigger_3+1; 
    ppdev_mex('Write', 1, trigger_4);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);

    [secs, keyCode]=KbWait; %collecting time
    endRW=secs; %collect time of end response window (response)
    TP(t).RT=endRW-startRW; % Store the RT
    KBresponse=KbName(keyCode); %collect keypress response
    KbReleaseWait; % wait for key release
    TP(t).response=KBresponse; %collect the pressed key 
    clear startRW
    clear endRW
    Screen(win,'flip');
    WaitSecs(0.5); %pause of 1000ms between items
    DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
    Screen(win, 'flip');
    WaitSecs(0.5);
    
end


%% Learning Phase 4

DrawFormattedText(win, 'ZUH??RPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of LP
Screen(win, 'flip');
KbWait; % waiting for keyboard 
KbReleaseWait;
DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
Screen(win, 'flip');
WaitSecs(1);

for k=289:384
    %Defining trigger names for log file
    trigger_1=LP(k).trig1;
    trigger_2=LP(k).trig2;
    trigger_3=LP(k).trig3;
    
    PsychPortAudio('FillBuffer', pahandle, eval(LP(k).syl1)); % loads data into buffer, first syllable
    LP(k).s1_start=toc; %saving timing of sound play to log file
    ppdev_mex('Write', 1, trigger_1);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1); %starts sound immediatley
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.05) %pause of 50ms between sounds
    
    PsychPortAudio('FillBuffer', pahandle, eval(LP(k).syl2)); %second syllable
    LP(k).s2_start=toc;
    ppdev_mex('Write', 1, trigger_2);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.05)
    
    PsychPortAudio('FillBuffer', pahandle, eval(LP(k).syl3)); %third syllable
    LP(k).s3_start=toc;
    ppdev_mex('Write', 1, trigger_3);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.7) %pause of 700ms between items
end

%% Testing Phase 4

DrawFormattedText(win, 'TESTPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of first TP
Screen(win, 'flip');
KbWait; % waiting for keyboard 
KbReleaseWait;
DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
Screen(win, 'flip');
WaitSecs(1);

for t=73:96
    %Defining trigger names for log file
    trigger_1=TP(t).trig1;
    trigger_2=TP(t).trig2;
    trigger_3=TP(t).trig3;

    PsychPortAudio('FillBuffer', pahandle, eval(TP(t).syl1)); % loads data into buffer, first syllable
    TP(t).s1_start=toc; %saving timing of sound play to log file
    ppdev_mex('Write', 1, trigger_1);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1); %starts sound immediatley
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.05) %pause of 50ms between sounds
    
    PsychPortAudio('FillBuffer', pahandle, eval(TP(t).syl2)); %second syllable
    TP(t).s2_start=toc; 
    ppdev_mex('Write', 1, trigger_2);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.05)
    
    PsychPortAudio('FillBuffer', pahandle, eval(TP(t).syl3)); %third syllable
    TP(t).s3_start=toc; 
    ppdev_mex('Write', 1, trigger_3);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.9) %pause of 900ms between item and response
   
    Screen('DrawTexture', win, texture1); % correct, incorrect sign
    startRW = Screen(win,'flip'); %collect time of start response window
    trigger_4 = trigger_3+1; 
    ppdev_mex('Write', 1, trigger_4);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);

    [secs, keyCode]=KbWait; %collecting time
    endRW=secs; %collect time of end response window (response)
    TP(t).RT=endRW-startRW; % Store the RT
    KBresponse=KbName(keyCode); %collect keypress response
    KbReleaseWait; % wait for key release
    TP(t).response=KBresponse; %collect the pressed key 
    clear startRW
    clear endRW
    Screen(win,'flip');
    WaitSecs(0.5); %pause of 1000ms between items
    DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
    Screen(win, 'flip');
    WaitSecs(0.5);
    
end

%% Learning Phase 5

DrawFormattedText(win, 'ZUH??RPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of LP
Screen(win, 'flip');
KbWait; % waiting for keyboard 
KbReleaseWait;
DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
Screen(win, 'flip');
WaitSecs(1);

for k=385:480
    %Defining trigger names for log file
    trigger_1=LP(k).trig1;
    trigger_2=LP(k).trig2;
    trigger_3=LP(k).trig3;
    
    PsychPortAudio('FillBuffer', pahandle, (LP(k).syl1)); % loads data into buffer, first syllable
    LP(k).s1_start=toc; %saving timing of sound play to log file
    ppdev_mex('Write', 1, trigger_1);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1); %starts sound immediatley
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.05) %pause of 50ms between sounds
    
    PsychPortAudio('FillBuffer', pahandle, (LP(k).syl2)); %second syllable
    LP(k).s2_start=toc;
    ppdev_mex('Write', 1, trigger_2);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.05)
    
    PsychPortAudio('FillBuffer', pahandle, (LP(k).syl3)); %third syllable
    LP(k).s3_start=toc;
    ppdev_mex('Write', 1, trigger_3);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.7) %pause of 700ms between items
end

%% Testing Phase 5

DrawFormattedText(win, 'TESTPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of first TP
Screen(win, 'flip');
KbWait; % waiting for keyboard 
KbReleaseWait;
DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
Screen(win, 'flip');
WaitSecs(1);

for t=97:120
    %Defining trigger names for log file
    trigger_1=TP(t).trig1;
    trigger_2=TP(t).trig2;
    trigger_3=TP(t).trig3;

    PsychPortAudio('FillBuffer', pahandle, (TP(t).syl1)); % loads data into buffer, first syllable
    TP(t).s1_start=toc; %saving timing of sound play to log file
    ppdev_mex('Write', 1, trigger_1);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1); %starts sound immediatley
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.05) %pause of 50ms between sounds
    
    PsychPortAudio('FillBuffer', pahandle, (TP(t).syl2)); %second syllable
    TP(t).s2_start=toc; 
    ppdev_mex('Write', 1, trigger_2);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.05)
    
    PsychPortAudio('FillBuffer', pahandle, (TP(t).syl3)); %third syllable
    TP(t).s3_start=toc; 
    ppdev_mex('Write', 1, trigger_3);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.9) %pause of 900ms between item and response
   
    Screen('DrawTexture', win, texture1); % correct, incorrect sign
    startRW = Screen(win,'flip'); %collect time of start response window
    trigger_4 = trigger_3+1; 
    ppdev_mex('Write', 1, trigger_4);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);

    [secs, keyCode]=KbWait; %collecting time
    endRW=secs; %collect time of end response window (response)
    TP(t).RT=endRW-startRW; % Store the RT
    KBresponse=KbName(keyCode); %collect keypress response
    KbReleaseWait; % wait for key release
    TP(t).response=KBresponse; %collect the pressed key 
    clear startRW
    clear endRW
    Screen(win,'flip');
    WaitSecs(0.5); %pause of 1000ms between items
    DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
    Screen(win, 'flip');
    WaitSecs(0.5);
    
end

%% Learning Phase 6

DrawFormattedText(win, 'ZUH??RPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of LP
Screen(win, 'flip');
KbWait; % waiting for keyboard 
KbReleaseWait;
DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
Screen(win, 'flip');
WaitSecs(1);

for k=481:576
    %Defining trigger names for log file
    trigger_1=LP(k).trig1;
    trigger_2=LP(k).trig2;
    trigger_3=LP(k).trig3;
    
    PsychPortAudio('FillBuffer', pahandle, (LP(k).syl1)); % loads data into buffer, first syllable
    LP(k).s1_start=toc; %saving timing of sound play to log file
    ppdev_mex('Write', 1, trigger_1);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1); %starts sound immediatley
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.05) %pause of 50ms between sounds
    
    PsychPortAudio('FillBuffer', pahandle, (LP(k).syl2)); %second syllable
    LP(k).s2_start=toc;
    ppdev_mex('Write', 1, trigger_2);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.05)
    
    PsychPortAudio('FillBuffer', pahandle, (LP(k).syl3)); %third syllable
    LP(k).s3_start=toc;
    ppdev_mex('Write', 1, trigger_3);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.7) %pause of 700ms between items
end

%% Testing Phase 6

DrawFormattedText(win, 'TESTPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of first TP
Screen(win, 'flip');
KbWait; % waiting for keyboard 
KbReleaseWait;
DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
Screen(win, 'flip');
WaitSecs(1);

for t=121:144
    %Defining trigger names for log file
    trigger_1=TP(t).trig1;
    trigger_2=TP(t).trig2;
    trigger_3=TP(t).trig3;

    PsychPortAudio('FillBuffer', pahandle, (TP(t).syl1)); % loads data into buffer, first syllable
    TP(t).s1_start=toc; %saving timing of sound play to log file
    ppdev_mex('Write', 1, trigger_1);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1); %starts sound immediatley
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.05) %pause of 50ms between sounds
    
    PsychPortAudio('FillBuffer', pahandle, (TP(t).syl2)); %second syllable
    TP(t).s2_start=toc; 
    ppdev_mex('Write', 1, trigger_2);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.05)
    
    PsychPortAudio('FillBuffer', pahandle, (TP(t).syl3)); %third syllable
    TP(t).s3_start=toc; 
    ppdev_mex('Write', 1, trigger_3);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.9) %pause of 900ms between item and response
   
    Screen('DrawTexture', win, texture1); % correct, incorrect sign
    startRW = Screen(win,'flip'); %collect time of start response window
    trigger_4 = trigger_3+1; 
    ppdev_mex('Write', 1, trigger_4);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);

    [secs, keyCode]=KbWait; %collecting time
    endRW=secs; %collect time of end response window (response)
    TP(t).RT=endRW-startRW; % Store the RT
    KBresponse=KbName(keyCode); %collect keypress response
    KbReleaseWait; % wait for key release
    TP(t).response=KBresponse; %collect the pressed key 
    clear startRW
    clear endRW
    Screen(win,'flip');
    WaitSecs(0.5); %pause of 1000ms between items
    DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
    Screen(win, 'flip');
    WaitSecs(0.5);
    
end


%% Learning Phase 7

DrawFormattedText(win, 'ZUH??RPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of LP
Screen(win, 'flip');
KbWait; % waiting for keyboard 
KbReleaseWait;
DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
Screen(win, 'flip');
WaitSecs(1);

for k=9577:672
    %Defining trigger names for log file
    trigger_1=LP(k).trig1;
    trigger_2=LP(k).trig2;
    trigger_3=LP(k).trig3;
    
    PsychPortAudio('FillBuffer', pahandle, (LP(k).syl1)); % loads data into buffer, first syllable
    LP(k).s1_start=toc; %saving timing of sound play to log file
    ppdev_mex('Write', 1, trigger_1);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1); %starts sound immediatley
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.05) %pause of 50ms between sounds
    
    PsychPortAudio('FillBuffer', pahandle, (LP(k).syl2)); %second syllable
    LP(k).s2_start=toc;
    ppdev_mex('Write', 1, trigger_2);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.05)
    
    PsychPortAudio('FillBuffer', pahandle, (LP(k).syl3)); %third syllable
    LP(k).s3_start=toc;
    ppdev_mex('Write', 1, trigger_3);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.7) %pause of 700ms between items
end

%% Testing Phase 7

DrawFormattedText(win, 'TESTPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of first TP
Screen(win, 'flip');
KbWait; % waiting for keyboard 
KbReleaseWait;
DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
Screen(win, 'flip');
WaitSecs(1);

for t=145:168
    %Defining trigger names for log file
    trigger_1=TP(t).trig1;
    trigger_2=TP(t).trig2;
    trigger_3=TP(t).trig3;

    PsychPortAudio('FillBuffer', pahandle, (TP(t).syl1)); % loads data into buffer, first syllable
    TP(t).s1_start=toc; %saving timing of sound play to log file
    ppdev_mex('Write', 1, trigger_1);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1); %starts sound immediatley
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.05) %pause of 50ms between sounds
    
    PsychPortAudio('FillBuffer', pahandle, (TP(t).syl2)); %second syllable
    TP(t).s2_start=toc; 
    ppdev_mex('Write', 1, trigger_2);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.05)
    
    PsychPortAudio('FillBuffer', pahandle, (TP(t).syl3)); %third syllable
    TP(t).s3_start=toc; 
    ppdev_mex('Write', 1, trigger_3);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.9) %pause of 900ms between item and response
   
    Screen('DrawTexture', win, texture1); % correct, incorrect sign
    startRW = Screen(win,'flip'); %collect time of start response window
    trigger_4 = trigger_3+1; 
    ppdev_mex('Write', 1, trigger_4);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);

    [secs, keyCode]=KbWait; %collecting time
    endRW=secs; %collect time of end response window (response)
    TP(t).RT=endRW-startRW; % Store the RT
    KBresponse=KbName(keyCode); %collect keypress response
    KbReleaseWait; % wait for key release
    TP(t).response=KBresponse; %collect the pressed key 
    clear startRW
    clear endRW
    Screen(win,'flip');
    WaitSecs(0.5); %pause of 1000ms between items
    DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
    Screen(win, 'flip');
    WaitSecs(0.5);
    
end

%% Learning Phase 8

DrawFormattedText(win, 'ZUH??RPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of LP
Screen(win, 'flip');
KbWait; % waiting for keyboard 
KbReleaseWait;
DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
Screen(win, 'flip');
WaitSecs(1);

for k=673:768
    %Defining trigger names for log file
    trigger_1=LP(k).trig1;
    trigger_2=LP(k).trig2;
    trigger_3=LP(k).trig3;
    
    PsychPortAudio('FillBuffer', pahandle, (LP(k).syl1)); % loads data into buffer, first syllable
    LP(k).s1_start=toc; %saving timing of sound play to log file
    ppdev_mex('Write', 1, trigger_1);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1); %starts sound immediatley
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.05) %pause of 50ms between sounds
    
    PsychPortAudio('FillBuffer', pahandle, (LP(k).syl2)); %second syllable
    LP(k).s2_start=toc;
    ppdev_mex('Write', 1, trigger_2);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.05)
    
    PsychPortAudio('FillBuffer', pahandle, (LP(k).syl3)); %third syllable
    LP(k).s3_start=toc;
    ppdev_mex('Write', 1, trigger_3);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1);
    WaitSecs(0.7) %pause of 700ms between items
end

%% Testing Phase 8

DrawFormattedText(win, 'TESTPHASE', 'center', 'center', [0 0 0]); % Indicate beginning of first TP
Screen(win, 'flip');
KbWait; % waiting for keyboard 
KbReleaseWait;
DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
Screen(win, 'flip');
WaitSecs(1);

for t=169:192
    %Defining trigger names for log file
    trigger_1=TP(t).trig1;
    trigger_2=TP(t).trig2;
    trigger_3=TP(t).trig3;

    PsychPortAudio('FillBuffer', pahandle, (TP(t).syl1)); % loads data into buffer, first syllable
    TP(t).s1_start=toc; %saving timing of sound play to log file
    ppdev_mex('Write', 1, trigger_1);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1); %starts sound immediatley
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.05) %pause of 50ms between sounds
    
    PsychPortAudio('FillBuffer', pahandle, (TP(t).syl2)); %second syllable
    TP(t).s2_start=toc; 
    ppdev_mex('Write', 1, trigger_2);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.05)
    
    PsychPortAudio('FillBuffer', pahandle, (TP(t).syl3)); %third syllable
    TP(t).s3_start=toc; 
    ppdev_mex('Write', 1, trigger_3);
    WaitSecs(0.005);ppdev_mex('Write', 1, 0);

    PsychPortAudio('Start', pahandle, 1);
    PsychPortAudio('Stop', pahandle, 1)
    WaitSecs(0.9) %pause of 900ms between item and response
   
    Screen('DrawTexture', win, texture1); % correct, incorrect sign
    startRW = Screen(win,'flip'); %collect time of start response window
    trigger_4 = trigger_3+1; 
    ppdev_mex('Write', 1, trigger_4);
    WaitSecs(0.005);
    ppdev_mex('Write', 1, 0);

    [secs, keyCode]=KbWait; %collecting time
    endRW=secs; %collect time of end response window (response)
    TP(t).RT=endRW-startRW; % Store the RT
    KBresponse=KbName(keyCode); %collect keypress response
    KbReleaseWait; % wait for key release
    TP(t).response=KBresponse; %collect the pressed key 
    clear startRW
    clear endRW
    Screen(win,'flip');
    WaitSecs(0.5); %pause of 1000ms between items
    DrawFormattedText(win, '+', 'center', 'center', [0 0 0]); % Fixation cross
    Screen(win, 'flip');
    WaitSecs(0.5);
    
end

%% End of the experiment
PsychPortAudio('Close', pahandle);% Close the audio device 
ppdev_mex('Close', 1); %Close the parallel port for sending triggers
ppdev_mex('CloseAll');

DrawFormattedText(win, 'Das Experiment ist beendet \n \n Danke, dass Du teilgenommen hast!', 'center', 'center', 0); %flush screen buffer with text
Screen(win,'flip'); %display text in window
KbWait; % waiting for keyboard 
KbReleaseWait;
WaitSecs(3);

Screen('CloseAll'); %closes the screen
SubID=char(SubID);
save(strcat('sub_',partinfo(1),'\MyOutput_',partinfo(1), '_', partinfo(2), '_LP'), 'LP');  %% save the log file for LP
save(strcat('sub_',partinfo(1),'\MyOutput_',partinfo(1), '_', partinfo(2), '_TP'), 'TP');  %% save the log file for TP
