function [xn,yn,zn] = eulerangles(x,y,z,yaw,pitch,roll)
    xn = x*cos(yaw)*cos(pitch) + y*(cos(yaw)*sin(pitch)*sin(roll) - sin(yaw)*cos(roll)) + z*(cos(yaw)*sin(pitch)*cos(roll) + sin(yaw)*sin(roll));
    yn = x*sin(yaw)*cos(pitch) + y*(sin(yaw)*sin(pitch)*sin(roll) + cos(yaw)*cos(roll)) + z*(sin(yaw)*sin(pitch)*cos(roll) - cos(yaw)*sin(roll));
    zn = -x*sin(pitch) + y*(cos(pitch)*sin(roll)) + z*(cos(pitch)*cos(roll));

end