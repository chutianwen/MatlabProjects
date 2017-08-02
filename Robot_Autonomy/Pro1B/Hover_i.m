function flag_track = Hover_i(flag_hover)

global interrupt_hover_i 

if flag_hover == 0 
    display 'no command then stay takeoff'
    flag_track = 0;
else
    %% here using interrupt_hover_i as a starter
   display 'input the signal to start hover Yes:1 No:0' 
   % waiting for input a number in command line
   %interrupt_hover_i = input(prompt);
   if (interrupt_hover_i == 1)
        flag_track = 1; % go on to track
   else
        flag_track = 0; % 
   end
   
end

end