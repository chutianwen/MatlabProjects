function J=get54Jacobian(theta1,theta2,theta3,theta4,theta5,theta6,p1_x,p1_y,p1_z,p2_x,p2_y,p2_z,p3_x,p3_y,p3_z )
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
% theta1=2;
% theta2=25;
% theta3=2;
% theta4=2;
% theta5=2;
% theta6=2;
th1=theta1;
th2=theta2-pi/2;
th3=theta3;
th4=theta4;
th5=theta5;
th6=theta6+pi;
% th1=theta1;
% th2=theta2;
% th3=theta3;
% th4=theta4;
% th5=theta5;
% th6=theta6;
%% p1
J=[];
[j1 j2 j3 j4 j5 j6]=getJcolfrom1to6_x(th1,th2,th3,th4,th5,th6,p1_x,p1_y,p1_z);
J=[j1 j2 j3 j4 j5 j6];
[j1 j2 j3 j4 j5 j6]=getJcolfrom1to6_y(th1,th2,th3,th4,th5,th6,p1_x,p1_y,p1_z);
J=[J;[j1 j2 j3 j4 j5 j6]];
[j1 j2 j3 j4 j5 j6]=getJcolfrom1to6_z(th1,th2,th3,th4,th5,th6,p1_x,p1_y,p1_z);
J=[J;[j1 j2 j3 j4 j5 j6]];
%% p2
[j1 j2 j3 j4 j5 j6]=getJcolfrom1to6_x(th1,th2,th3,th4,th5,th6,p2_x,p2_y,p2_z);
J=[J;[j1 j2 j3 j4 j5 j6]];
[j1 j2 j3 j4 j5 j6]=getJcolfrom1to6_y(th1,th2,th3,th4,th5,th6,p2_x,p2_y,p2_z);
J=[J;[j1 j2 j3 j4 j5 j6]];
[j1 j2 j3 j4 j5 j6]=getJcolfrom1to6_z(th1,th2,th3,th4,th5,th6,p2_x,p2_y,p2_z);
J=[J;[j1 j2 j3 j4 j5 j6]];
%% p3
[j1 j2 j3 j4 j5 j6]=getJcolfrom1to6_x(th1,th2,th3,th4,th5,th6,p3_x,p3_y,p3_z);
J=[J;[j1 j2 j3 j4 j5 j6]];
[j1 j2 j3 j4 j5 j6]=getJcolfrom1to6_y(th1,th2,th3,th4,th5,th6,p3_x,p3_y,p3_z);
J=[J;[j1 j2 j3 j4 j5 j6]];
[j1 j2 j3 j4 j5 j6]=getJcolfrom1to6_z(th1,th2,th3,th4,th5,th6,p3_x,p3_y,p3_z);
J=[J;[j1 j2 j3 j4 j5 j6]];
end