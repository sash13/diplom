close all;clear all;clc;                        % Подготовка рабочего простанства

Vx0=0; Vy0=0;                                   %начальная скорость рабочего органа
a=40;                                           %максимальное ускорение
Vrm=1;                                          %максимальная скорость на рабочем участке
Vvm=2;                                          %максимальная скорость на участке выхода на траекторию
stop=5;                                         %время завершения моделирования

x0=-0.4; y0=0.5;                                    %координаты точки выхода на траекторию
x1=0.4; y1=0.5;                                 %координаты 1-ой точки
x2=0.8; y2=0.5;                              %координаты 2-ой точки
x4=0.8; y4=-0.5;                              %координаты 3-ей точки
x3=0.4; y3=-0.5;		%координаты 4-ой точки


L1=0.7; L2=0.7;                             %Задание длинн звеньев манипулятора

Sv=ras(x1,x0,y1,y0);                            %расстояние выхода на траекторию
S1=ras(x2,x1,y2,y1);                            %расстояние, пройденное на 1-ом участке
S2=ras(x3,x2,y3,y2);                            %расстояние, пройденное на 2-ом участке
S3=ras(x4,x3,y4,y3);                            %расстояние, пройденное на 3-ем участке
S4=ras(x1,x4,y1,y4);                            %расстояние, пройденное на 4-ом участке

tv=Vvm/a;                                       %время разгона при выходе на траекорию
tr=Vrm/a;                                       %время разгона на рабочем участке

Svt=0.5*a*tv*tv;                                %расстояние, пройденное за время разгона или торможения при
                                                %при выходе на траекторию
Srt=0.5*a*tr*tr;                                %расстояние, пройденное за время разгона или торможения
                                                %на рабочем участке
Svp=Sv-2*Svt;                                   %расстояние, пройденное за время установившегося движения
                                                %при выходе на траекторию
Srp=Sv-2*Srt;                                   %расстояние, пройденное за время установившегося движения
                                                %на рабочем участке
                                                
tvp=(Sv-2*Svt)/Vvm;                             %время движения с постоянной скоростью при выходе на траекторию
tr1=(S1-2*Srt)/Vrm;                             %время движения с постоянной скоростью на рабочем участке 1
tr2=(S2-2*Srt)/Vrm;                             %время движения с постоянной скоростью на рабочем участке 2
tr3=(S3-2*Srt)/Vrm;                             %время движения с постоянной скоростью на рабочем участке 3
tr4=(S4-2*Srt)/Vrm;                             %время движения с постоянной скоростью на рабочем участке 4

%===============Расчет угла на участках движения=============
alpha0=ugol(x1,x0,y1,y0);                       
alpha1=ugol(x2,x1,y2,y1);
alpha2=ugol(x3,x2,y3,y2);
alpha3=ugol(x4,x3,y4,y3);
alpha4=ugol(x1,x4,y1,y4);
alpha5=ugol(x0,x1,y0,y1);

%===============Расчет ускорений на участках движения=============
ax0=a*cos(alpha0);  ay0=a*sin(alpha0);
ax1=a*cos(alpha1);  ay1=a*sin(alpha1);
ax2=a*cos(alpha2);  ay2=a*sin(alpha2);
ax3=a*cos(alpha3);  ay3=a*sin(alpha3);
ax4=a*cos(alpha4);  ay4=a*sin(alpha4);
ax5=a*cos(alpha5);  ay5=a*sin(alpha5);

tpv=0.1*(tvp+2*tv);                             %время паузы по окончанию выхода на траекторию
tp1=0.1*(tr1+2*tr);                             %время паузы по окончанию отработки 1-го участка
tp2=0.1*(tr2+2*tr);                             %время паузы по окончанию отработки 2-го участка
tp3=0.1*(tr3+2*tr);                             %время паузы по окончанию отработки 3-го участка
tp4=0.1*(tr4+2*tr);                             %время паузы по окончанию отработки 4-го участка

