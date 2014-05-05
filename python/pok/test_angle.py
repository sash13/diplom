import math

l1 = 1.5
l2 = 1.5
def deg(a):
    return math.degrees(a)

def main():
    while True:
        us=raw_input('Enter: ').split(',')
        print getAngles(float(us[0]), float(us[1]))

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
    print angle
    if angle > 0:
        angle-=math.pi
    return angle

main()
