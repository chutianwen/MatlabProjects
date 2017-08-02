clc;clear all;close all;

s=mfilename('fullpath');
pth=s(1:findstr(s,'cmu_quad_matlab')-1);
addpath([pth,'cmu_quad_matlab/dry/src/geometry_utils'])
addpath([pth,'cmu_quad_matlab/dry/src/quadrotor_model'])
%% Add path to custom messages
addpath([pth,'cmu_quad_matlab/dry/install_isolated/share/ipc_bridge/matlab'])
% If custom messages reside in a wet workspace:
% addpath('~/path/to/wet/build/lib');
addpath([pth,'cmu_quad_matlab/wet/build/lib']);
% If custom messages reside in a dry workspace:
%addpath('~/path/to/dry/install_isolated/share/ipc_bridge/matlab');

%% Instantiate the model
params = quadrotor_model.quadrotor_parameters();
params.gravity = 9.81;
params.mass = 0.340;
params.inertia = diag([0.00077773; 0.00079183; 0.00112944]);
params.length = 0.1043;

%% Example fixed gains
s=mfilename('fullpath');
pth=s(1:findstr(s,'cmu_quad_matlab')-1);
addpath([pth,'cmu_quad_matlab/dry/src/geometry_utils'])
addpath([pth,'cmu_quad_matlab/dry/src/quadrotor_model'])
%% Add path to custom messages
addpath([pth,'cmu_quad_matlab/dry/install_isolated/share/ipc_bridge/matlab'])
% If custom messages reside in a wet workspace:
% addpath('~/path/to/wet/build/lib');
addpath([pth,'cmu_quad_matlab/wet/build/lib']);
% If custom messages reside in a dry workspace:
%addpath('~/path/to/dry/install_isolated/share/ipc_bridge/matlab');

%% Instantiate the model
params = quadrotor_model.quadrotor_parameters();
params.gravity = 9.81;
params.mass = 0.340;
params.inertia = diag([0.00077773; 0.00079183; 0.00112944]);
params.length = 0.1043;

%% Example fixed gains
%Kp = diag([0.8687; 0.8687; 2.5896; 0.2370; 0.2370; 0.0217]);
%Kd = diag([1.0869; 1.0869; 1.0869; 0.0272; 0.0272; 0.0099]);
                             %   kp_roll    kp_pitch     kp_yaw                       
Kp = diag([0.8687/25; 0.8687/25; 2.5896*2; 0.2370*5; 0.2370*4; 0.0217]);
Kd = diag([1.0869/5; 1.0869/15; 1.0869*8; 0.0272*4; 0.0272*6; 0.0099]);


Kp_pos = Kp(1:3,1:3);
Kd_pos = Kd(1:3,1:3);

Kp_att = Kp(4:6,4:6);
Kd_att = Kd(4:6,4:6);

%% Create the input-output connections to ROS
% Subscribers receive data from ROS via IPC
% Publishers publish data to ROS via IPC

% Call clear each time to make sure that you clean up old pub/sub objects
clear odom_sub imu_sub pd_pub;

% Create a subscriber for a nav_msgs/Odometry message called 'odom'
% The matching node instantiation in the launch file is:
% <node pkg="ipc_bridge"
%       name="matlab_odom"
%       type="nav_msgs_Odometry_publisher"
%       output="screen">
%   <remap from="~topic" to="/alpha/odom"/>
%   <param name="message" value="odom"/>
% </node>
% Note in the above, the parameter odom corresponds to the second argument
odom_sub = ipc_bridge.createSubscriber('nav_msgs', 'Odometry', 'odom');
imu_sub = ipc_bridge.createSubscriber('sensor_msgs', 'Imu', 'imu');
pd_pub = ipc_bridge.createPublisher('quadrotor_msgs', 'PDCommand', 'pd_cmd');

%% Create the structure of the outgoing message (to populate below)
pd_msg = pd_pub.empty();

%% Clear pending messages
for i = 1:10
    odom_sub.read(10, false);
    imu_sub.read(10, false);
end

samples = 1000000;

e_pos = zeros(3, samples);
e_vel = zeros(3, samples);
e_att = zeros(3, samples);
e_ang = zeros(3, samples);
e_time = zeros(1, samples);

pos_odom = zeros(3,samples);
att_odom = zeros(3,samples);
vel_odom = zeros(3,samples);
ang_odom = zeros(3,samples);

