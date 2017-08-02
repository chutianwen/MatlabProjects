%% initiate parameters arbitrary
theta1_current=2*pi/180;
theta2_current=2*pi/180;
theta3_current=2*pi/180;
theta4_current=2*pi/180;
theta5_current=2*pi/180;
theta6_current=2*pi/180;

p1_x=80.5;
p1_y=-2.2;
p1_z=64.4;

p2_x=90.5;
p2_y=-2.2;
p2_z=64.4;

p3_x=80.5;
p3_y=-2.2;
p3_z=54.4;

%% calculate target point refer to sixth frame
theta1_target=2.5*pi/180;
theta2_target=2.5*pi/180;
theta3_target=2.5*pi/180;
theta4_target=2*pi/180;
theta5_target=2*pi/180;
theta6_target=2*pi/180;

[p1_x_target0,p1_y_target0,p1_z_target0]=getnewp(theta1_target,theta2_target,theta3_target,theta4_target,theta5_target,theta6_target,p1_x,p1_y,p1_z); 
[p2_x_target0,p2_y_target0,p2_z_target0]=getnewp(theta1_target,theta2_target,theta3_target,theta4_target,theta5_target,theta6_target,p2_x,p2_y,p2_z); 
[p3_x_target0,p3_y_target0,p3_z_target0]=getnewp(theta1_target,theta2_target,theta3_target,theta4_target,theta5_target,theta6_target,p3_x,p3_y,p3_z); 

P=[p1_x;p1_y;p1_z;p2_x;p2_y;p2_z;p3_x;p3_y;p3_z];

%% 
delta_theta=100;
i=1;
while(max(delta_theta)>1e-10)
    
[P0(1),P0(2),P0(3)]=getnewp(theta1_current,theta2_current,theta3_current,theta4_current,theta5_current,theta6_current,P(1),P(2),P(3));
[P0(4),P0(5),P0(6)]=getnewp(theta1_current,theta2_current,theta3_current,theta4_current,theta5_current,theta6_current,P(4),P(5),P(6));
[P0(7),P0(8),P0(9)]=getnewp(theta1_current,theta2_current,theta3_current,theta4_current,theta5_current,theta6_current,P(7),P(8),P(9));

dif_tar=[p1_x_target0-P0(1);p1_y_target0-P0(2);p1_z_target0-P0(3);p2_x_target0-P0(4);p2_y_target0-P0(5);p2_z_target0-P0(6);p3_x_target0-P0(7);p3_y_target0-P0(8);p3_z_target0-P0(9)];
J=get54Jacobian(theta1_current,theta2_current,theta3_current,theta4_current,theta5_current,theta6_current,P(1),P(2),P(3),P(4),P(5),P(6),P(7),P(8),P(9));
square=sum(dif_tar.*dif_tar);
delta_theta=(inv(J'*J)*J')*dif_tar;     
theta1_new=theta1_current+delta_theta(1);
theta2_new=theta2_current+delta_theta(2);
theta3_new=theta3_current+delta_theta(3);
theta4_new=theta4_current+delta_theta(4);
theta5_new=theta5_current+delta_theta(5);
theta6_new=theta6_current+delta_theta(6);

theta1_current=theta1_new;
theta2_current=theta2_new;
theta3_current=theta3_new;
theta4_current=theta4_new;
theta5_current=theta5_new;
theta6_current=theta6_new;
[P(1),P(2),P(3)]=getnewp(theta1_current,theta2_current,theta3_current,theta4_current,theta5_current,theta6_current,P(1),P(2),P(3));
[P(4),P(5),P(6)]=getnewp(theta1_current,theta2_current,theta3_current,theta4_current,theta5_current,theta6_current,P(4),P(5),P(6));
[P(7),P(8),P(9)]=getnewp(theta1_current,theta2_current,theta3_current,theta4_current,theta5_current,theta6_current,P(7),P(8),P(9));
% delta_p=J_new*delta_theta;
% P=P+delta_p;
i=i+1;
end
