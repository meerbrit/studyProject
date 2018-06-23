%% %%Experiment script for Study Project "Study Project: 
%The Investigation of Artificial Grammar Learning Using Auditory Steady-State Evoked Potentials
%Two blocks containing 4 learning and 4 testing phases

clear all; %clears all variables
close all; %closes all windows
InitializePsychSound(0); %initializing sound driver
audio_port = 7; %specifying audio port

%mex ppdev_mex.c -v; %needed for triggers

%% 
%%Load sound files 
%{
pe_=transpose(psychwavread('wavs/pe.wav'));
fi_=transpose(psychwavread('wavs/fi.wav'));
lo_=transpose(psychwavread('wavs/lo.wav'));
to_=transpose(psychwavread('wavs/to.wav'));
se_=transpose(psychwavread('wavs/se.wav'));
ba_=transpose(psychwavread('wavs/ba.wav'));
fu_=transpose(psychwavread('wavs/fu.wav'));
bo_=transpose(psychwavread('wavs/bo.wav'));
be_=transpose(psychwavread('wavs/be.wav'));
di_=transpose(psychwavread('wavs/di.wav'));
do_=transpose(psychwavread('wavs/do.wav'));
fa_=transpose(psychwavread('wavs/fa.wav'));
fe_=transpose(psychwavread('wavs/fe.wav'));
ka_=transpose(psychwavread('wavs/ka.wav'));
ki_=transpose(psychwavread('wavs/ki.wav'));
ko_=transpose(psychwavread('wavs/ko.wav'));
la_=transpose(psychwavread('wavs/la.wav'));
le_=transpose(psychwavread('wavs/le.wav'));
li_=transpose(psychwavread('wavs/li.wav'));
mi_=transpose(psychwavread('wavs/mi.wav'));
ne_=transpose(psychwavread('wavs/ne.wav'));
ni_=transpose(psychwavread('wavs/ni.wav'));
pi_=transpose(psychwavread('wavs/pi.wav'));
pa_=transpose(psychwavread('wavs/pa.wav'));
po_=transpose(psychwavread('wavs/po.wav'));
ra_=transpose(psychwavread('wavs/ra.wav'));
ro_=transpose(psychwavread('wavs/ro.wav'));
ri_=transpose(psychwavread('wavs/ri.wav'));
sa_=transpose(psychwavread('wavs/sa.wav'));
so_=transpose(psychwavread('wavs/so.wav'));
te_=transpose(psychwavread('wavs/te.wav'));
ti_=transpose(psychwavread('wavs/ti.wav'));
wa_=transpose(psychwavread('wavs/wa.wav'));
we_=transpose(psychwavread('wavs/we.wav'));
du_=transpose(psychwavread('wavs/du.wav'));
go_=transpose(psychwavread('wavs/go.wav'));
si_=transpose(psychwavread('wavs/si.wav'));
lu_=transpose(psychwavread('wavs/lu.wav'));
ta_=transpose(psychwavread('wavs/ta.wav'));
me_=transpose(psychwavread('wavs/me.wav'));
fo_=transpose(psychwavread('wavs/fo.wav'));
ho_=transpose(psychwavread('wavs/ho.wav'));
hi_=transpose(psychwavread('wavs/hi.wav'));
ku_=transpose(psychwavread('wavs/ku.wav'));
ma_=transpose(psychwavread('wavs/ma.wav'));
mu_=transpose(psychwavread('wavs/mu.wav'));
na_=transpose(psychwavread('wavs/na.wav'));
no_=transpose(psychwavread('wavs/no.wav'));
nu_=transpose(psychwavread('wavs/nu.wav'));
su_=transpose(psychwavread('wavs/su.wav'));
pu_=transpose(psychwavread('wavs/pu.wav'));
%}
%%Load mat sound file (collection of all syllables)
load sounds.mat;

