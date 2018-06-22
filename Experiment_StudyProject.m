%% %%Experiment script for Study Project "Study Project: 
%The Investigation of Artificial Grammar Learning Using Auditory Steady-State Evoked Potentials
%Two blocks containing 4 learning and 4 testing phases

clear all %clears all variables
close all %closes all windows
InitializePsychSound(0); %initializing sound driver
audio_port = 7; %specifying audio port

%mex ppdev_mex.c -v %needed for triggers

%% 
%%Load sound files 
%{
pe=transpose(psychwavread('wavs/pe.wav'));
fi=transpose(psychwavread('wavs/fi.wav'));
lo=transpose(psychwavread('wavs/lo.wav'));
to=transpose(psychwavread('wavs/to.wav'));
se=transpose(psychwavread('wavs/se.wav'));
ba=transpose(psychwavread('wavs/ba.wav'));
fu=transpose(psychwavread('wavs/fu.wav'));
bo=transpose(psychwavread('wavs/bo.wav'));
be=transpose(psychwavread('wavs/be.wav'));
di=transpose(psychwavread('wavs/di.wav'));
do=transpose(psychwavread('wavs/do.wav'));
fa=transpose(psychwavread('wavs/fa.wav'));
fe=transpose(psychwavread('wavs/fe.wav'));
ka=transpose(psychwavread('wavs/ka.wav'));
ki=transpose(psychwavread('wavs/ki.wav'));
ko=transpose(psychwavread('wavs/ko.wav'));
la=transpose(psychwavread('wavs/la.wav'));
le=transpose(psychwavread('wavs/le.wav'));
li=transpose(psychwavread('wavs/li.wav'));
mi=transpose(psychwavread('wavs/mi.wav'));
ne=transpose(psychwavread('wavs/ne.wav'));
ni=transpose(psychwavread('wavs/ni.wav'));
pi=transpose(psychwavread('wavs/pi.wav'));
pa=transpose(psychwavread('wavs/pa.wav'));
po=transpose(psychwavread('wavs/po.wav'));
ra=transpose(psychwavread('wavs/ra.wav'));
ro=transpose(psychwavread('wavs/ro.wav'));
ri=transpose(psychwavread('wavs/ri.wav'));
sa=transpose(psychwavread('wavs/sa.wav'));
so=transpose(psychwavread('wavs/so.wav'));
te=transpose(psychwavread('wavs/te.wav'));
ti=transpose(psychwavread('wavs/ti.wav'));
wa=transpose(psychwavread('wavs/wa.wav'));
we=transpose(psychwavread('wavs/we.wav'));
ba=transpose(psychwavread('wavs/ba.wav'));
du=transpose(psychwavread('wavs/du.wav'));
go=transpose(psychwavread('wavs/go.wav'));
si=transpose(psychwavread('wavs/si.wav'));
lu=transpose(psychwavread('wavs/lu.wav'));
ki=transpose(psychwavread('wavs/ki.wav'));
ta=transpose(psychwavread('wavs/ta.wav'));
me=transpose(psychwavread('wavs/me.wav'));
fo=transpose(psychwavread('wavs/fo.wav'));
ho=transpose(psychwavread('wavs/ho.wav'));
hi=transpose(psychwavread('wavs/hi.wav'));
ku=transpose(psychwavread('wavs/ku.wav'));
ma=transpose(psychwavread('wavs/ma.wav'));
mu=transpose(psychwavread('wavs/mu.wav'));
na=transpose(psychwavread('wavs/na.wav'));
no=transpose(psychwavread('wavs/no.wav'));
nu=transpose(psychwavread('wavs/nu.wav'));
su=transpose(psychwavread('wavs/su.wav'));
pu=transpose(psychwavread('wavs/pu.wav'));
%}

%%Load mat sound file (collection of all syllables)
load sounds_test.mat

%% The initial prompt to enter all important participant info, correct grammar to learn and mode
prompt={'Participant ID: ', 'Correct Grammar: ', 'Correct Grammar List:', 'Incorrect Grammar List:'}; %Enter participant ID (always two digits!!) and mode
dlg_title='Participant Info';
num_lines=1;
partinfo=inputdlg(prompt,dlg_title);

