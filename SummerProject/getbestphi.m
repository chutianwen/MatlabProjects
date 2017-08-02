function phi=getbestphi(theta1_current,theta2_current,theta3_current,theta4_current,theta5_current,theta6_current)
% syms pi;
%% initiate parameters it can be arbitrary.

theta_current=[theta1_current;theta2_current;theta3_current;theta4_current;theta5_current;theta6_current];
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
%apha=-pi/2;   % pi/2    0.744076439770421
syms apha;
r=[1       0        0;
   0    cos(apha)  sin(apha);
   0    -sin(apha)  cos(apha)];
p1new=r*[p1_xto2;p1_yto2;p1_zto2];
p1_x_target=p1_x;
p1_y_target=p1_y;
p1_z_target=p1_z;
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

a=[p2_x_target0-p1_x_target0;p2_y_target0-p1_y_target0;p2_z_target0-p1_z_target0];
b=[p3_x_target0-p1_x_target0;p3_y_target0-p1_y_target0;p3_z_target0-p1_z_target0];
cross_ab=cross(b,a);
e=[-1/sqrt(3);1/sqrt(3);-1/sqrt(3)];
% e=[0;1;0];
dot_abe=dot(cross_ab,e);
y= matlabFunction(dot_abe);
phi=fminbnd(y,-2,2);
end