%% The initial prompt to enter all important participant info, correct grammar to learn and mode
prompt={'Participant ID: ', 'Correct Grammar: ', 'Correct Grammar List:', 'Incorrect Grammar List:'}; %Enter participant ID (always two digits!!) and mode
dlg_title='Participant Info';
num_lines=1;
partinfo=inputdlg(prompt,dlg_title);

%% Create a directory for each participant to save the log files 
mkdir(strcat('log/Sub_',char(partinfo(1)),'_', char(partinfo(2)),upper(char(partinfo(3))),'_',upper(char(partinfo(4))))); %creates a directory for each participant, e.g. 'Sub_01_1A_2B'
log_folder = strcat('log/Sub_',char(partinfo(1)),'_',char(partinfo(2)),upper(char(partinfo(3))),'_',upper(char(partinfo(4))), '/'); %specifies where the log file (with the button presses) is going to be saved

%% Define button mode
if mod(char(partinfo(1)), 2) == 0  %even numbered participant ID
      TP_pic=imread('pics/left.png'); %load (left correct) button press cue
      correct_btn = 'left';
else %if part.no. is even
    TP_pic=imread('pics/right.png'); %load (right correct) button press cue
    correct_btn = 'right';
end

%% Grammar mode settings
grammar= strcat(char(partinfo(2))); %defines which of the grammars should be learned correctly
gram_mode=upper(strcat(char(partinfo(3)))); %defines the set for the correct grammar, make sure its capital
ungram_mode=upper(strcat(char(partinfo(4)))); %defines the set for the incorrect grammar, make sure its capital
% define which grammar is going to be ungrammatical 
noGrammar = 2; %the ungrammatical grammar type
if grammar == 2
    noGrammar = 1;
end

%% load instruction file
instructions=fileread('txt/instructions.txt'); %loads text from text file and saves it as variable instructions
instructions2=fileread('txt/instructions2.txt');%load text for 2nd part of experiment

%% specify the number of trials, sentences, phases
% 40 sentences in learning phases
numLearnTrials = 40;
numLearnTrials = 3; %DEBUG
% 4*8 sentences in test phase
numTestSentPerTrial = 8;
numTestSentPerTrial = 2; %DEBUG
numTestTrials = 4* numTestSentPerTrial;

%% %% Import the lists for both LEARNING PHASES (items) from the Excel file
basic = 'basic'; %for machines not having excel installed
%basic = '';
LP1 = createStructureFromXLS(strcat('xls/G',num2str(grammar),'_LP_', gram_mode,'.xlsx'), basic, numLearnTrials);
LP2 = createStructureFromXLS(strcat('xls/G',num2str(noGrammar),'_LP_', ungram_mode,'.xlsx'), basic, numLearnTrials);

%% %% Import lists for TEST PHASES
%TODO: which test phase to use- balancing!
testModeGram= 'A';
testMode(gram_mode == 'A')='B';

TP1 = createStructureFromXLS(strcat('xls/G',num2str(grammar),'_TP_', testMode,'.xlsx'), basic, numTestTrials);
TP2 = createStructureFromXLS(strcat('xls/G',num2str(noGrammar),'_TP_', testMode,'.xlsx'), basic, numTestTrials);

%% %% Open the experiment screen
tic; %starts measuring time (important if you want reaction times for the button presses)
% define screen called "win" main screen window (0), color, on screen coordinates of window (full screen)
win= Screen('OpenWindow',0,[158 158 158], [0 0 1960 1020]); 
Priority(MaxPriority(win)); %window always in foreground
HideCursor(); %hides cursor during experiment
Screen('Preference', 'TextRenderer', 1); %uses high definition text renderer
Screen('TextSize', win, 40); %specifies font size
Screen('TextFont', win, 'Arial'); %specifies font
Screen('TextStyle', win, 0); %Specifies text color (0=black)

texture1=Screen('MakeTexture', win, TP_pic); %converts the previously loaded image (lines 80-82) into a texture which can later be displayed on the screen

