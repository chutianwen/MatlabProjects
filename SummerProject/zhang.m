%% initiate parameters
theta1_current=2*pi/180;
theta2_current=25*pi/180;
theta3_current=2*pi/180;
theta4_current=2*pi/180;
theta5_current=2*pi/180;
theta6_current=2*pi/180;
theta_current=[2*pi/180;25*pi/180;2*pi/180;2*pi/180;2*pi/180;2*pi/180;];

p1_x=80.5;
p1_y=-2.2;
p1_z=64.4;

p2_x=90.5;
p2_y=-2.2;
p2_z=64.4;

p3_x=80.5;
p3_y=-2.2;  
p3_z=54.4;


P=[p1_x;p1_y;p1_z;p2_x;p2_y;p2_z;p3_x;p3_y;p3_z];
%80.5000000000000;7.57692263932839;66.5004246486337;1
p3_x_t=80.5;
p3_y_t=7.6;
p3_z_t=66.5;
% [p1_x_target0,p1_y_target0,p1_z_target0]=getnewp(theta1_current,theta2_current,theta3_current,theta4_current,theta5_current,theta6_current,p1_x_target,p1_y_target,p1_z_target); 
% [p2_x_target0,p2_y_target0,p2_z_target0]=getnewp(theta1_current,theta2_current,theta3_current,theta4_current,theta5_current,theta6_current,p2_x_target,p2_y_target,p2_z_target); 
% [p3_x_target0,p3_y_target0,p3_z_target0]=getnewp(theta1_current,theta2_current,theta3_current,theta4_current,theta5_current,theta6_current,p3_x_target,p3_y_target,p3_z_target); 
[p1_x_target0,p1_y_target0,p1_z_target0]=getnewp(theta_current(1),theta_current(2),theta_current(3),theta_current(4),theta_current(5),theta_current(6),80.5,-2.2,64.4); 
[p2_x_target0,p2_y_target0,p2_z_target0]=getnewp(theta_current(1),theta_current(2),theta_current(3),theta_current(4),theta_current(5),theta_current(6),90.5,-2.2,64.4); 
[p3_x_target0,p3_y_target0,p3_z_target0]=getnewp(theta_current(1),theta_current(2),theta_current(3),theta_current(4),theta_current(5),theta_current(6),80.5,7.6,66.5); 
%% 
delta_theta=100;
i=1;
deltaX_record=[];
% while(max(abs(delta_theta))>1e-10)
while(max(abs(delta_theta))>1e-10)
% from sixth frame to base frame
[P0(1),P0(2),P0(3)]=getnewp(theta_current(1),theta_current(2),theta_current(3),theta_current(4),theta_current(5),theta_current(6),80.5,-2.2,64.4);
[P0(4),P0(5),P0(6)]=getnewp(theta_current(1),theta_current(2),theta_current(3),theta_current(4),theta_current(5),theta_current(6),90.5,-2.2,64.4);
[P0(7),P0(8),P0(9)]=getnewp(theta_current(1),theta_current(2),theta_current(3),theta_current(4),theta_current(5),theta_current(6),80.5,-2.2,54.4);
dif_tar=[4.948341706444593e+02-P0(1);20.867350324694506-P0(2);3.234745047257963e+02-P0(3);4.899759287162967e+02-P0(4);21.395474113931630-P0(5);3.147499089970141e+02-P0(6);4.948132696234291e+02-P0(7);30.848348966447055-P0(8);3.240903206566180e+02-P0(9)];
deltaX_record=[deltaX_record,dif_tar];
J=get54Jacobian(theta_current(1),theta_current(2),theta_current(3),theta_current(4),theta_current(5),theta_current(6),P(1),P(2),P(3),P(4),P(5),P(6),P(7),P(8),P(9));
square=sum(dif_tar.*dif_tar);
delta_theta=(inv(J'*J)*J')*dif_tar;   

theta1_new=theta_current+delta_theta;
theta_current=theta1_new;

i=i+1;
end
