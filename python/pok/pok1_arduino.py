from Tkinter import Tk, Canvas, Frame, BOTH
from Arduino import Arduino
import time, math

width = 400
hight = 300+50
points = {'1':90, '2':90}
points2 = {'1':[], '2':45}
arms=[]
arm_width = 15
arm_lenght = 150
l1 = 149.0
l2 = 147.0

def deg(a):
    return math.degrees(a)

class Line(Frame):
    def __init__(self, parent, angle, cor):
        self.cor = cor
        self.parent = parent
        self.cor1 = self.draw(angle, cor)
    def nyak(self, cor, angle):
        return(cor[0] - arm_lenght*math.cos(angle*math.pi/180),
               cor[1] - arm_lenght*math.sin(angle*math.pi/180))
    def draw(self, angle, cor=None, fill = 'black'):
        if cor:
            self.cor=cor
        self.cor1 = self.nyak(self.cor, angle)
        #print angle
        #print self.cor
        #print self.cor1
        self.parent.create_line(int(self.cor[0]), int(self.cor[1]),
                                int(self.cor1[0]), int(self.cor1[1]), width=arm_width, fill=fill)
        return self.cor1
        
class Example(Frame):
    def __init__(self, parent, board):
        Frame.__init__(self, parent)
	self.board = board
        
	self.x0=[-x*10 for x in range(9, 13)]
        self.y0=[9*10  for x in range(9, 13)]

        self.x0=self.x0+[-13*10 for x in range(9, 13)]
        self.y0=self.y0+[x*10  for x in range(9, 13)]

        self.x0=self.x0+[-x*10 for x in [-i for i in range(-13,-8)]]
        self.y0=self.y0+[x*10  for x in [-i for i in range(-13,-8)]]

        #self.x0=self.x0+[-9*10 for x in [-i for i in range(-13,-8)]]
        #self.y0=self.y0+[x*10  for x in [-i for i in range(-13,-8)]]

        #self.x0=[-90 for x in range(70,210)]
        #self.y0=[x*1 for x in [-i for i in range(-200,-60)]]
        #print self.x0
        #self.x0=[5*10 for x in [-i for i in range(-20,-10)]]+self.x0
        #self.y0=[x*10  for x in [-i for i in range(-20,-10)]]+self.y0
        
	#self.x0=[-90+35*math.cos(x*math.pi/180) for x in range(1, 361,4)]
        #self.y0=[-35*math.sin(x*math.pi/180)+90  for x in range(1, 361,4)]
        
        print len(self.x0)
        #self.tet1 = [i for i in range(90)]
        #self.tet2 = [i for i in range(45, 135)]
        self.tet1_con = 0
        self.tet2_con = 0
        
        self.count1 = 0
        self.count2 = 0
        self.sign1 = 1
        self.sign2 = -1
        self.parent = parent
        self.initUI()
        self.parent.after(0, self.animation)
        
    def initUI(self):
        self.parent.title("Arm")        
        self.pack(fill=BOTH, expand=1)
        self.canvas = Canvas(self)
        #self.canvas.create_line(0, 0, 200, 100+self.count, width=arm_width)
        line = Line(self.canvas, points['1'], (width/2, hight/2))
        arms.append(line)
        line = Line(self.canvas, 90-(points['2']-points['1']), line.cor1)
        arms.append(line)
        
        self.canvas.pack(fill=BOTH, expand=1)
        
    def animation(self):
        self.canvas.delete("all")
        #self.canvas.create_line(0, 0, 200, 100+self.count, width=arm_width)
        '''if points['1'] > 90 and self.sign1 == 1:
            self.sign1 = -1
        elif points['1'] == 45 and self.sign1 == -1:
            self.sign1 = 1
        if points['2'] > 135 and self.sign2 == 1:
            self.sign2 = -1
        elif points['2'] == 90 and self.sign2 == -1:
            self.sign2 = 1
            
        points['2']+=self.sign2
        points['1']+=self.sign1'''
        #for i in range(0, len(self.x0), 2):
        #    self.canvas.create_line(width/2+self.x0[i], hight/2-self.y0[i],
        #                            width/2+self.x0[i+1],hight/2-self.y0[i+1], width=5)
	
        #print 800/2+self.x0[0], 300+self.y0[0], 800/2+self.x0[-1],300+self.y0[-1]
        tet1, tet2 = getAngles(self.x0[self.count1], self.y0[self.count1])
        #tet1, tet2 = getAngles(1.5, 0)
        #print (self.x0[self.count1], self.y0[self.count1])
        #print (tet1, tet2)
	print 'tet1:',tet1, 'tet2:', tet2
	#print 'tet2:', tet2
	tet2t = tet2
        tet1 = 180-(tet1)
        tet2 = 180-((tet2)-tet1)+180
        tet1 = tet1
        tet2 = tet2
	temp = 0
	if tet1 > 90:
	    temp = 0
	text = '('+str(tet1-10) +',' + str(180-(tet2-270)-10) + ')'
	print text
	self.canvas.create_text((width/2, hight-100),text=text)
	self.board.Servos.write(9, tet2t-10)
        self.board.Servos.write(11, tet1-10)
        #print (tet1, tet2)
        #line = arms[0].draw(tet1)
        #arms[1].draw(90-(tet2+tet1), line, 'red')
        
        line = arms[0].draw(tet1)
        arms[1].draw(tet2, line, 'red')
        
        self.count1+=self.sign1
        if self.count1 == (len(self.x0)-1) and self.sign1 == 1:
            #self.sign1 = -1
	    self.count1=0
        if self.count1 <= 0 and self.sign1 == -1:
            self.sign1 = 1
            #self.x0=self.x01
            #self.y0=self.y01

        #line = arms[0].draw(points['1'])
        #arms[1].draw(90-(points['2']-points['1']), line)

        self.canvas.update()
        #self.count +=1
        self.parent.after(50, self.animation)

def main():
    board = Servo(10, '9600')
    root = Tk()
    ex = Example(root, board)
    wh = str(width) + 'x' + str(hight)
    root.geometry(wh)

    root.mainloop()  

def getAngles(x0, y0):
    tet2 = calk_tet2(x0, y0)
    tet1 = calk_tet1(x0, y0, tet2)
    return (int(deg(tet1)), int(deg(tet2)))

def calk_tet2(x0, y0):
    angle = math.acos((x0*x0+y0*y0-l1*l1-l2*l2)/(2*l1*l2))
    #print angle
    return angle

def calk_tet1(x0, y0, tet2):
    angle = math.atan((y0*(l1+l2*math.cos(tet2))-x0*l2*math.sin(tet2))
			/(y0*l2*math.sin( tet2 ) + x0*(l1+l2*math.cos( tet2 ))))
    #print angle
    #if angle < 0:
    #    angle+=math.pi
    return angle

def Servo(servo_pin, baud, port=""):
    board = Arduino(baud, port=port)
    board.Servos.attach(servo_pin) #declare servo on pin 9
    board.Servos.attach(servo_pin+1)
    board.Servos.attach(servo_pin-1)
    #print 'ADC: ' + str(board.analogRead(0))
    board.Servos.write(servo_pin, 110) #move servo on pin 9 to 0 degrees
    board.Servos.write(servo_pin+1, 90)
    board.Servos.write(servo_pin-1, 90)
    angle =  board.Servos.read(servo_pin)
    angle =  board.Servos.read(servo_pin+1)
    angle =  board.Servos.read(servo_pin-1)
    return board

if __name__ == '__main__':
    main() 
