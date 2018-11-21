%% %%Experiment script for Study Project
%"The Investigation of Artificial Grammar Learning Using Auditory Steady-State Evoked Potentials"
%Two blocks containing 4 learning and 4 testing phases

clear all; %clears all variables
close all; %closes all windows

%Screen('Preference', 'SkipSyncTests', 1);

InitializePsychSound(0); %initializing sound driver
audio_port = 7; %specifying audio port
%audio_port = 10; %specifying audio port on experiment machine
pause_duration = 0;
KbName('UnifyKeyNames'); %portability of your code across operating systems
activeKeys=[KbName('x') KbName('c') KbName('v') KbName('b') KbName('n')];%keys usable as response in test phase

%mex ppdev_mex.c -v; %needed for triggers

%% 
%%Load sound files 
%{
pe_=transpose(psychwavread('wavs/pe.wav'));
pe_=resample(pe_,44100,22050);
fi_=transpose(psychwavread('wavs/fi.wav'));
fi_=resample(fi_,44100,22050);
lo_=transpose(psychwavread('wavs/lo.wav'));
lo_=resample(lo_,44100,22050);
to_=transpose(psychwavread('wavs/to.wav'));
to_=resample(to_,44100,22050);
se_=transpose(psychwavread('wavs/se.wav'));
se_=resample(se_,44100,22050);
ba_=transpose(psychwavread('wavs/ba.wav'));
ba_=resample(ba_,44100,22050);
fu_=transpose(psychwavread('wavs/fu.wav'));
fu_=resample(fu_,44100,22050);
bo_=transpose(psychwavread('wavs/bo.wav'));
bo_=resample(bo_,44100,22050);
be_=transpose(psychwavread('wavs/be.wav'));
be_=resample(be_,44100,22050);
di_=transpose(psychwavread('wavs/di.wav'));
di_=resample(di_,44100,22050);
do_=transpose(psychwavread('wavs/do.wav'));
do_=resample(do_,44100,22050);
fa_=transpose(psychwavread('wavs/fa.wav'));
fa_=resample(fa_,44100,22050);
fe_=transpose(psychwavread('wavs/fe.wav'));
fe_=resample(fe_,44100,22050);
ka_=transpose(psychwavread('wavs/ka.wav'));
ka_=resample(ka_,44100,22050);
ki_=transpose(psychwavread('wavs/ki.wav'));
ki_=resample(ki_,44100,22050);
ko_=transpose(psychwavread('wavs/ko.wav'));
ko_=resample(ko_,44100,22050);
la_=transpose(psychwavread('wavs/la.wav'));
la_=resample(la_,44100,22050);
le_=transpose(psychwavread('wavs/le.wav'));
le_=resample(le_,44100,22050);
li_=transpose(psychwavread('wavs/li.wav'));
li_=resample(li_,44100,22050);
mi_=transpose(psychwavread('wavs/mi.wav'));
mi_=resample(mi_,44100,22050);
ne_=transpose(psychwavread('wavs/ne.wav'));
ne_=resample(ne_,44100,22050);
ni_=transpose(psychwavread('wavs/ni.wav'));
ni_=resample(ni_,44100,22050);
pi_=transpose(psychwavread('wavs/pi.wav'));
pi_=resample(pi_,44100,22050);
pa_=transpose(psychwavread('wavs/pa.wav'));
pa_=resample(pa_,44100,22050);
po_=transpose(psychwavread('wavs/po.wav'));
po_=resample(po_,44100,22050);
ra_=transpose(psychwavread('wavs/ra.wav'));
ra_=resample(ra_,44100,22050);
ro_=transpose(psychwavread('wavs/ro.wav'));
ro_=resample(ro_,44100,22050);
ri_=transpose(psychwavread('wavs/ri.wav'));
ri_=resample(ri_,44100,22050);
sa_=transpose(psychwavread('wavs/sa.wav'));
sa_=resample(sa_,44100,22050);
so_=transpose(psychwavread('wavs/so.wav'));
so_=resample(so_,44100,22050);
te_=transpose(psychwavread('wavs/te.wav'));
te_=resample(te_,44100,22050);
ti_=transpose(psychwavread('wavs/ti.wav'));
ti_=resample(ti_,44100,22050);
wa_=transpose(psychwavread('wavs/wa.wav'));
wa_=resample(wa_,44100,22050);
we_=transpose(psychwavread('wavs/we.wav'));
we_=resample(we_,44100,22050);
du_=transpose(psychwavread('wavs/du.wav'));
du_=resample(du_,44100,22050);
go_=transpose(psychwavread('wavs/go.wav'));
go_=resample(go_,44100,22050);
si_=transpose(psychwavread('wavs/si.wav'));
si_=resample(si_,44100,22050);
lu_=transpose(psychwavread('wavs/lu.wav'));
lu_=resample(lu_,44100,22050);
ta_=transpose(psychwavread('wavs/ta.wav'));
ta_=resample(ta_,44100,22050);
me_=transpose(psychwavread('wavs/me.wav'));
me_=resample(me_,44100,22050);
fo_=transpose(psychwavread('wavs/fo.wav'));
fo_=resample(fo_,44100,22050);
ho_=transpose(psychwavread('wavs/ho.wav'));
ho_=resample(ho_,44100,22050);
hi_=transpose(psychwavread('wavs/hi.wav'));
hi_=resample(hi_,44100,22050);
ku_=transpose(psychwavread('wavs/ku.wav'));
ku_=resample(ku_,44100,22050);
ma_=transpose(psychwavread('wavs/ma.wav'));
ma_=resample(ma_,44100,22050);
mu_=transpose(psychwavread('wavs/mu.wav'));
mu_=resample(mu_,44100,22050);
na_=transpose(psychwavread('wavs/na.wav'));
na_=resample(na_,44100,22050);
no_=transpose(psychwavread('wavs/no.wav'));
no_=resample(no_,44100,22050);
nu_=transpose(psychwavread('wavs/nu.wav'));
nu_=resample(nu_,44100,22050);
su_=transpose(psychwavread('wavs/su.wav'));
su_=resample(su_,44100,22050);
pu_=transpose(psychwavread('wavs/pu.wav'));
pu_=resample(pu_,44100,22050);
tu_=transpose(psychwavread('wavs/tu.wav'));
tu_=resample(tu_,44100,22050);
za_=transpose(psychwavread('wavs/za.wav'));
za_=resample(za_,44100,22050);
zo_=transpose(psychwavread('wavs/zo.wav'));
zo_=resample(zo_,44100,22050);
%}
%%Load mat sound file (collection of all syllables)
load sounds.mat;

