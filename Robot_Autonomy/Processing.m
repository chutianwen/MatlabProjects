function [Err_p, Err_v, Err_o] = Processing(pos_des, vel_des, att_des, ang_des)

    global pos_odm_previous vel_odom_previous
    global params
    global odom_sub imu_sub
    global Kp_pos Kd_pos Kp_att Kd_att 
    global pd_msg pd_pub
    global Err_or_previous
    
    Err_or_previous = 0;
    pos_odom = [];
    vel_odom = [];
    odom_msg = odom_sub.read(3, false);
    odom_updated = false;
    tstart = tic;
    if ~isempty(odom_msg)
        pos_odom = ...
            [odom_msg.pose.pose.position.x;
             odom_msg.pose.pose.position.y;
             odom_msg.pose.pose.position.z];
        vel_odom = ...
            [odom_msg.twist.twist.linear.x;
             odom_msg.twist.twist.linear.y;
             odom_msg.twist.twist.linear.z];
        att_odom = ...
            geometry_utils.RToZYX(geometry_utils.QuatToR(odom_msg.pose.pose.orientation));
        ang_vel  = ...
            [odom_msg.twist.twist.angular.x; ...
             odom_msg.twist.twist.angular.y; ...
             odom_msg.twist.twist.angular.z];
        odom_time = toc(tstart);
        odom_updated = true;
    end

    %% Read the imu message, return empty if no message after 3 ms
    imu_msg = imu_sub.read(3, false);
    imu_updated = false;
    if ~isempty(imu_msg)
        att_imu = ...
            geometry_utils.RToZYX(geometry_utils.QuatToR(imu_msg.orientation));
        ang_imu = ...
            [imu_msg.angular_velocity.x; ...
             imu_msg.angular_velocity.y; ...
             imu_msg.angular_velocity.z];
        imu_time = toc(tstart);
        imu_updated = true;
    end
    
%%  if both updated, then use the latest pos_odm and vel_odm to calculate error, if not then use the previous one.
    if  odom_updated && imu_updated
        
        display 'Calculating new PD output signals';
        psi = att_odom(3);   % angle in Z axis
        display 'Current Pose';
        % display current pose information
        pos_odom = pos_odom 
        vel_odom = vel_odom
        
        e_pos = pos_odom - pos_des;
        e_vel = vel_odom - vel_des;
        
        u_pos = -Kp_pos*e_pos - Kd_pos*e_vel;
        

        %% Ideal attitude inputs
        u_r = (u_pos(1)*sin(psi) - u_pos(2)*cos(psi))/params.gravity;
        u_p = (u_pos(1)*cos(psi) + u_pos(2)*sin(psi))/params.gravity;
        u_y = att_des(3);

        %% Bias compensated attitude
        att = [att_imu(1:2); psi];

        %% Attiude error
        e_att = geometry_utils.shortest_angular_distance([u_r;u_p;u_y], att);
        e_ang = ang_imu - ang_des;
        e_time = toc(tstart);

        

        %% Biased attitude inputs
        phi_cmd = u_r;
        theta_cmd = u_p;
        yaw_delta = e_att(3);

        %% Onboard attitude control (for plotting)
        u_att = -Kp_att*e_att - Kd_att*e_ang;

        %% Thrust input
        uT = params.mass*(u_pos(3) + params.gravity);
        % Simulation thrust input presently differs from real system
        
        seq = randi(1000);
        sim_mode = true;
        if sim_mode
            th_cmd = uT;
        else
            th_cmd = uT/(2*params.mass*params.gravity);
        end

        %% Bias compensated inputs
        pd_msg.header.stamp = e_time;
        pd_msg.roll = phi_cmd;
        pd_msg.pitch = theta_cmd;
        pd_msg.yaw = yaw_delta;
        pd_msg.thrust = th_cmd;
        pd_msg.roll_speed = ang_des(1);
        pd_msg.pitch_speed = ang_des(2);
        pd_msg.yaw_speed = ang_des(3);
        pd_msg.kp_roll = Kp_att(1,1);
        pd_msg.kp_pitch = Kp_att(2,2);
        pd_msg.kp_yaw = Kp_att(3,3);
        pd_msg.kd_roll = Kd_att(1,1);
        pd_msg.kd_pitch = Kd_att(2,2);
        pd_msg.kd_yaw = Kd_att(3,3);
        pd_msg.gains_seq = seq;
        pd_msg.speeds_seq = seq;
        %Attempt to reference field of non-structure array.
        pd_pub.publish(pd_msg);
        
        pos_odm_previous  = pos_odom;
        vel_odom_previous = vel_odom;
        Err_or_previous   = e_att;  
        Err_p = norm(e_pos);
        Err_v = norm(e_vel);
        Err_o = norm(e_att);
    else
        Err_p = norm(pos_odm_previous-pos_des);
        Err_v = norm(vel_odom_previous-vel_des);
        Err_o = Err_or_previous;
    end
end