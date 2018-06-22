function [] = showInstructions(win, instructions)
    DrawFormattedText(win, instructions ,'center','center', 0); % uses the defined 'win' above and draws instructions on it
    Screen(win,'flip'); % Flush the buffer, needed to display previously made changes to 'win'
    KbWait; % waiting for keyboard press
    KbReleaseWait; % KbWait could interfere with the key pressing of the response

    clear instructions  %not needed anymore, just to make room
