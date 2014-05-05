from Tkinter import Tk, Canvas, Frame, BOTH
import math

width = 400
hight = 300+50
points = {'1':90, '2':90}
points2 = {'1':[], '2':45}
arms=[]
arm_width = 15
arm_lenght = 150
l1 = 150.0
l2 = 150.0

def deg(a):
    return math.degrees(a)

def circle(x0, y0, r):
    x=[x0+r*math.cos(i*math.pi/180) for i in range(1, 361, 4)]
    y=[y0+r*math.sin(i*math.pi/180)  for i in range(1, 361, 4)]
    return (x, y)

def box(x0, y0, x1, y1):
    x=[i*10 for i in range(int(math.fabs(x0)), int(math.fabs(x1)))]
    y=[y0*10  for i in range(int(math.fabs(x0)), int(math.fabs(x1)))]

    '''x=x+[x1*10 for i in range(y0, y1)]
    y=y+[i*10  for i in range(y0, y1)]'''

    '''x=x+[i*10 for i in [-i for i in range(-x1+1,-x0+1)]]
    y=y+[y1*10  for i in [-i for i in range(-x1+1,-x0+1)]]

    x=x+[x0*10 for i in [-i for i in range(-y1+1,-y0+1)]]
    y=y+[i*10  for i in [-i for i in range(-y1+1,-y0+1)]]  '''
    return (x, y)

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

        self.parent.create_line(int(self.cor[0]), int(self.cor[1]),
                                int(self.cor1[0]), int(self.cor1[1]), width=arm_width, fill=fill)
        return self.cor1
        
class Example(Frame):
    def __init__(self, parent):
        Frame.__init__(self, parent)
 
        self.x0, self.y0 = circle(-90, 90, 40)
        #self.x0, self.y0 = circle(-90, 90, 35)
        
        #print len(self.x0)
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

        for i in range(0, len(self.x0), 2):
            self.canvas.create_line(width/2+self.x0[i], hight/2-self.y0[i],
                                    width/2+self.x0[i+1],hight/2-self.y0[i+1], width=2)


        tet1p, tet2p = getAngles(self.x0[self.count1], self.y0[self.count1])
        
        tet1 = 180-(tet1p)
        tet2 = 180-((tet2p)-tet1)+180

        text = '('+str(tet1p) +',' + str(tet2p) + ')'
        self.canvas.create_text((width/2, hight-100),text=text)

        
        line = arms[0].draw(tet1)
        arms[1].draw(tet2, line, 'red')
        
        self.count1+=self.sign1
        if self.count1 == (len(self.x0)-1) and self.sign1 == 1:
            #self.sign1 = -1
            self.count1 = 0
        if self.count1 <= 0 and self.sign1 == -1:
            self.sign1 = 1
            #self.x0=self.x01
            #self.y0=self.y01

        #line = arms[0].draw(points['1'])
        #arms[1].draw(90-(points['2']-points['1']), line)

        self.canvas.update()
        #self.count +=1
        self.parent.after(100, self.animation)

def main():
    root = Tk()
    ex = Example(root)
    wh = str(width) + 'x' + str(hight)
    root.geometry(wh)
    root.mainloop()  

def getAngles(x0, y0):
    tet2 = calk_tet2(x0, y0)
    tet1 = calk_tet1(x0, y0, tet2)
    return (int(deg(tet1)), int(deg(tet2)))

def calk_tet2(x0, y0):
    angle = math.acos((x0*x0+y0*y0-l1*l1-l2*l2)/(2*l1*l2))
    return angle

def calk_tet1(x0, y0, tet2):
    angle = math.atan((y0*(l1+l2*math.cos(tet2))-x0*l2*math.sin(tet2))
			/(y0*l2*math.sin( tet2 ) + x0*(l1+l2*math.cos( tet2 ))))
    #print angle
    #if angle < 0:
    #    angle+=math.pi
    return angle

if __name__ == '__main__':
    main() 
