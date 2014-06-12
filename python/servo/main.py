#!/usr/bin/env python
import logging
import itertools
import platform
import serial
import time
if platform.system() == 'Windows':
    import _winreg as winreg
else:
    import glob

logging.basicConfig(filename='main.log',level=logging.DEBUG)
log = logging.getLogger(__name__)


def enumerate_serial_ports():
    """
    Uses the Win32 registry to return a iterator of serial
        (COM) ports existing on this computer.
    """
    path = 'HARDWARE\\DEVICEMAP\\SERIALCOMM'
    try:
        key = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, path)
    except WindowsError:
        raise Exception
  
    for i in itertools.count():
        try:
            val = winreg.EnumValue(key, i)
            yield (str(val[1]))  # , str(val[0]))
        except EnvironmentError:
            break

def find_port(baud, timeout):
    """
    Find the first port that is connected to an servo
    """
    if platform.system() == 'Windows':
        ports = enumerate_serial_ports()
    else:
        ports = glob.glob("/dev/ttyUSB*") + glob.glob("/dev/ttyACM*")
    for p in ports:
        log.debug('Found {0}, testing...'.format(p))
        try:
            sr = serial.Serial(p, baud, timeout=timeout)
        except (serial.serialutil.SerialException, OSError) as e:
            log.debug(str(e))
            continue
        time.sleep(2)
        ping_get = ping(sr)
        print ping_get
        if ping_get != '1':
            log.debug('Bad version {0}. This is not a Servo!'.format(
                ping_get))
            sr.close()
            continue
        log.info('Using port {0}.'.format(p))
        if sr:
            return sr
    return None

def ping(sr):
    try:
        sr.write('V')
        sr.flush()
    except Exception:
        return None
    return sr.read()

class Servo(object):
    def __init__(self, baud=9600, port=None, timeout=2):
        sr = find_port(baud, timeout)
        if not sr:
            raise ValueError("Could not find port.")
        sr.flush()
        self.sr = sr
        self.servo_state = [chr(0) for i in range(6)]
        self.servo_actual_state = [0, 0, 0, 0, 0, 0]
        
    def servo_one(self, num, angle):
        string = 'N' + chr(num)+ chr(angle) + 'E'
        self.sr.write(string)
        self.sr.flush()
        
    def servo_set(self, num, angle):
        self.servo_state[num] = chr(angle);
        
    def servo_flush(self):
        string = 'S' + "".join(self.servo_state) + 'E'
        self.sr.write(string)
        self.sr.flush()

    def servo_angle(self):
        try:
            self.sr.write('A')
            self.sr.flush()
        except:
            pass
        rd = self.sr.read(20)
        print len(rd)
        try:
            arr =[]
            #print rd
            if(rd[0] is 'A'):
                for i in range(1,7):
                    arr.append(ord(rd[i]))
                    print ord(rd[i])
            self.servo_actual_state = arr
        except:
            print 'pok'
        
    def servo_mode(self, mode):
        try:
            self.sr.write('M'+chr(mode))
            self.sr.flush()
        except:
            pass  
        
ser = Servo()


ser.servo_mode(1)
#time.sleep(5)
while 1:
    ser.servo_one(0, 90)
    ser.servo_one(1, 180)
    print 'new angle'

    time.sleep(2)

    ser.servo_one(0, 0)
    ser.servo_one(1, 0)

    print 'new angle 2'
    time.sleep(2)

'''while 1:
    ser.servo_angle()
    print ser.servo_actual_state'''

#ser.servo_flush()
#time.sleep(1)


#ser.servo_angle()
#print ser.servo_actual_state


#ser.servo_mode(0)
'''for i in range(180):
    ser.servo_set(0, i)
    ser.servo_set(1, 180-i)
    ser.servo_set(2, i)
    ser.servo_flush()
    time.sleep(0.2)
for i in range(180, -1, -1):
    ser.servo_set(0, i)
    ser.servo_set(1, 180-i)
    ser.servo_set(2, i)
    ser.servo_flush()
    time.sleep(0.2)
'''
