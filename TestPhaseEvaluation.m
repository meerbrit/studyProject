%%Reads in all log files and calculates 
%%Hit, Miss, False Alarm and Correct Rejects
clear all;
close all;

coded_sourcePath = 'xls\answers\';
logs_sourcePath = 'log\Pretests';
%% Load coded testphases for correct grammars
[~,~,rawG1]=xlsread(strcat(coded_sourcePath,'G1.xlsx')); %Grammar 1
[~,~,rawG2]=xlsread(strcat(coded_sourcePath,'G2.xlsx')); %Grammar 2
list_len= size(rawG1);
%create lists for each condition (A&B)
G1_A = rawG1(1:list_len,1);
G1_B = rawG1(1:list_len,2);
G2_A = rawG2(1:list_len,1);
G2_B = rawG2(1:list_len,2);
clear list_len;
clear rawG1;
clear rawG2;

%% get the infor about # of subjects and folders
dir_info = dir(logs_sourcePath);
%cut the first two columns from dir_info as they do not matter
dir_info(1:2,:) = [];
num_data = length(dir_info);%number of subject data logged
num_responses = length(G1_A);
Results = struct;

%% Load all logged answers from TP1
for i=1:num_data
    %load TP1 file
    file_name = dir_info(i).name;
    load(strcat(logs_sourcePath,'\',file_name,'\','TP1.mat'));
    tokens = strsplit(file_name,'_'); %split the name, separated by'_';
    Results(i).SubjectID = tokens(2);
    Results(i).CorrectGrammar = char(tokens(3)); %save as char in order to split
    Results(i).IncorrectGrammar = tokens(4);
    Results(i).Button=tokens(5);
    Results(i).ReactionTimeMean = 0;
    clear tokens;
    clear file_name;
    
    %get which grammar and condition was tested
    tested_grammar =  Results(i).CorrectGrammar(1);
    tested_condition =  Results(i).CorrectGrammar(2);
    %select the right coded answers
    if tested_grammar == "1"
        if tested_condition == "A"
            answers = G1_A;
        elseif tested_condition == "B"
            answers = G1_B;
        end
    elseif tested_grammar == "2"
        if tested_condition == "A"
            answers = G2_A;
        elseif tested_condition == "B"
            answers = G2_B;
        end
    end   
    %setup the counter for responses
    hit = 0;
    miss = 0;
    falseAlarm = 0;
    correctReject = 0;
    responseTime = 0;
    %choose which answer would be correct
    if Results(i).Button == "L"
        correct_resp = 'a';
    elseif Results(i).Button == "R"
        correct_resp = 'b'; 
    end
    %check every response
    for j=1:num_responses
        if answers(j) == "grammatical"
            if correct_resp == TP1(j).response
                hit = hit+1;
            else
                miss = miss+1;
            end
        elseif answers(j) == "ungrammatical"
             if correct_resp == TP1(j).response
                falseAlarm = falseAlarm+1;
            else
                correctReject = correctReject+1;
            end
        end  
        responseTime = responseTime+ TP1(j).RT;
    end
    clear j;
    clear answers;
    clear correct_resp;
    clear tested_condition;
    clear tested_grammar;
    clear TP1;
    
    %save results
    Results(i).ReactionTimeMean = responseTime/num_responses;
    Results(i).Hits = hit;
    Results(i).Miss = miss;
    Results(i).FalseAlarm = falseAlarm;
    Results(i).CorrectReject = correctReject;
    Results(i).Accuracy = (hit+correctReject)/num_responses;
end
clear i;
clear dir_info;
clear hit;
clear miss;
clear falseAlarm;
clear correctReject;
clear num_responses;
clear responseTime;

%% add general results
Results(num_data+1).SubjectID = 'Overall';
Results(num_data+1).ReactionTimeMean = sum([Results(1:num_data).ReactionTimeMean]/num_data);
Results(num_data+1).Hits = sum([Results(1:num_data).Hits]);
Results(num_data+1).Miss = sum([Results(1:num_data).Miss]);
Results(num_data+1).FalseAlarm = sum([Results(1:num_data).FalseAlarm]);
Results(num_data+1).CorrectReject = sum([Results(1:num_data).CorrectReject]);
Results(num_data+1).Accuracy = sum([Results(1:num_data).Accuracy])/num_data;

clear G1_A;
clear G1_B;
clear G2_A;
clear G2_B;
clear num_data;