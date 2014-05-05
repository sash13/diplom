close all;clear all;clc;                        % Ïîäãîòîâêà ðàáî÷åãî ïðîñòàíñòâà

Vx0=0; Vy0=0;                                   %íà÷àëüíàÿ ñêîðîñòü ðàáî÷åãî îðãàíà
a=40;                                           %ìàêñèìàëüíîå óñêîðåíèå
Vrm=1;                                          %ìàêñèìàëüíàÿ ñêîðîñòü íà ðàáî÷åì ó÷àñòêå
Vvm=2;                                          %ìàêñèìàëüíàÿ ñêîðîñòü íà ó÷àñòêå âûõîäà íà òðàåêòîðèþ
stop=5;                                         %âðåìÿ çàâåðøåíèÿ ìîäåëèðîâàíèÿ

x0=-0.4; y0=0.5;                                    %êîîðäèíàòû òî÷êè âûõîäà íà òðàåêòîðèþ
x1=0.4; y1=0.5;                                 %êîîðäèíàòû 1-îé òî÷êè
x2=0.8; y2=0.5;                              %êîîðäèíàòû 2-îé òî÷êè
x4=0.8; y4=-0.5;                              %êîîðäèíàòû 3-åé òî÷êè
x3=0.4; y3=-0.5;		%êîîðäèíàòû 4-îé òî÷êè


L1=0.7; L2=0.7;                             %Çàäàíèå äëèíí çâåíüåâ ìàíèïóëÿòîðà

Sv=ras(x1,x0,y1,y0);                            %ðàññòîÿíèå âûõîäà íà òðàåêòîðèþ
S1=ras(x2,x1,y2,y1);                            %ðàññòîÿíèå, ïðîéäåííîå íà 1-îì ó÷àñòêå
S2=ras(x3,x2,y3,y2);                            %ðàññòîÿíèå, ïðîéäåííîå íà 2-îì ó÷àñòêå
S3=ras(x4,x3,y4,y3);                            %ðàññòîÿíèå, ïðîéäåííîå íà 3-åì ó÷àñòêå
S4=ras(x1,x4,y1,y4);                            %ðàññòîÿíèå, ïðîéäåííîå íà 4-îì ó÷àñòêå

tv=Vvm/a;                                       %âðåìÿ ðàçãîíà ïðè âûõîäå íà òðàåêîðèþ
tr=Vrm/a;                                       %âðåìÿ ðàçãîíà íà ðàáî÷åì ó÷àñòêå

Svt=0.5*a*tv*tv;                                %ðàññòîÿíèå, ïðîéäåííîå çà âðåìÿ ðàçãîíà èëè òîðìîæåíèÿ ïðè
                                                %ïðè âûõîäå íà òðàåêòîðèþ
Srt=0.5*a*tr*tr;                                %ðàññòîÿíèå, ïðîéäåííîå çà âðåìÿ ðàçãîíà èëè òîðìîæåíèÿ
                                                %íà ðàáî÷åì ó÷àñòêå
Svp=Sv-2*Svt;                                   %ðàññòîÿíèå, ïðîéäåííîå çà âðåìÿ óñòàíîâèâøåãîñÿ äâèæåíèÿ
                                                %ïðè âûõîäå íà òðàåêòîðèþ
Srp=Sv-2*Srt;                                   %ðàññòîÿíèå, ïðîéäåííîå çà âðåìÿ óñòàíîâèâøåãîñÿ äâèæåíèÿ
                                                %íà ðàáî÷åì ó÷àñòêå
                                                
tvp=(Sv-2*Svt)/Vvm;                             %âðåìÿ äâèæåíèÿ ñ ïîñòîÿííîé ñêîðîñòüþ ïðè âûõîäå íà òðàåêòîðèþ
tr1=(S1-2*Srt)/Vrm;                             %âðåìÿ äâèæåíèÿ ñ ïîñòîÿííîé ñêîðîñòüþ íà ðàáî÷åì ó÷àñòêå 1
tr2=(S2-2*Srt)/Vrm;                             %âðåìÿ äâèæåíèÿ ñ ïîñòîÿííîé ñêîðîñòüþ íà ðàáî÷åì ó÷àñòêå 2
tr3=(S3-2*Srt)/Vrm;                             %âðåìÿ äâèæåíèÿ ñ ïîñòîÿííîé ñêîðîñòüþ íà ðàáî÷åì ó÷àñòêå 3
tr4=(S4-2*Srt)/Vrm;                             %âðåìÿ äâèæåíèÿ ñ ïîñòîÿííîé ñêîðîñòüþ íà ðàáî÷åì ó÷àñòêå 4

