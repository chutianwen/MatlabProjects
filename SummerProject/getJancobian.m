%% t
t1=-pi/2;
t2=0;
t3=-pi/2;
t4=pi/2;
t5=-pi/2;
t6=0;
%% a
a1=0;
a2=270;
a3=70;
a4=0;
a5=0;
a6=0;
%% d
d1=290;
d2=0;
d3=0;
d4=302;
d5=0;
d6=72;
%% th
theta1=2;
theta2=25;
theta3=2;
theta4=2;
theta5=2;
theta6=2;
th1=theta1*pi/180;
th2=theta2*pi/180-pi/2;
th3=theta3*pi/180;
th4=theta4*pi/180;
th5=theta5*pi/180;
th6=theta6*pi/180+pi;
%% p3
p_x=80.5;p_y=-2.2;p_z=54.4;
J=[];
[j1 j2 j3 j4 j5 j6]=getJcolfrom1to6_x(th1,th2,th3,th4,th5,th6,p_x,p_y,p_z);
J=[j1 j2 j3 j4 j5 j6];
[j1 j2 j3 j4 j5 j6]=getJcolfrom1to6_y(th1,th2,th3,th4,th5,th6,p_x,p_y,p_z);
J=[J;[j1 j2 j3 j4 j5 j6]];
[j1 j2 j3 j4 j5 j6]=getJcolfrom1to6_z(th1,th2,th3,th4,th5,th6,p_x,p_y,p_z);
J=[J;[j1 j2 j3 j4 j5 j6]];