%====================Задание вектора времени движения по участкам===========
t1=[0;
    tv; tvp; tv; tpv;                           %выход на траекторию    
    tr; tr1; tr; tp1;                           %движение по участку 1
    tr; tr2; tr; tp2;                           %движение по участку 2
    tr; tr3; tr; tp3;                           %движение по участку 3
    tr; tr4; tr; tp4;                           %движение по участку 4
    tv; tvp; tv; 1.2];                          %уход с траектории

b=0;
for i=1:length(t1);
    b=b+t1(i);
    t2(i)=b;
end;

%===================Задание вектора ускорений (проэкция на X)==============
ax=[ax0; 0; -ax0; 0;                            %выход на траекторию
    ax1; 0; -ax1; 0;                            %движение по участку 1
    ax2; 0; -ax2; 0;                            %движение по участку 2
    ax3; 0; -ax3; 0;                            %движение по участку 3
    ax4; 0; -ax4; 0;                            %движение по участку 4
    ax5; 0; -ax5; 0];                           %уход с траектории

%===================Задание вектора ускорений (проэкция на Y)=============
ay=[ay0; 0; -ay0; 0;                            %выход на траекторию
    ay1; 0; -ay1; 0;                            %движение по участку 1
    ay2; 0; -ay2; 0;                            %движение по участку 2
    ay3; 0; -ay3; 0;                            %движение по участку 3
    ay4; 0; -ay4; 0;                            %движение по участку 4
    ay5; 0; -ay5; 0];                           %уход с траектории

%===================Задание пустых векторов для сохранения данных=============
tout=[];
xout=[];
yout=[];
Vxout=[];
Vyout=[];
%r=[];
%f=[];

%==============Цикл вычесления скоростей и положений манипулятора===========
dt=0.001;                                           %шаг расчета
t=0:dt:t2(length(t2));                              %задание вектора времени
j1=1;x=[];y=[];                                     %создание пустых векторов x и y
for i=1:(length(t2)-1);                             %организация циклов по участкам движения
    for t=t2(i):dt:t2(i+1);                         %организация цикла расчета величин на каждом участке
        Vx=Vx0+ax(i)*(t-t2(i));                     %расчет скорости по координате x
        Vy=Vy0+ay(i)*(t-t2(i));                     %расчет скорости по координате y
        xo=x0+Vx0*(t-t2(i))+(ax(i)*(t-t2(i))^2)/2;  %расчет координаты x
        yo=y0+Vy0*(t-t2(i))+(ay(i)*(t-t2(i))^2)/2;  %расчет координаты y
           %Сохранение данных в вектора
   tout=[tout t];
   xout=[xout xo];
   yout=[yout yo];
   Vxout=[Vxout Vx];
   Vyout=[Vyout Vy];
    end;
   Vx0=Vx;
   Vy0=Vy;
   x0=xo;
   y0=yo;
end; 

teta1=[];teta2=[];teta3=[];
teta1_pr=0;
eta=0.01;
for k=1:length(xout) 

   teta2(k)=acos((xout(k)^2+yout(k)^2-L1^2-L2^2)/(2*L1*L2));    %расчет угла Тэта_2
   teta1(k)=atan((yout(k)*(L1+L2*cos(teta2(k)))-xout(k)*L2*sin(teta2(k)))/(yout(k)*(L2*sin(teta2(k)))+xout(k)*(L1+L2*cos(teta2(k)))));  %Расчет угла Тета_1
   teta3(k)=teta1(k);
s1(k)=(yout(k)*(L1+L2*cos(teta2(k)))-xout(k)*L2*sin(teta2(k)));
c1(k)=(yout(k)*(L2*sin(teta2(k)))+xout(k)*(L1+L2*cos(teta2(k))));
%r=[r r1];
%f=[f f1];

if s1(k)>=0;
    if c1(k)>=0;
