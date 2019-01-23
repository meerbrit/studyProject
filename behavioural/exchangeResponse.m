function [response] = exchangeResponse(response)
%EXCHANGERESPONSE convert button to numeral
% 1=clearly wrong 2=probably wrong 3= dont know 4= probably right 5=clearly right
% X=1 C=2 V=3 B=4 N=5
    response = upper(response);
    if response == 'X'
        response=1;
    elseif response == 'C'
        response=2;
    elseif response == 'V'
        response=3;
    elseif response == 'B'
        response=4;
    elseif response == 'N'
        response=5;
    end
end