%% Create a directory for each participant to save the log files 
mkdir(strcat('log/Sub_',char(partinfo(1)),char(partinfo(2)),char(partinfo(3)))); %creates a directory for each participant, e.g. 'Sub_01_A'
log_folder = strcat('log/Sub_',char(partinfo(1)),char(partinfo(2)),char(partinfo(3)), '/'); %specifies where the log file (with the button presses) is going to be saved
grammar= strcat(char(partinfo(2))); %defines which of the grammars should be learned correctly
noGrammar = 2;
noGrammar(grammar == 2) = 1; %make sure the incorrect grammar is the other set (depending on correct grammar)
gram_mode=strcat(char(partinfo(3))); %defines the set for the correct grammar
ungram_mode=strcat(char(partinfo(4))); %defines the set for the incorrect grammar



%% Define button mode
if mod(char(partinfo(1)), 2) == 0  %even numbered participant ID
      TP_pic=imread('pics/left.png'); %load (left correct) button press cue
else %if part.no. is even
    TP_pic=imread('pics/right.png'); %load (right correct) button press cue
end

%% load instruction file
instructions=fileread('txt/instructions.txt'); %loads text from text file and saves it as variable instructions
instructions2=fileread('txt/instructions2.txt');%load text for 2nd part of experiment

%% specify the number of trials, sentences, phases
numTrials = 4;
% 40 sentences in learning phases
numLearnTrials = 40;
numLearnTrials = 5; %DEBUG VALUE
% 4*8 sentences in test phase
numTestSentPerTrial = 8;
numTestTrials = numTrials* numTestSentPerTrial;
numTestTrials= 5; %DEBUG VALUE

%% define which grammar is going to be ungrammatical 
noGrammar = 2; %the ungrammatical grammar type
if grammar == 2
    noGrammar = 1;
end; 

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
%1-8
TP1 = testPhase(TP1, testCount, numTestSentPerTrial, win, pa_handle);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 2 - correct grammar
LP1 = learningPhase(LP1, numLearnTrials, win, pa_handle);

%% Begin Test Phase 2 - correct grammar
%9-16
TP1 = testPhase(TP1, testCount, (testCount+numTestSentPerTrial), win, pa_handle);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 3 - correct grammar
LP1 = learningPhase(LP1, numLearnTrials, win, pa_handle);

%% Begin Test Phase 3 - correct grammar
%17-24
TP1 = testPhase(TP1, testCount, (testCount+numTestSentPerTrial), win, pa_handle);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 4 - correct grammar
LP1 = learningPhase(LP1, numLearnTrials, win, pa_handle);

%% Begin Test Phase 4 - correct grammar
%25-32
TP1 = testPhase(TP1, testCount, (testCount+numTestSentPerTrial), win, pa_handle);
testCount= 1; %reset testcount for next block

%% Show screen in between the two blocks
showInstructions(win, instructions2);

%% Begin Learning Phase 1 - incorrect grammar
LP2 = learningPhase(LP2, numLearnTrials, win, pa_handle);

%% Begin Test Phase 1 - incorrect grammar
%1-8
TP2 = testPhase(TP2, testCount, numTestSentPerTrial, win, pa_handle);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 2 - incorrect grammar
LP2 = learningPhase(LP2, numLearnTrials, win, pa_handle);

%% Begin Test Phase 2 - incorrect grammar
%9-16
TP2 = testPhase(TP2, testCount, (testCount+numTestSentPerTrial), win, pa_handle);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 3 - incorrect grammar
LP2 = learningPhase(LP2, numLearnTrials, win, pa_handle);

%% Begin Test Phase 3 - incorrect grammar
%17-24
TP2 = testPhase(TP2, testCount, (testCount+numTestSentPerTrial), win, pa_handle);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 4 - incorrect grammar
LP2 = learningPhase(LP2, numLearnTrials, win, pa_handle);

%% Begin Test Phase 4 - incorrect grammar
%25-32
TP2 = testPhase(TP2, testCount, (testCount+numTestSentPerTrial), win, pa_handle);
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
SubID=char(SubID);
save(strcat('sub_',partinfo(1),'\MyOutput_',partinfo(1), '_', partinfo(2),'_',partinfo(3),'_',partinfo(4), '_LP'), 'LP');  %% save the log file for LP
save(strcat('sub_',partinfo(1),'\MyOutput_',partinfo(1), '_', partinfo(2),'_',partinfo(3),'_',partinfo(4), '_TP'), 'TP');  %% save the log file for TP
