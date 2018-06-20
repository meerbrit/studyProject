%%Experiment script for Study Project "Study Project: 
%The Investigation of Artificial Grammar Learning Using Auditory Steady-State Evoked Potentials
%Two blocks containing 4 learning and 4 testing phases

clear all %clears all variables
close all %closes all windows
InitializePsychSound(0); %initializing sound driver
audio_port = 7; %specifying audio port

%mex ppdev_mex.c %needed for triggers

%% 
%%Load sound files 
% loading only one sample file for now
%bi=transpose(psychwavread('bi.wav'));
%bi2= transpose(psychwavread('bi.wav'));

%%Load mat sound file (collection of all syllables)
load sounds_test.mat
%% The initial prompt to enter all important participant info and mode
prompt={'Participant ID: ', 'Mode/List: '}; %Enter participant ID (always two digits!!) and mode
dlg_title='Participant Info';
num_lines=1;
partinfo=inputdlg(prompt,dlg_title);

%% Create a directory for each participant to save the log files 
mkdir(strcat('log/Sub_',char(partinfo(1)),char(partinfo(2)))); %creates a directory for each participant, e.g. 'Sub_01_A'
log_folder = strcat('log/Sub_',char(partinfo(1)),char(partinfo(2)), '/'); %specifies where the log file (with the button presses) is going to be saved
mode=strcat(char(partinfo(2))); %defines the mode as the input of the second line of the prompt above

%% Define button mode
if mod(char(partinfo(1)), 2) == 0  %even numbered participant ID
      TP_pic=imread('pics/left.png'); %load (left correct) button press cue
else %if part.no. is even
    TP_pic=imread('pics/right.png'); %load (right correct) button press cue
end

%% load instruction file
instructions=fileread('instructions2.txt'); %loads text from text file and saves it as variable instructions
%% %% Import the list with the first LEARNING PHASE items from the Excel file
% and save it into structue
[~,~,raw]=xlsread(strcat('LP_G', mode,'.xlsx'), 1, '', ''); 
numTrials=5; %setting no. of trials in LP 
%In a for loop, you create denominations for each column from the original
%Excel file and read it into a structure line by line
%The structure is called LP1 (= learning phase).
for k=1:numTrials
    LP1(k).stimulus_number=cell2mat(raw(k,1));%first columns = stimulus number
    LP1(k).syll_l_1=char(raw(k,2)); %char specifies text input, 2 reads the second column
    LP1(k).syll_l_2=char(raw(k,3)); 
    LP1(k).syll_2_1=char(raw(k,4));
    LP1(k).syll_2_2=char(raw(k,5));
    LP1(k).syll_3_1=char(raw(k,6));
    LP1(k).syll_3_2=char(raw(k,7));% all syllables defined
    LP1(k).trig_1_1=cell2mat(raw(k,8)); %define trigger
    LP1(k).trig_1_2=cell2mat(raw(k,9));
    LP1(k).trig_2_1=cell2mat(raw(k,10));
    LP1(k).trig_2_2=cell2mat(raw(k,11));
    LP1(k).trig_3_1=cell2mat(raw(k,12));
    LP1(k).trig_3_2=cell2mat(raw(k,13));
end     