%===============Ðàñ÷åò óãëà íà ó÷àñòêàõ äâèæåíèÿ=============
alpha0=ugol(x1,x0,y1,y0);                       
alpha1=ugol(x2,x1,y2,y1);
alpha2=ugol(x3,x2,y3,y2);
alpha3=ugol(x4,x3,y4,y3);
alpha4=ugol(x1,x4,y1,y4);
alpha5=ugol(x0,x1,y0,y1);

%===============Ðàñ÷åò óñêîðåíèé íà ó÷àñòêàõ äâèæåíèÿ=============
ax0=a*cos(alpha0);  ay0=a*sin(alpha0);
ax1=a*cos(alpha1);  ay1=a*sin(alpha1);
ax2=a*cos(alpha2);  ay2=a*sin(alpha2);
ax3=a*cos(alpha3);  ay3=a*sin(alpha3);
ax4=a*cos(alpha4);  ay4=a*sin(alpha4);
ax5=a*cos(alpha5);  ay5=a*sin(alpha5);

tpv=0.1*(tvp+2*tv);                             %âðåìÿ ïàóçû ïî îêîí÷àíèþ âûõîäà íà òðàåêòîðèþ
tp1=0.1*(tr1+2*tr);                             %âðåìÿ ïàóçû ïî îêîí÷àíèþ îòðàáîòêè 1-ãî ó÷àñòêà
tp2=0.1*(tr2+2*tr);                             %âðåìÿ ïàóçû ïî îêîí÷àíèþ îòðàáîòêè 2-ãî ó÷àñòêà
tp3=0.1*(tr3+2*tr);                             %âðåìÿ ïàóçû ïî îêîí÷àíèþ îòðàáîòêè 3-ãî ó÷àñòêà
tp4=0.1*(tr4+2*tr);                             %âðåìÿ ïàóçû ïî îêîí÷àíèþ îòðàáîòêè 4-ãî ó÷àñòêà

%====================Çàäàíèå âåêòîðà âðåìåíè äâèæåíèÿ ïî ó÷àñòêàì===========
t1=[0;
    tv; tvp; tv; tpv;                           %âûõîä íà òðàåêòîðèþ    
    tr; tr1; tr; tp1;                           %äâèæåíèå ïî ó÷àñòêó 1
    tr; tr2; tr; tp2;                           %äâèæåíèå ïî ó÷àñòêó 2
    tr; tr3; tr; tp3;                           %äâèæåíèå ïî ó÷àñòêó 3
    tr; tr4; tr; tp4;                           %äâèæåíèå ïî ó÷àñòêó 4
    tv; tvp; tv; 1.2];                          %óõîä ñ òðàåêòîðèè

b=0;
for i=1:length(t1);
    b=b+t1(i);
    t2(i)=b;
end;

%===================Çàäàíèå âåêòîðà óñêîðåíèé (ïðîýêöèÿ íà X)==============
ax=[ax0; 0; -ax0; 0;                            %âûõîä íà òðàåêòîðèþ
    ax1; 0; -ax1; 0;                            %äâèæåíèå ïî ó÷àñòêó 1
    ax2; 0; -ax2; 0;                            %äâèæåíèå ïî ó÷àñòêó 2
    ax3; 0; -ax3; 0;                            %äâèæåíèå ïî ó÷àñòêó 3
    ax4; 0; -ax4; 0;                            %äâèæåíèå ïî ó÷àñòêó 4
    ax5; 0; -ax5; 0];                           %óõîä ñ òðàåêòîðèè

%===================Çàäàíèå âåêòîðà óñêîðåíèé (ïðîýêöèÿ íà Y)=============
ay=[ay0; 0; -ay0; 0;                            %âûõîä íà òðàåêòîðèþ
    ay1; 0; -ay1; 0;                            %äâèæåíèå ïî ó÷àñòêó 1
    ay2; 0; -ay2; 0;                            %äâèæåíèå ïî ó÷àñòêó 2
    ay3; 0; -ay3; 0;                            %äâèæåíèå ïî ó÷àñòêó 3
    ay4; 0; -ay4; 0;                            %äâèæåíèå ïî ó÷àñòêó 4
    ay5; 0; -ay5; 0];                           %óõîä ñ òðàåêòîðèè