att_imu = zeros(3,samples);
ang_imu = zeros(3,samples);

odom_time = zeros(1,samples);
imu_time = zeros(1,samples);

odom_idx = 1;
imu_idx = 1;
err_idx = 1;

pos_idx = 1;  % idx waypoints

%% Reference destinations in Global Frame

X_target = linspace(0,0.5,100);
%Y_target = linspace(0,1,100);
%Z_target = linspace(0.1,1,100);    % Z direction should start with number larger than 0.6, otherwise it crashes.

num_targets = length(X_target);

pos_des = zeros(3,num_targets);
%pos_des = [X_target;Y_target;Z_target];
pos_des (1,:) = X_target;
pos_des (3,:) = 1;
%% add target to return to the ground
pos_des (:,end+1) = [0.5;0;0];

% pos_des(1,2:end) = X_target;

%% design a velocity curve, and using PD to track
load vel_curve2;
vel_r   = ppval(Vel_r, X_target);
vel_des = zeros(3,num_targets);
vel_des(1,:)= 0.2*vel_r;
vel_des(:,end+1) = [0;0;0];

%vel_des = [0; 0; 0];
att_des = [0; 0; 0];
ang_des = [0; 0; 0];

seq = randi(1000);

sim_mode = true;

time_record         = [];   % second
Stop_points_record  = [];   % cooridnate [x,y,z]
Error_orientation   = [];   % norm
Error_position      = [];   % norm
time_record_idx     = [];  
tstart = tic;
for i = 1:samples
    %% Read the odom message, return empty if no message after 3 ms
    odom_msg = odom_sub.read(3, false);
    odom_updated = false;
    if ~isempty(odom_msg)
        pos_odom(:, odom_idx) = ...
            [odom_msg.pose.pose.position.x;
             odom_msg.pose.pose.position.y;
             odom_msg.pose.pose.position.z];
        vel_odom(:, odom_idx) = ...
            [odom_msg.twist.twist.linear.x;
             odom_msg.twist.twist.linear.y;
             odom_msg.twist.twist.linear.z];
        att_odom(:, odom_idx) = ...
            geometry_utils.RToZYX(geometry_utils.QuatToR(odom_msg.pose.pose.orientation));
        ang_vel(:, odom_idx) = ...
            [odom_msg.twist.twist.angular.x; ...
             odom_msg.twist.twist.angular.y; ...
             odom_msg.twist.twist.angular.z];
        odom_time(odom_idx) = toc(tstart);
        odom_idx = odom_idx + 1;
        odom_updated = true;
    end

    %% Read the imu message, return empty if no message after 3 ms
    imu_msg = imu_sub.read(3, false);
    imu_updated = false;
    if ~isempty(imu_msg)
        att_imu(:,imu_idx) = ...
            geometry_utils.RToZYX(geometry_utils.QuatToR(imu_msg.orientation));
        ang_imu(:,imu_idx) = ...
            [imu_msg.angular_velocity.x; ...
             imu_msg.angular_velocity.y; ...
             imu_msg.angular_velocity.z];
        imu_time(imu_idx) = toc(tstart);
        imu_idx = imu_idx + 1;
        imu_updated = true;
    end
    
