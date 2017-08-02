clc;clear all;close all;



%%
s=mfilename('fullpath');
pth=s(1:findstr(s,'cmu_quad_matlab')-1);
addpath([pth,'cmu_quad_matlab/dry/src/geometry_utils'])
addpath([pth,'cmu_quad_matlab/dry/src/quadrotor_model'])
%addpath([pth,'cmu_quad_matlab/wet/src/matlab_quadrotor_example/matlab'])
addpath([pth,'cmu_quad_matlab/dry/install_isolated/share/ipc_bridge/matlab'])
% If custom messages reside in a wet workspace:
% addpath('~/path/to/wet/build/lib');
addpath([pth,'cmu_quad_matlab/wet/build/lib']);
% If custom messages reside in a dry workspace:
%addpath('~/path/to/dry/install_isolated/share/ipc_bridge/matlab');
clear odom_sub imu_sub pd_pub;

%%  Global variables
global Kp_pos Kd_pos Kp_att Kd_att params
global odom_sub imu_sub pd_pub        
global pos_odm_previous vel_odom_previous
global interrupt_hover_i interrupt_hover_f
global pd_msg 
global Err_or_previous
global Err_pose Err_vel Err_ori

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



%%
Err_pose = [];
Err_vel  = [];
Err_ori  = [];
%%   kp_roll    kp_pitch     kp_yaw                       

Kp = diag([0.8687/25; 0.8687/25; 2.5896*2; 0.2370*5; 0.2370*4; 0.0217]);
Kd = diag([1.0869/5; 1.0869/15; 1.0869*8; 0.0272*4; 0.0272*6; 0.0099]);

Kp_pos = Kp(1:3,1:3);
Kd_pos = Kd(1:3,1:3);

Kp_att = Kp(4:6,4:6);
Kd_att = Kd(4:6,4:6);

%%  Define subscriber object variables
% Call clear each time to make sure that you clean up old pub/sub objects

odom_sub = ipc_bridge.createSubscriber('nav_msgs', 'Odometry', 'odom');
imu_sub = ipc_bridge.createSubscriber('sensor_msgs', 'Imu', 'imu');
pd_pub = ipc_bridge.createPublisher('quadrotor_msgs', 'PDCommand', 'pd_cmd');
pd_msg = pd_pub.empty();
%%  clear pending message
for i = 1:10
    odom_sub.read(10, false);
    imu_sub.read(10, false);
end

%% Set flags as signals of transition
% This should be inputted by human
flag_takeoff = 1;   

% These flags are for state processing.
flag_hover_i = 0;
flag_track   = 0;
flag_hover_f = 0;
flag_land    = 0;
flag_break   = 0;

%% These interupts are for debugging hover state transition, these should be get by the subscribers later
interrupt_hover_i = 0;
interrupt_hover_i = 1;

%% main part

flag_hover_i = Takeoff(flag_takeoff)
flag_track   = Hover_i(flag_hover_i);
% flag_hover_f = Track(flag_track);
% flag_land    = Hover_f(flag_hover_f);

display "done"