%===================Çàäàíèå ïóñòûõ âåêòîðîâ äëÿ ñîõðàíåíèÿ äàííûõ=============
tout=[];
xout=[];
yout=[];
Vxout=[];
Vyout=[];
%r=[];
%f=[];

%==============Öèêë âû÷åñëåíèÿ ñêîðîñòåé è ïîëîæåíèé ìàíèïóëÿòîðà===========
dt=0.001;                                           %øàã ðàñ÷åòà
t=0:dt:t2(length(t2));                              %çàäàíèå âåêòîðà âðåìåíè
j1=1;x=[];y=[];                                     %ñîçäàíèå ïóñòûõ âåêòîðîâ x è y
for i=1:(length(t2)-1);                             %îðãàíèçàöèÿ öèêëîâ ïî ó÷àñòêàì äâèæåíèÿ
    for t=t2(i):dt:t2(i+1);                         %îðãàíèçàöèÿ öèêëà ðàñ÷åòà âåëè÷èí íà êàæäîì ó÷àñòêå
        Vx=Vx0+ax(i)*(t-t2(i));                     %ðàñ÷åò ñêîðîñòè ïî êîîðäèíàòå x
        Vy=Vy0+ay(i)*(t-t2(i));                     %ðàñ÷åò ñêîðîñòè ïî êîîðäèíàòå y
        xo=x0+Vx0*(t-t2(i))+(ax(i)*(t-t2(i))^2)/2;  %ðàñ÷åò êîîðäèíàòû x
        yo=y0+Vy0*(t-t2(i))+(ay(i)*(t-t2(i))^2)/2;  %ðàñ÷åò êîîðäèíàòû y
           %Ñîõðàíåíèå äàííûõ â âåêòîðà
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

   teta2(k)=acos((xout(k)^2+yout(k)^2-L1^2-L2^2)/(2*L1*L2));    %ðàñ÷åò óãëà Òýòà_2
   teta1(k)=atan((yout(k)*(L1+L2*cos(teta2(k)))-xout(k)*L2*sin(teta2(k)))/(yout(k)*(L2*sin(teta2(k)))+xout(k)*(L1+L2*cos(teta2(k)))));  %Ðàñ÷åò óãëà Òåòà_1
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
   
 % Îáðàòíàÿ çàäà÷à íàõîæäåíèå êîîðäèíàò x è y çíàÿ óãëû Q1 è Q2
 teta1_pr=teta1(k);
   xobr(k)=L1*cos(teta1(k))+L2*cos(teta1(k)+teta2(k));      %ðàñ÷åò êîîðäèíàòû Õ ÷åðåç óãëû ïîâîðîòà
   yobr(k)=L1*sin(teta1(k))+L2*sin(teta1(k)+teta2(k));      %ðàñ÷åò êîîðäèíàòû Y ÷åðåç óãëû ïîâîðîòà
            
   omega1(k)=(Vxout(k)*L2*cos(teta1(k)+teta2(k)))+Vyout(k)*L2*sin(teta1(k)+teta2(k))/(L1*L2*sin(teta2(k)));     %óãëîâàÿ ñêîðîñòü 1-ãî çâåíà
   omega2(k)=-(Vxout(k)*(L1*cos(teta1(k))+L2*cos(teta1(k)+teta2(k)))+Vyout(k)*(L1*sin(teta1(k))+L2*sin(teta1(k)+teta2(k))))/(L1*L2*sin(teta2(k)));  %óãëîâàÿ ñêîðîñòü 2-ãî çâåíà
end;      

%===================Âûâîä ãðàôèêîâ Vx(t), Vy(t), x(t), y(t), y(x)===========

figure;                                             %ñîçäàíèå ôèãóðû 1
    subplot(2,2,1);
    plot(tout,Vxout,'black','Linewidth',2);                               %âûâîä Vx(t)
    title('Ñêîðîñòü ïî êîîðäèíàòå x','FontName','MS Sans Serif');
    xlabel('t, [s]','FontName','MS Sans Serif');
    ylabel('Vx(t) [m/s]');
    axis([0,stop,-1,1.5]);
    grid on; 
    hold on;
    plot([0 stop],[0 0],'black');