%        if teta1_pr>=0
%            teta1(k)=teta1(k);%-pi;
%        else
            if teta1_pr<=-pi;
                teta1(k)=-(2*pi-teta1(k));                
            else
                if teta1_pr>=3*pi/2
                    teta1(k)=2*pi+teta1(k);
                else
                    teta1(k)=teta1(k);%-pi;
                end;
        end;
    else
        if teta1_pr>=0
            teta1(k)=pi+teta1(k);
        else
            teta1(k)=-pi+teta1(k);
        end;
    end;
else
    if c1(k)>0;
        if teta1_pr>=pi;
            teta1(k)=2*pi+teta1(k);
        else
            teta1(k)=teta1(k);
        end;
    else
        if teta1_pr>=0
            teta1(k)=pi+teta1(k);
        else
            teta1(k)=-pi+teta1(k);
        end;
    
    end;
end;
 %   teta1(i)=-teta1(i)-pi; end;

   %if  teta1(k)>(pi/2); teta1(k)=teta1(k)-pi; end;              
   
 % Обратная задача нахождение координат x и y зная углы Q1 и Q2
 teta1_pr=teta1(k);
   xobr(k)=L1*cos(teta1(k))+L2*cos(teta1(k)+teta2(k));      %расчет координаты Х через углы поворота
   yobr(k)=L1*sin(teta1(k))+L2*sin(teta1(k)+teta2(k));      %расчет координаты Y через углы поворота
            
   omega1(k)=(Vxout(k)*L2*cos(teta1(k)+teta2(k)))+Vyout(k)*L2*sin(teta1(k)+teta2(k))/(L1*L2*sin(teta2(k)));     %угловая скорость 1-го звена
   omega2(k)=-(Vxout(k)*(L1*cos(teta1(k))+L2*cos(teta1(k)+teta2(k)))+Vyout(k)*(L1*sin(teta1(k))+L2*sin(teta1(k)+teta2(k))))/(L1*L2*sin(teta2(k)));  %угловая скорость 2-го звена
end;      

%===================Вывод графиков Vx(t), Vy(t), x(t), y(t), y(x)===========

figure;                                             %создание фигуры 1
    subplot(2,2,1);
    plot(tout,Vxout ,'Linewidth',2);                               %вывод Vx(t)
    title('Скорость по координате x','FontName','MS Sans Serif');
    xlabel('t, [s]','FontName','MS Sans Serif');
    ylabel('Vx(t) [m/s]');
    axis([0,stop,-1,1.5]);
    grid on; 
    hold on;
    plot([0 stop],[0 0] );
subplot(2,2,2);
plot(tout,Vyout ,'Linewidth',2);                                   %вывод Vy(t)
title('Скорость по координате y','FontName','MS Sans Serif');
xlabel('t, [s]','FontName','MS Sans Serif');
ylabel('Vy(t) [m/s]');
axis([0,stop,-2.5,2.5]);
grid on;       
hold on;
plot([0 stop],[0 0] );
    subplot(2,2,3);
    plot(tout,xout ,'Linewidth',2);                                %вывод x(t)
    title('Изменение координаты x','FontName','MS Sans Serif');
    xlabel('t, [s]','FontName','MS Sans Serif');
    ylabel('x(t) [m]');
    axis([0,stop,-0.5,1]);
    grid on;        
    hold on;
    plot([0 stop],[0 0] );
subplot(2,2,4);
plot(tout,yout ,'Linewidth',2);                                    %вывод y(t)
title('Изменение координаты y','FontName','MS Sans Serif');
xlabel('t, [s]','FontName','MS Sans Serif');
ylabel('y [m]');
axis([0,stop,0,1.5]);
grid on;       
hold on;
plot([0 stop],[0 0] );
%saveas(subplot(2,2,1),'Vx','emf');


figure;                                             %создание фигуры 2
plot(xout,yout ,'Linewidth',2);
    title('Данная фигура для отработки','FontName','MS Sans Serif');
    xlabel('x [m]','FontName','MS Sans Serif');
    ylabel('y [m]');
