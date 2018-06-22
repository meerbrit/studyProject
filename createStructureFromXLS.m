% Import the list from Excel file & save it into structure
function [PhaseStructure] = createStructureFromXLS(filename, basic, numTrials)
    if basic
       [~,~,raw]=xlsread(filename, 1, '', 'basic');  
    else
        [~,~,raw]=xlsread(filename, 1, '', ''); 
    end
    %In a for loop, you create denominations for each column from the original
    %Excel file and read it into a structure line by line
    for k=1:numTrials
        PhaseStructure(k).stimulus_number=cell2mat(raw(k,1));%first columns = stimulus number
        PhaseStructure(k).syll_1_1=char(raw(k,2)); %char specifies text input, 2 reads the second column
        PhaseStructure(k).syll_1_2=char(raw(k,3)); 
        PhaseStructure(k).syll_2_1=char(raw(k,4));
        PhaseStructure(k).syll_2_2=char(raw(k,5));
        PhaseStructure(k).syll_3_1=char(raw(k,6));
        PhaseStructure(k).syll_3_2=char(raw(k,7));% all syllables defined
        PhaseStructure(k).trig_1_1=cell2mat(raw(k,8)); %define trigger
        PhaseStructure(k).trig_1_2=cell2mat(raw(k,9));
        PhaseStructure(k).trig_2_1=cell2mat(raw(k,10));
        PhaseStructure(k).trig_2_2=cell2mat(raw(k,11));
        PhaseStructure(k).trig_3_1=cell2mat(raw(k,12));
        PhaseStructure(k).trig_3_2=cell2mat(raw(k,13));
    end
    clear raw;
    
