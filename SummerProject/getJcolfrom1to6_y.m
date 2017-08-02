function [j1 j2 j3 j4 j5 j6]=getJcolfrom1to6_y(theta1,theta2,theta3,theta4,theta5,theta6,p_x,p_y,p_z)
    j1=270*cos(theta1)*cos(theta2) - p_z*(sin(theta5)*(sin(theta1)*sin(theta4) - cos(theta4)*(cos(theta1)*sin(theta2)*sin(theta3) - cos(theta1)*cos(theta2)*cos(theta3))) + cos(theta5)*(cos(theta1)*cos(theta2)*sin(theta3) + cos(theta1)*cos(theta3)*sin(theta2))) - 72*sin(theta5)*(sin(theta1)*sin(theta4) - cos(theta4)*(cos(theta1)*sin(theta2)*sin(theta3) - cos(theta1)*cos(theta2)*cos(theta3))) - 72*cos(theta5)*(cos(theta1)*cos(theta2)*sin(theta3) + cos(theta1)*cos(theta3)*sin(theta2)) + p_x*(sin(theta6)*(cos(theta4)*sin(theta1) + sin(theta4)*(cos(theta1)*sin(theta2)*sin(theta3) - cos(theta1)*cos(theta2)*cos(theta3))) + cos(theta6)*(cos(theta5)*(sin(theta1)*sin(theta4) - cos(theta4)*(cos(theta1)*sin(theta2)*sin(theta3) - cos(theta1)*cos(theta2)*cos(theta3))) - sin(theta5)*(cos(theta1)*cos(theta2)*sin(theta3) + cos(theta1)*cos(theta3)*sin(theta2)))) + p_y*(cos(theta6)*(cos(theta4)*sin(theta1) + sin(theta4)*(cos(theta1)*sin(theta2)*sin(theta3) - cos(theta1)*cos(theta2)*cos(theta3))) - sin(theta6)*(cos(theta5)*(sin(theta1)*sin(theta4) - cos(theta4)*(cos(theta1)*sin(theta2)*sin(theta3) - cos(theta1)*cos(theta2)*cos(theta3))) - sin(theta5)*(cos(theta1)*cos(theta2)*sin(theta3) + cos(theta1)*cos(theta3)*sin(theta2)))) - 70*cos(theta1)*sin(theta2)*sin(theta3) + 70*cos(theta1)*cos(theta2)*cos(theta3) - 302*cos(theta1)*cos(theta2)*sin(theta3) - 302*cos(theta1)*cos(theta3)*sin(theta2);
    j2=p_z*(cos(theta5)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1)) + cos(theta4)*sin(theta5)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2))) - 270*sin(theta1)*sin(theta2) + p_x*(cos(theta6)*(sin(theta5)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1)) - cos(theta4)*cos(theta5)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2))) + sin(theta4)*sin(theta6)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2))) - p_y*(sin(theta6)*(sin(theta5)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1)) - cos(theta4)*cos(theta5)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2))) - cos(theta6)*sin(theta4)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2))) + 72*cos(theta5)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1)) - 70*cos(theta2)*sin(theta1)*sin(theta3) - 70*cos(theta3)*sin(theta1)*sin(theta2) + 302*sin(theta1)*sin(theta2)*sin(theta3) + 72*cos(theta4)*sin(theta5)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2)) - 302*cos(theta2)*cos(theta3)*sin(theta1);
    j3=p_z*(cos(theta5)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1)) + cos(theta4)*sin(theta5)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2))) + p_x*(cos(theta6)*(sin(theta5)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1)) - cos(theta4)*cos(theta5)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2))) + sin(theta4)*sin(theta6)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2))) - p_y*(sin(theta6)*(sin(theta5)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1)) - cos(theta4)*cos(theta5)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2))) - cos(theta6)*sin(theta4)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2))) + 72*cos(theta5)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1)) - 70*cos(theta2)*sin(theta1)*sin(theta3) - 70*cos(theta3)*sin(theta1)*sin(theta2) + 302*sin(theta1)*sin(theta2)*sin(theta3) + 72*cos(theta4)*sin(theta5)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2)) - 302*cos(theta2)*cos(theta3)*sin(theta1);
    j4=72*sin(theta5)*(cos(theta1)*cos(theta4) - sin(theta4)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1))) + p_x*(sin(theta6)*(cos(theta1)*sin(theta4) + cos(theta4)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1))) - cos(theta5)*cos(theta6)*(cos(theta1)*cos(theta4) - sin(theta4)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1)))) + p_y*(cos(theta6)*(cos(theta1)*sin(theta4) + cos(theta4)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1))) + cos(theta5)*sin(theta6)*(cos(theta1)*cos(theta4) - sin(theta4)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1)))) + p_z*sin(theta5)*(cos(theta1)*cos(theta4) - sin(theta4)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1)));
    j5=p_z*(cos(theta5)*(cos(theta1)*sin(theta4) + cos(theta4)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1))) + sin(theta5)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2))) + 72*cos(theta5)*(cos(theta1)*sin(theta4) + cos(theta4)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1))) + 72*sin(theta5)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2)) + p_x*cos(theta6)*(sin(theta5)*(cos(theta1)*sin(theta4) + cos(theta4)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1))) - cos(theta5)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2))) - p_y*sin(theta6)*(sin(theta5)*(cos(theta1)*sin(theta4) + cos(theta4)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1))) - cos(theta5)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2)));
    j6=p_y*(sin(theta6)*(cos(theta1)*cos(theta4) - sin(theta4)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1))) + cos(theta6)*(cos(theta5)*(cos(theta1)*sin(theta4) + cos(theta4)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1))) + sin(theta5)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2)))) - p_x*(cos(theta6)*(cos(theta1)*cos(theta4) - sin(theta4)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1))) - sin(theta6)*(cos(theta5)*(cos(theta1)*sin(theta4) + cos(theta4)*(sin(theta1)*sin(theta2)*sin(theta3) - cos(theta2)*cos(theta3)*sin(theta1))) + sin(theta5)*(cos(theta2)*sin(theta1)*sin(theta3) + cos(theta3)*sin(theta1)*sin(theta2))));
end