%       imu_updated
    if odom_idx > 1 && imu_idx> 1 && odom_updated && imu_updated
        
        display 'in controlling loop';
        psi = att_odom(3,odom_idx-1);   % angle in Z axis
        display 'Current location';
       % pos_des(:,pos_idx)
        pos_idx = pos_idx
        pos_odom(:,odom_idx-1)
        e_pos(:,err_idx) = pos_odom(:,odom_idx-1) - pos_des(:,pos_idx);
     
        e_vel(:,err_idx) = vel_odom(:,odom_idx-1) - vel_des(:,pos_idx);
        
        u_pos(:,err_idx) = -Kp_pos*e_pos(:,err_idx) - Kd_pos*e_vel(:,err_idx);
        
        Error_position = [Error_position, e_pos(:,err_idx)];

        %% Ideal attitude inputs
        u_r = (u_pos(1,err_idx)*sin(psi) - u_pos(2,err_idx)*cos(psi))/params.gravity;
        u_p = (u_pos(1,err_idx)*cos(psi) + u_pos(2,err_idx)*sin(psi))/params.gravity;
        u_y = att_des(3);

        %% Bias compensated attitude
        att = [att_imu(1:2,imu_idx-1); psi];

        %% Attiude error
        e_att(:, err_idx) = ...
            geometry_utils.shortest_angular_distance([u_r;u_p;u_y], att);
        e_ang(:, err_idx) = ang_imu(:,imu_idx-1) - ang_des;
        e_time(err_idx) = toc(tstart);

        Error_orientation = [Error_orientation, e_att(2, err_idx)];

        %% Biased attitude inputs
        phi_cmd = u_r;
        theta_cmd = u_p;
        yaw_delta = e_att(3,err_idx);

        %% Onboard attitude control (for plotting)
        u_att(:,err_idx) = -Kp_att*e_att(:,err_idx) - Kd_att*e_ang(:,err_idx);

        %% Thrust input
        uT(err_idx) = params.mass*(u_pos(3,err_idx) + params.gravity);
        % Simulation thrust input presently differs from real system
        if sim_mode
            th_cmd = uT(err_idx);
        else
            th_cmd = uT(err_idx)/(2*params.mass*params.gravity);
        end

        %% Bias compensated inputs
        pd_msg.header.stamp = e_time(err_idx);
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
        pd_pub.publish(pd_msg);

        %%  if reach the current target, then update to the next one
        %   if reach the last waypoint(destination), then check if the velocity is also 0, then break the for-loop
        if (pos_idx < length( pos_des(1,:) ) )
            if ( norm(e_pos(:,err_idx)) <5*1e-3 )  % maybe add velocity constraint
        
                Stop_points_record = [Stop_points_record, pos_odom(:,odom_idx-1) ];
                time_record = [time_record , toc(tstart)];
                time_record_idx = [time_record_idx,err_idx];
                pos_idx = pos_idx+1;
            end

        else if (pos_idx == length( pos_des(1,:) ) )        
            if ( norm(e_pos(:,err_idx)) < 1e-4 && norm(e_vel(:,err_idx)) < 1e-4 )  

                Stop_points_record = [Stop_points_record, pos_odom(:,odom_idx-1) ];
                time_record = [time_record , toc(tstart)];
                time_record_idx = [time_record_idx,err_idx];        

                break;
            end
            end
        end

        err_idx = err_idx + 1;
    end
end
%% draw 
figure(1)
plot(time_record,'+','linewidth',2);
xlabel('ith of waypoints');
ylabel('time(s)')

figure(2)
plot(e_time(1:err_idx-1),Error_orientation,'linewidth',2);
xlabel('time(s)');
ylabel('Orientation error')
hold on;
plot(e_time(time_record_idx),Error_orientation(time_record_idx) ,'+');
title('Error of Position')

figure(3)
plot(e_time(1:err_idx-1),Error_position,'linewidth',2);
xlabel('time(s)');
ylabel('Position error(m)')
hold on;
plot(e_time(time_record_idx),Error_position(time_record_idx) ,'+');
title('Error of Orientation')

Stop_points_record(:,end) = [1,0,0];
plot3(Stop_points_record)
%% Send out zero command



% pd_msg.header.stamp = e_time(err_idx);
% pd_msg.roll = 0;
% pd_msg.pitch = 0;
% pd_msg.yaw = 0;
% pd_msg.thrust = 0.0;
% pd_msg.roll_speed = 0;
% pd_msg.pitch_speed = 0;
% pd_msg.yaw_speed = 0;
% pd_msg.kp_roll = Kp_att(1,1);
% pd_msg.kp_pitch = Kp_att(2,2);
% pd_msg.kp_yaw = Kp_att(3,3);
% pd_msg.kd_roll = Kd_att(1,1);
% pd_msg.kd_pitch = Kd_att(2,2);
% pd_msg.kd_yaw = Kd_att(3,3);
% pd_msg.gains_seq = seq;
% pd_msg.speeds_seq = seq;
% pd_pub.publish(pd_msg);

pd_msg.header.stamp = e_time(err_idx-1);
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
pd_pub.publish(pd_msg);
        
%% Disconnect the bridge objects (good practice)
clear odom_sub imu_sub pwm_pub pd_pub;
% The above is the same as calling the following
% odom_sub.disconnect();
% imu_sub.disconnect();
% pwm_pub.disconnect();