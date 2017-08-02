%%  parameters
syms pi;
t1=-pi/2;
t2=0;
t3=-pi/2;
t4=pi/2;
t5=-pi/2;
t6=0;
a1=0;
a2=270;
a3=70;
a4=0;
a5=0;
a6=0;
d1=290;
d2=0;
d3=0;
d4=302;
d5=0;
d6=72;


%% define theta[]
syms theta1 theta2 theta3 theta4 theta5 theta6;
theta1=2*pi/180;
theta2=25*pi/180;
theta3=2*pi/180;
theta4=2*pi/180;
theta5=2*pi/180;
theta6=2*pi/180;
T_1to0=[cos(theta1) -sin(theta1)*cos(t1) sin(theta1)*sin(t1) a1*cos(theta1);
        sin(theta1) cos(theta1)*cos(t1)  -cos(theta1)*sin(t1) a1*sin(theta1);
        0           sin(t1)             cos(t1)                 d1;
        0               0                   0                       1     ];
 T_2to1=[cos(theta2) -sin(theta2)*cos(t2) sin(theta2)*sin(t2) a2*cos(theta2);
        sin(theta2) cos(theta2)*cos(t2)  -cos(theta2)*sin(t2) a2*sin(theta2);
        0           sin(t2)             cos(t2)                 d2;
        0               0                   0                       1     ];
 T_3to2=[cos(theta3) -sin(theta3)*cos(t3) sin(theta3)*sin(t3) a3*cos(theta3);
        sin(theta3) cos(theta3)*cos(t3)  -cos(theta3)*sin(t3) a3*sin(theta3);
        0           sin(t3)             cos(t3)                 d3;
        0               0                   0                       1     ];
 T_4to3=[cos(theta4) -sin(theta4)*cos(t4) sin(theta4)*sin(t4) a4*cos(theta4);
        sin(theta4) cos(theta4)*cos(t4)  -cos(theta4)*sin(t4) a4*sin(theta4);
        0           sin(t4)             cos(t4)                 d4;
        0               0                   0                       1     ];
 T_5to4=[cos(theta5) -sin(theta5)*cos(t5) sin(theta5)*sin(t5) a5*cos(theta5);
        sin(theta5) cos(theta5)*cos(t5)  -cos(theta5)*sin(t5) a5*sin(theta5);
        0           sin(t5)             cos(t5)                 d5;
        0               0                   0                       1     ];
 T_6to5=[cos(theta6) -sin(theta6)*cos(t6) sin(theta6)*sin(t6) a6*cos(theta6);
        sin(theta6) cos(theta6)*cos(t6)  -cos(theta6)*sin(t6) a6*sin(theta6);
        0           sin(t6)             cos(t6)                 d6;
        0               0                   0                       1     ];
 
%% get the Jacobian matrix 54
J1=[-20.8674  494.834  0 
    -21.3955  489.976  0 
    -20.55  486.094  0 ]';
J1=reshape(J1,9,1);
J2=[33.4541  1.16828  -495.261 
    24.7348  0.863794  -490.424 
    38.299  1.33747  -486.515 ]';
J2=reshape(J2,9,1); 
J3=[-211.1  -7.37174  -381.154 
    -219.819  -7.67623  -376.317 
    -206.255  -7.20256  -372.408]'; 
J3=reshape(J3,9,1); 
J4=[-1.34561  85.1707  3.19442 
    -1.37714  95.1452  3.81576 
    -1.33896  84.8219  3.18356 ]';
J4=reshape(J4,9,1); 
J5=[-136.602  -0.10808  -80.185 
    -145.337  -0.425301  -75.3401 
    -131.747  -0.287551  -71.4443 ]';
J5=reshape(J5,9,1); 
J6=[-1.23708  80.4632  3.03791 
    -1.25798  90.4442  3.65372 
    -1.23708  80.4632  3.03791 ]';
J6=reshape(J6,9,1);
JJ=[J1,J2,J3,J4,J5,J6];
