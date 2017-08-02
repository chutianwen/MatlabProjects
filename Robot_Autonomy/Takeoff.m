function  flag_hover_i = Takeoff(flag_takeoff )
global Err_pose Err_vel Err_ori
global odom_sub imu_sub

if flag_takeoff == 0 
    display 'no command then no action'
    flag_hover_i = 0;
else
    display 'taking off'
    pos_des = [0 ; 0 ; 0.5];
    vel_des = zeros(3,1);
    att_des = zeros(3,1);
    ang_des = zeros(3,1);

    Toleration_pos = 1e-3;
    Toleration_vel = 1e-3;
   
    Err_p = 999;
    Err_v = 999;
    while (norm(Err_p) > Toleration_pos || norm(Err_v) > Toleration_vel)
        [Err_p, Err_v, Err_o] = Processing(pos_des, vel_des, att_des, ang_des);
        Err_pose = [Err_pose, Err_p];
        Err_vel  = [Err_vel , Err_v];
        Err_ori  = [Err_ori , Err_o];
    end
    
    flag_hover_i = 1;
end





end