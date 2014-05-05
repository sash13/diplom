function f=ugol(x1,x0,y1,y0)
if (x1-x0)==0 
       if (y1-y0)<0 f=3*pi/2;
     else f=pi/2; end;
 else
        if (x1-x0)<0 f=atan((y1-y0)/(x1-x0))+pi;
        else f=atan((y1-y0)/(x1-x0)); end; end;