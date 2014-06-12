%initial class for control stend
p = Servo;

%connect to stend
p.connect('COM2');

%set mode to custom
% 0 - free
% 1- custom
% 2-4 other
p.servo_mode(1);

%update only one angle
p.servo_one(1, 180);

%update multiple angle

p.servo_set(0, 90);
p.servo_set(1, 180);
p.servo_set(2, 100);
p.servo_set(6, 80);

%send updated angle
p.servo_flush();

for i = 1:180
    p.servo_set(0, i);
    p.servo_set(1, 180-i);
    p.servo_flush();
    pause(0.1);
end

%disconect from stend
p.disconnect();