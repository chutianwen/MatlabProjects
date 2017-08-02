function flag_land = Hover_f(flag_hover_f)

global interrupt_hover_i 

if flag_hover_f == 0 
    display 'no command then stay track'
    flag_land = 0;
else
    display 'final hovering'
    if (interrupt_hover_f == 1)    
        flag_land = 1;
    else
        flag_land = 0;
end
end