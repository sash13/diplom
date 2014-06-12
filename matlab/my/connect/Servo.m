function funs = Servo
  funs.connect=@connect;
  funs.servo_one=@servo_one;
  funs.servo_set=@servo_set;
  funs.servo_flush=@servo_flush;
  funs.servo_mode=@servo_mode;
  funs.disconnect=@close;
  global angles
  angles = [90, 90, 90 ,90, 90, 90];
end

function y=connect(port)
  global servoSerial
  fclose(instrfind);
  servoSerial = serial(port);
  fopen(servoSerial)
  fprintf('Connect to Com port %s \n', port);
  y=servoSerial;
end

function z=servo_one(num, angle)
  global servoSerial
  global angles
  angles(num+1) = angle;
  fwrite(servoSerial,'N', 'uint8');
  fwrite(servoSerial, num, 'uint8');
  fwrite(servoSerial, angle, 'uint8');
  fwrite(servoSerial,'E', 'uint8');
  fprintf('Send servo #%d angle: %d\n', num, angle);
  
  z=0;
end

function z=servo_set(num, angle)
  global angles
  angles(num+1) = angle;
  fprintf('Set servo #%d angle: %d \n', num, angle);
  z=0;
end

function z=servo_flush
  global servoSerial
  global angles
  angles
  fwrite(servoSerial,'S', 'uint8');
  for i = 1:length(angles)
      fwrite(servoSerial,angles(i), 'uint8');
  end
  fwrite(servoSerial,'E', 'uint8');
  
  fprintf('Update multiple servos\n');
  
  z = 0;
end

function z=servo_mode(mode)
  global servoSerial
  fwrite(servoSerial,'M', 'uint8');
  fwrite(servoSerial, mode, 'uint8');
  fprintf('Set stend mode to #%d\n', mode);
end

function z=close
  global servoSerial
  fclose(servoSerial);
  fprintf('Close com port\n');
  z=0;
end
