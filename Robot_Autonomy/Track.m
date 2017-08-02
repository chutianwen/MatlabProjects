function flag_hover_f = Track(flag_track)

global Err_pose Err_vel Err_ori
global odom_sub imu_sub

if flag_track == 0 
    display 'no command then stay hover'
    flag_hover_f = 0;
else
    display 'tracking'
    
    %%
    % fill the target here
    
    %%
    flag_hover_f = 1;
end
    
end