%% The initial prompt to enter all important participant info, correct grammar to learn and mode
prompt={'Participant ID: ', 'Correct Grammar (1/2): ', 'Correct Grammar List (A/B):', 'Incorrect Grammar List (A/B):'}; %Enter participant ID (always two digits!!) and mode
num_lines=1;
partinfo=inputdlg(prompt,'Participant info');
participant_ID = partinfo(1);
c_grammar = char(partinfo(2)); %correct grammar
ic_grammar = '2'; % incorrect grammar
ic_grammar(c_grammar == ic_grammar) = '1'; %make sure to use other grammar as incorrect
cg_mode = upper(char(partinfo(3))); % the set for the correct grammar
icg_mode = upper(char(partinfo(4))); % the set for the incorrect grammar

%% Create a directory for each participant to save the log files 
dir_name= strcat('log/Sub_',char(participant_ID),'_',c_grammar,cg_mode,'_',ic_grammar,icg_mode);
log_folder = strcat(dir_name , '/'); %specifies where the log file (with the button presses) is going to be saved
mkdir(dir_name); %creates a directory for each participant, e.g. 'Sub_01_1A_2B'

%% Load button gfx
[TP_pic, ~, alpha] =imread('pics/testphaseM.png'); %load (left correct) button press cue
TP_pic(:, :, 4) = alpha; %make sure we get the right alpha values

%% load instruction file
instructions=fileread('txt/instructions.txt'); %loads text from text file and saves it as variable instructions
instructions2=fileread('txt/instructions2.txt');%load text for 2nd part of experiment

%% specify the number of trials, sentences, phases
% 40 sentences in learning phases
numLearnTrials = 40;
% 4*16 sentences in test phase
numTestSentPerTrial = 16;
numTestTrials = 4* numTestSentPerTrial;

%% %% Import the lists for both LEARNING PHASES (items) from the Excel file
basic = 'basic'; %for machines not having excel installed
%basic = '';
%correct grammar set
LP1 = createStructureFromXLS(strcat('xls/correct/G',c_grammar,'_LP_', cg_mode,'.xlsx'), basic, numLearnTrials);
%incorrect grammar set
LP2 = createStructureFromXLS(strcat('xls/incorrect/G',ic_grammar,'_LP_', icg_mode,'.xlsx'), basic, numLearnTrials);

%% %% Import lists for TEST PHASES
TP1 = createStructureFromXLS(strcat('xls/correct/G',c_grammar,'_TP_', cg_mode,'.xlsx'), basic, numTestTrials);
TP2 = createStructureFromXLS(strcat('xls/incorrect/G',ic_grammar,'_TP_', icg_mode,'.xlsx'), basic, numTestTrials);

