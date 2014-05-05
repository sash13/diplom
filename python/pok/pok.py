from Tkinter import Tk, Canvas, Frame, BOTH
import math

points = {'1':90, '2':90}
points2 = {'1':[], '2':45}
arms=[]
arm_width = 15
arm_lenght = 150
l1 = 1.5
l2 = 1.5
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
    def __init__(self, parent):
        Frame.__init__(self, parent)
        self.x0=[x*0.1 for x in range(10, 15)]
        self.y0=[0 for x in range(10, 15)]
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
        line = Line(self.canvas, points['1'], (800/2, 400))
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
        if self.count1 >= len(self.x0) and self.sign1 == 1:
            self.sign1 = -1
        if self.count1 <= 0 and self.sign1 == -1:
            self.sign1 = 1

        self.count1+=self.sign1
        tet1, tet2 = getAngles(self.x0[self.count1-1], self.y0[self.count1-1])
	print tet1, tet2
        line = arms[0].draw(tet1)
        arms[1].draw(90-(tet2+tet1), line, 'red')
        #line = arms[0].draw(points['1'])
        #arms[1].draw(90-(points['2']-points['1']), line)

        self.canvas.update()
        #self.count +=1
        self.parent.after(50, self.animation)

def main():
    root = Tk()
    ex = Example(root)
    root.geometry("800x600+300+300")
    root.mainloop()  

def getAngles(x0, y0):
    tet2 = calk_tet2(x0, y0)
    tet1 = calk_tet1(x0, y0, tet2)
    return (int(deg(tet1)), int(deg(tet2)))

def calk_tet2(x0, y0):
    print (x0*x0+y0*y0-l1*l1-l2*l2)/(2*l1*l2)
    angle = math.acos((x0*x0+y0*y0-l1*l1-l2*l2)/(2*l1*l2))
    return angle

def calk_tet1(x0, y0, tet2):
    print (y0*(l1+l2*math.cos(tet2))-x0*l2*math.sin(tet2))/(y0*l2*math.sin( tet2 ) + x0*(l1+l2*math.cos( tet2 )))
    angle = math.atan((y0*(l1+l2*math.cos(tet2))-x0*l2*math.sin(tet2))/(y0*l2*math.sin( tet2 ) + x0*(l1+l2*math.cos( tet2 ))))
    #print angle
    if angle > 0:
        angle-=math.pi
    return angle

if __name__ == '__main__':
    main() 