%    axis([-0.5 1 0 1.5]);
    grid on;                                        %вывод y(x)
    hold on;
    plot([-0.5 1.5],[0 0] );
    plot([0 0],[-0.5 2.5] );
    %saveas(plot(xout,yout ,'Linewidth',2),'figura1','emf');


%===================Вывод графиков teta1(t), teta2(t), omega1(t), omega(t), y(x)===========

% создание фигуры 3
figure;                                     
subplot(2,2,1);                                     %вывод teta1(t)
plot(tout,teta1 ,'Linewidth',2);
title('Угол поворота первого звена','FontName','MS Sans Serif');
xlabel('t, [s]');
ylabel('teta_1(t), [rad]');
%axis([0,stop,-2,2]);
grid on;        
hold on;
plot([0 stop],[0 0] );
    subplot(2,2,2);                                 %вывод teta2(t)
    plot(tout,teta2 ,'Linewidth',2);
    title('Угол поворота второго звена','FontName','MS Sans Serif');
    xlabel('t, [s]');
    ylabel('teta_2(t), [rad]');
    axis([0,stop,0,4]);
    grid on;
    hold on;
    plot([0 stop],[0 0] );
subplot(2,2,3);                                     %вывод omega1(t)
plot(tout,omega1 ,'Linewidth',2);
title('Угловая скорость первого звена','FontName','MS Sans Serif');
xlabel('t, [s]');
ylabel('\omega_1(t), [rad/s]');
axis([0,stop,-2,3]);
grid on;
hold on;
plot([0 stop],[0 0] );
    subplot(2,2,4);                                 %вывод omega2(t)
    plot(tout,omega2 ,'Linewidth',2);
    title('Угловая скорость второго звена','FontName','MS Sans Serif');
    xlabel('t, [s]');
    ylabel('\omega_2(t), [rad/s]');
    axis([0,stop,-1,1]);
    grid on;
    hold on;
    plot([0 stop],[0 0] );
    %saveas(subplot(2,2,1),'omega','emf');

% создание фигуры 4
figure;                                             %вывод yobr(xobr)                       
plot(xobr,yobr ,'Linewidth',2);
title('Отработка фигуры','FontName','MS Sans Serif')
xlabel('xobr [m]','FontName','MS Sans Serif');
ylabel('yobr [m]');
%axis([-0.5 1 0 1.5]);
grid on;
hold on;
plot([-0.5 1],[0 0] );
plot([0 0],[-0.5 1.5] );
%saveas(plot(xobr,yobr ,'Linewidth',2),'figura2','emf');

%figure;
%subplot(2,1,1)
%plot(t,r);
%subplot(2,1,2)
%plot(t,f);

maxd=0;

figure;
plot(tout,s1,'k-');
hold on;
plot(tout,c1,'b-');
hold on;
plot(tout,teta3,'r-');
plot(tout,s1.^2+c1.^2,'y-');


figure;
plot(xout,yout,'k-');
line([-maxd maxd],[0 0]);
line([0 0],[-maxd maxd]);
x1=0;y1=0;x2=0;y2=0;
h=line([0 x1 x2],[0 y1 y2]);
axis([-2 2 -2 2]);
grid off
set(h,'EraseMode','xor');
k=3;
for i=1:floor(length(tout)/k);
   drawnow;
   x1=L1*cos(teta1(i*k));
   y1=L1*sin(teta1(i*k));
   x2=L1*cos(teta1(i*k))+L2*cos(teta1(i*k)+teta2(i*k));
   y2=L1*sin(teta1(i*k))+L2*sin(teta1(i*k)+teta2(i*k));
   %set(h,[0 x1 x2],[0 y1 y2]);
   set(h,'XData',[0 x1 x2],'YData',[0 y1 y2],'LineStyle','-','LineWidth',2,'Color','b');
   pause(0.001);
end;