%% %% Open the experiment screen
tic; %starts measuring time (important if you want reaction times for the button presses)
% define screen called "win" main screen window (0), color, on screen coordinates of window (full screen)
%win= Screen('OpenWindow',0,[158 158 158], [0 0 1960 1020]);
win= Screen('OpenWindow',0,[158 158 158]);
Priority(MaxPriority(win)); %window always in foreground
HideCursor(); %hides cursor during experiment
Screen('Preference', 'TextRenderer', 1); %uses high definition text renderer
Screen('TextSize', win, 28); %specifies font size
Screen('TextFont', win, 'Arial'); %specifies font
Screen('TextStyle', win, 0); %Specifies text color (0=black)
Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA'); %use alpha channels for gfx

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
LP1_1 = learningPhase(LP1, numLearnTrials, win, pa_handle, pause_duration);

%% Begin Test Phase 1 - correct grammar
testCount= 1;
TP1 = testPhase(TP1, testCount, numTestSentPerTrial, win, pa_handle,texture1,activeKeys);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 2 - correct grammar
LP1_2 = learningPhase(LP1, numLearnTrials, win, pa_handle, pause_duration);

%% Begin Test Phase 2 - correct grammar
TP1 = testPhase(TP1, testCount, (testCount+(numTestSentPerTrial-1)), win, pa_handle,texture1,activeKeys);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 3 - correct grammar
LP1_3 = learningPhase(LP1, numLearnTrials, win, pa_handle, pause_duration);

%% Begin Test Phase 3 - correct grammar
TP1 = testPhase(TP1, testCount, (testCount+numTestSentPerTrial-1), win, pa_handle,texture1,activeKeys);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 4 - correct grammar
LP1_4 = learningPhase(LP1, numLearnTrials, win, pa_handle, pause_duration);

%% Begin Test Phase 4 - correct grammar
TP1 = testPhase(TP1, testCount, (testCount+numTestSentPerTrial-1), win, pa_handle,texture1,activeKeys);
testCount= 1; %reset testcount for next block

%% Save files for first block
LP1 = [LP1_1,LP1_2,LP1_3,LP1_4];  
save(strcat(log_folder, 'LP1'), 'LP1');  %% save the log file for LP
save(strcat(log_folder, 'TP1'), 'TP1');  %% save the log file for TP

%% Show screen in between the two blocks
showInstructions(win, instructions2);

%% Begin Learning Phase 1 - incorrect grammar
LP2_1 = learningPhase(LP2, numLearnTrials, win, pa_handle, pause_duration);

%% Begin Test Phase 1 - incorrect grammar
TP2 = testPhase(TP2, testCount, numTestSentPerTrial, win, pa_handle,texture1,activeKeys);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 2 - incorrect grammar
LP2_2 = learningPhase(LP2, numLearnTrials, win, pa_handle, pause_duration);

%% Begin Test Phase 2 - incorrect grammar
TP2 = testPhase(TP2, testCount, (testCount+numTestSentPerTrial-1), win, pa_handle,texture1,activeKeys);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 3 - incorrect grammar
LP2_3 = learningPhase(LP2, numLearnTrials, win, pa_handle, pause_duration);

%% Begin Test Phase 3 - incorrect grammar
TP2 = testPhase(TP2, testCount, (testCount+numTestSentPerTrial-1), win, pa_handle,texture1,activeKeys);
testCount = testCount+numTestSentPerTrial;

%% Begin Learning Phase 4 - incorrect grammar
LP2_4 = learningPhase(LP2, numLearnTrials, win, pa_handle, pause_duration);

%% Begin Test Phase 4 - incorrect grammar
TP2 = testPhase(TP2, testCount, (testCount+numTestSentPerTrial-1), win, pa_handle,texture1,activeKeys);
clear testCount;

%% Save the results of block 2 in previously created folder
LP2 = [LP2_1,LP2_2,LP2_3,LP2_4];  
save(strcat(log_folder, 'LP2'), 'LP2');  %% save the log file for LP
save(strcat(log_folder, 'TP2'), 'TP2');  %% save the log file for TP

%% End of the experiment
PsychPortAudio('Close', pa_handle);% Close the audio device 
ppdev_mex('Close', 1); %Close the parallel port for sending triggers
ppdev_mex('CloseAll');

DrawFormattedText(win, 'Das Experiment ist beendet. \n \n Danke, dass Du teilgenommen hast!', 'center', 'center', 0); %flush screen buffer with text
Screen(win,'flip'); %display text in window
KbWait; % waiting for keyboard 
KbReleaseWait;
WaitSecs(3);

Screen('CloseAll'); %closes the screen