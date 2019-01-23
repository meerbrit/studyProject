%%Reads in all log files and calculates
% 1=clearly wrong 2=probably wrong 3= dont know 4= probably right 5=
% clearly right
%X=1 C=2 V=3 B=4 N=5
clear all;
close all;

coded_sourcePath = 'E:\SPAGL\xls\correct\';
logs_sourcePath = 'E:\SPAGL\MATLAB';
%% Load coded testphases for correct grammars
[~,~,rawG1A]=xlsread(strcat(coded_sourcePath,'G1_TP_A.xlsx')); %Grammar 1a
[~,~,rawG1B]=xlsread(strcat(coded_sourcePath,'G1_TP_B.xlsx')); %Grammar 1b
[~,~,rawG2A]=xlsread(strcat(coded_sourcePath,'G2_TP_A.xlsx')); %Grammar 2a
[~,~,rawG2B]=xlsread(strcat(coded_sourcePath,'G2_TP_B.xlsx')); %Grammar 2b
list_len= size(rawG1A)-1; %-1 as last row is useless
%create lists for each condition (A&B)
G1_A = rawG1A(1:list_len,14);
G1_B = rawG1B(1:list_len,14);
G2_A = rawG2A(1:list_len,14);
G2_B = rawG2B(1:list_len,14);
clear list_len;
clear rawG1A;
clear rawG2A;
clear rawG1B;
clear rawG2B;

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
    
    correct_resp = [4 5];
    incorrect_resp = [1 2];
    
    %% Create a table for simple output responses
    % new table: SUBJECTID TRIAL ANSWER RESPONSE RT
    order= i*num_responses - (num_responses-1);
    idx=1;
    for k=order:num_responses+order-1
        Overview(k).ID = Results(i).SubjectID;
        Overview(k).Trial =idx;
        Overview(k).Answer =answers(idx);
        resp = exchangeResponse(TP1(idx).response);
        Overview(k).Response =resp;
        Overview(k).RT =TP1(idx).RT;
        idx=idx+1;
    end
    
    %% calculate hit & miss
    %setup the counter for responses
    hit = 0;
    miss = 0;
    falseAlarm = 0;
    correctReject = 0;
    dunno=0;
    responseTime = 0;
    
    %check every response
    for j=1:num_responses
        response=exchangeResponse(TP1(j).response);
        if answers(j) == "correct"
            if ismember(response,correct_resp(1,:))
                hit = hit+1;
            elseif ismember(response,incorrect_resp(1,:))
                miss = miss+1;
            else
                dunno = dunno+1;
            end
        elseif answers(j) == "incorrect"
            if ismember(response,correct_resp(1,:))
                falseAlarm = falseAlarm+1;
            elseif ismember(response,incorrect_resp(1,:))
                correctReject = correctReject+1;
            else
                dunno = dunno+1;
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
    Results(i).DontKnow = dunno;
    Results(i).Accuracy = (hit+correctReject)/num_responses;
end
clear i;
clear dir_info;
clear hit;
clear miss;
clear falseAlarm;
clear correctReject;
clear dunno;
clear num_responses;
clear responseTime;

%% add general results
Results(num_data+1).SubjectID = 'Overall';
Results(num_data+1).ReactionTimeMean = sum([Results(1:num_data).ReactionTimeMean]/num_data);
Results(num_data+1).Hits = sum([Results(1:num_data).Hits]);
Results(num_data+1).Miss = sum([Results(1:num_data).Miss]);
Results(num_data+1).FalseAlarm = sum([Results(1:num_data).FalseAlarm]);
Results(num_data+1).CorrectReject = sum([Results(1:num_data).CorrectReject]);
Results(num_data+1).DontKnow = sum([Results(1:num_data).DontKnow]);
Results(num_data+1).Accuracy = sum([Results(1:num_data).Accuracy])/num_data;
final = struct2table(Results);
mkdir('results');
writetable(final,'results\testPhase.csv');
overview=struct2table(Overview);
writetable(overview,'results\overviewTP.csv');

clear G1_A;
clear G1_B;
clear G2_A;
clear G2_B;
clear num_data;
clear final;
clear TP1;
clear overview;
clear Overview;
clear coded_sourcePath;
clear logs_sourcePath;