subplot(2,2,2);
plot(tout,Vyout,'black','Linewidth',2);                                   %âûâîä Vy(t)
title('Ñêîðîñòü ïî êîîðäèíàòå y','FontName','MS Sans Serif');
xlabel('t, [s]','FontName','MS Sans Serif');
ylabel('Vy(t) [m/s]');
axis([0,stop,-2.5,2.5]);
grid on;       
hold on;
plot([0 stop],[0 0],'black');
    subplot(2,2,3);
    plot(tout,xout,'black','Linewidth',2);                                %âûâîä x(t)
    title('Èçìåíåíèå êîîðäèíàòû x','FontName','MS Sans Serif');
    xlabel('t, [s]','FontName','MS Sans Serif');
    ylabel('x(t) [m]');
    axis([0,stop,-0.5,1]);
    grid on;        
    hold on;
    plot([0 stop],[0 0],'black');
subplot(2,2,4);
plot(tout,yout,'black','Linewidth',2);                                    %âûâîä y(t)
title('Èçìåíåíèå êîîðäèíàòû y','FontName','MS Sans Serif');
xlabel('t, [s]','FontName','MS Sans Serif');
ylabel('y [m]');
axis([0,stop,0,1.5]);
grid on;       
hold on;
plot([0 stop],[0 0],'black');
saveas(subplot(2,2,1),'Vx','emf');


figure;                                             %ñîçäàíèå ôèãóðû 2
plot(xout,yout,'black','Linewidth',2);
    title('Äàííàÿ ôèãóðà äëÿ îòðàáîòêè','FontName','MS Sans Serif');
    xlabel('x [m]','FontName','MS Sans Serif');
    ylabel('y [m]');
%    axis([-0.5 1 0 1.5]);
    grid on;                                        %âûâîä y(x)
    hold on;
    plot([-0.5 1.5],[0 0],'black');
    plot([0 0],[-0.5 2.5],'black');
    saveas(plot(xout,yout,'black','Linewidth',2),'figura1','emf');


%===================Âûâîä ãðàôèêîâ teta1(t), teta2(t), omega1(t), omega(t), y(x)===========

% ñîçäàíèå ôèãóðû 3
figure;                                     
subplot(2,2,1);                                     %âûâîä teta1(t)
plot(tout,teta1,'black','Linewidth',2);
title('Óãîë ïîâîðîòà ïåðâîãî çâåíà','FontName','MS Sans Serif');
xlabel('t, [s]');
ylabel('teta_1(t), [rad]');
%axis([0,stop,-2,2]);
grid on;        
hold on;
plot([0 stop],[0 0],'black');
    subplot(2,2,2);                                 %âûâîä teta2(t)
    plot(tout,teta2,'black','Linewidth',2);
    title('Óãîë ïîâîðîòà âòîðîãî çâåíà','FontName','MS Sans Serif');
    xlabel('t, [s]');
    ylabel('teta_2(t), [rad]');
    axis([0,stop,0,4]);
    grid on;
    hold on;
    plot([0 stop],[0 0],'black');
subplot(2,2,3);                                     %âûâîä omega1(t)
plot(tout,omega1,'black','Linewidth',2);
title('Óãëîâàÿ ñêîðîñòü ïåðâîãî çâåíà','FontName','MS Sans Serif');
xlabel('t, [s]');
ylabel('\omega_1(t), [rad/s]');
axis([0,stop,-2,3]);
grid on;
hold on;
plot([0 stop],[0 0],'black');
    subplot(2,2,4);                                 %âûâîä omega2(t)
    plot(tout,omega2,'black','Linewidth',2);
    title('Óãëîâàÿ ñêîðîñòü âòîðîãî çâåíà','FontName','MS Sans Serif');
    xlabel('t, [s]');
    ylabel('\omega_2(t), [rad/s]');
    axis([0,stop,-1,1]);
    grid on;
    hold on;
    plot([0 stop],[0 0],'black');
    saveas(subplot(2,2,1),'omega','emf');

% ñîçäàíèå ôèãóðû 4
figure;                                             %âûâîä yobr(xobr)                       
plot(xobr,yobr,'black','Linewidth',2);
title('Îòðàáîòêà ôèãóðû','FontName','MS Sans Serif')
xlabel('xobr [m]','FontName','MS Sans Serif');
ylabel('yobr [m]');
%axis([-0.5 1 0 1.5]);
grid on;
hold on;
plot([-0.5 1],[0 0],'black');
plot([0 0],[-0.5 1.5],'black');
saveas(plot(xobr,yobr,'black','Linewidth',2),'figura2','emf');

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
