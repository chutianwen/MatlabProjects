%% initiate parameters it can be arbitrary.
theta1_current=2*pi/180;
theta2_current=25*pi/180;
theta3_current=2*pi/180;
theta4_current=2*pi/180;
theta5_current=2*pi/180;
theta6_current=2*pi/180;
theta_current=[theta1_current;theta2_current;theta3_current;theta4_current;theta5_current;theta6_current];

centroid=([482 45  360]+[483 35 360]+[465 44 360])/3;
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
p1_xto2=-10;
p1_yto2=0;
p1_zto2=0;
p3_xto2=p3_x-p2_x;
p3_yto2=p3_y-p2_y;
p3_zto2=p3_z-p2_z;
apha=-pi/2;   % pi/2
r=[cos(apha)  0         sin(apha);
    0         1         0;
   -sin(apha)   0       cos(apha)];
p1new=r*[p1_xto2;p1_yto2;p1_zto2];
p1_x_target=p1new(1)+p2_x;
p1_y_target=p1new(2)+p2_y;
p1_z_target=p1new(3)+p2_z;
p2_x_target=p2_x;
p2_y_target=p2_y;
p2_z_target=p2_z;
p3new=r*[p3_xto2;p3_yto2;p3_zto2];
p3_x_target=p3new(1)+p2_x;
p3_y_target=p3new(2)+p2_y;
p3_z_target=p3new(3)+p2_z;
P=[p1_x;p1_y;p1_z;p2_x;p2_y;p2_z;p3_x;p3_y;p3_z];

[p1_x_target0,p1_y_target0,p1_z_target0]=getnewp(theta_current(1),theta_current(2),theta_current(3),theta_current(4),theta_current(5),theta_current(6),p1_x_target,p1_y_target,p1_z_target); 
[p2_x_target0,p2_y_target0,p2_z_target0]=getnewp(theta_current(1),theta_current(2),theta_current(3),theta_current(4),theta_current(5),theta_current(6),p2_x_target,p2_y_target,p2_z_target); 
[p3_x_target0,p3_y_target0,p3_z_target0]=getnewp(theta_current(1),theta_current(2),theta_current(3),theta_current(4),theta_current(5),theta_current(6),p3_x_target,p3_y_target,p3_z_target); 

%% 
delta_theta=100;
i=1;
deltaX_record=[];
square_record=[];
while(max(abs(delta_theta))>1e-10)
[P0(1),P0(2),P0(3)]=getnewp(theta_current(1),theta_current(2),theta_current(3),theta_current(4),theta_current(5),theta_current(6),P(1),P(2),P(3));
[P0(4),P0(5),P0(6)]=getnewp(theta_current(1),theta_current(2),theta_current(3),theta_current(4),theta_current(5),theta_current(6),P(4),P(5),P(6));
[P0(7),P0(8),P0(9)]=getnewp(theta_current(1),theta_current(2),theta_current(3),theta_current(4),theta_current(5),theta_current(6),P(7),P(8),P(9));
dif_tar=[p1_x_target0-P0(1);p1_y_target0-P0(2);p1_z_target0-P0(3);p2_x_target0-P0(4);p2_y_target0-P0(5);p2_z_target0-P0(6);p3_x_target0-P0(7);p3_y_target0-P0(8);p3_z_target0-P0(9)];
deltaX_record=[deltaX_record,dif_tar];
J=get54Jacobian(theta_current(1),theta_current(2),theta_current(3),theta_current(4),theta_current(5),theta_current(6),P(1),P(2),P(3),P(4),P(5),P(6),P(7),P(8),P(9));
square=sum(dif_tar.*dif_tar);
square_record=[square_record,square];
delta_theta=((inv(J'*J))*J')*dif_tar;     

theta1_new=theta_current+delta_theta;
theta_current=theta1_new;
% [P(1),P(2),P(3)]=getnewp(theta1_current,theta2_current,theta3_current,theta4_current,theta5_current,theta6_current,P(1),P(2),P(3));
% [P(4),P(5),P(6)]=getnewp(theta1_current,theta2_current,theta3_current,theta4_current,theta5_current,theta6_current,P(4),P(5),P(6));
% [P(7),P(8),P(9)]=getnewp(theta1_current,theta2_current,theta3_current,theta4_current,theta5_current,theta6_current,P(7),P(8),P(9));
% delta_p=J_new*delta_theta;
% P=P+delta_p;
i=i+1;
end
result_theta=theta_current*180/pi;