%% %% open the parallel port  
%necessary to send triggers
ppdev_mex('Open', 1);
start=100;
ppdev_mex('Write', 1, start); %trigger 100 is sent at beginning of experiment
WaitSecs(0.001);
ppdev_mex('Write', 1, 0); %trigger always needs to be set back to 0, otherwise it continuously sends a number (and not only at one point in time)

%% open audio port
pa_handle = PsychPortAudio('Open', audio_port, 1, [],[],1,[], [], []); %open audioport

%% Show instructions on the screen
showInstructions(win, instructions);

%% Begin Learning Phase 1 - correct grammar
LP1 = learningPhase(LP1, numLearnTrials, win, pa_handle);

%% Begin Test Phase 1 - correct grammar
testCount= 1;
TP1 = testPhase(TP1, testCount, numTestSentPerTrial, win, pa_handle,texture1);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 2 - correct grammar
LP1 = learningPhase(LP1, numLearnTrials, win, pa_handle);

%% Begin Test Phase 2 - correct grammar
TP1 = testPhase(TP1, testCount, (testCount+(numTestSentPerTrial-1)), win, pa_handle,texture1);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 3 - correct grammar
LP1 = learningPhase(LP1, numLearnTrials, win, pa_handle);

%% Begin Test Phase 3 - correct grammar
TP1 = testPhase(TP1, testCount, (testCount+numTestSentPerTrial-1), win, pa_handle,texture1);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 4 - correct grammar
LP1 = learningPhase(LP1, numLearnTrials, win, pa_handle);

%% Begin Test Phase 4 - correct grammar
TP1 = testPhase(TP1, testCount, (testCount+numTestSentPerTrial-1), win, pa_handle,texture1);
testCount= 1; %reset testcount for next block

%% Show screen in between the two blocks
showInstructions(win, instructions2);

%% Begin Learning Phase 1 - incorrect grammar
LP2 = learningPhase(LP2, numLearnTrials, win, pa_handle);

%% Begin Test Phase 1 - incorrect grammar
TP2 = testPhase(TP2, testCount, numTestSentPerTrial, win, pa_handle,texture1);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 2 - incorrect grammar
LP2 = learningPhase(LP2, numLearnTrials, win, pa_handle);

%% Begin Test Phase 2 - incorrect grammar
TP2 = testPhase(TP2, testCount, (testCount+numTestSentPerTrial-1), win, pa_handle,texture1);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 3 - incorrect grammar
LP2 = learningPhase(LP2, numLearnTrials, win, pa_handle);

%% Begin Test Phase 3 - incorrect grammar
TP2 = testPhase(TP2, testCount, (testCount+numTestSentPerTrial-1), win, pa_handle,texture1);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 4 - incorrect grammar
LP2 = learningPhase(LP2, numLearnTrials, win, pa_handle);

%% Begin Test Phase 4 - incorrect grammar
TP2 = testPhase(TP2, testCount, (testCount+numTestSentPerTrial-1), win, pa_handle,texture1);
clear testCount;

%% End of the experiment
PsychPortAudio('Close', pa_handle);% Close the audio device 
ppdev_mex('Close', 1); %Close the parallel port for sending triggers
ppdev_mex('CloseAll');

DrawFormattedText(win, 'Das Experiment ist beendet \n \n Danke, dass Du teilgenommen hast!', 'center', 'center', 0); %flush screen buffer with text
Screen(win,'flip'); %display text in window
KbWait; % waiting for keyboard 
KbReleaseWait;
WaitSecs(3);

Screen('CloseAll'); %closes the screen

%% Save the results in previously created folder
save(strcat(log_folder, 'LP1'), 'LP1');  %% save the log file for LP
save(strcat(log_folder, 'TP1'), 'TP1');  %% save the log file for TP
save(strcat(log_folder, 'LP2'), 'LP2'); 
save(strcat(log_folder, 'TP2'), 'TP2');