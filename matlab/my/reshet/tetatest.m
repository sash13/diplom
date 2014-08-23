figure
L1=1.49; L2=1.47;                             %������� ����� ������� ������������                          
for k=1:length(nTeta1) 
   %teta2(k)=acos((xout(k)^2+yout(k)^2-L1^2-L2^2)/(2*L1*L2));    %������ ���� ����_2
   %teta1(k)=atan((yout(k)*(L1+L2*cos(teta2(k)))-xout(k)*L2*sin(teta2(k)))/(yout(k)*(L2*sin(teta2(k)))+xout(k)*(L1+L2*cos(teta2(k)))));  %������ ���� ����_1
   %if teta1(k)<0
    %   teta1(k)=teta2(k)-abs(teta1(k));
    %   teta2(k)=-teta2(k);
   %end;
   
 % �������� ������ ���������� ��������� x � y ���� ���� Q1 � Q2
   nT11(k)=(180 - nTeta1(k))*pi/180;
   nT22(k)=(nTeta2(k)-180)*pi/180;
   nx1(k)=L1*cos(nT11(k))+L2*cos(nT11(k)+nT22(k));      %������ ���������� � ����� ���� ��������
   ny1(k)=L1*sin(nT11(k))+L2*sin(nT11(k)+nT22(k));
end;
%plot(nx.*10,ny.*10, '--r')
plot(nx.*100,ny.*100, '--r')
%grid
%hold
for k=2:length(shturik(:,1)) 
   %teta2(k)=acos((xout(k)^2+yout(k)^2-L1^2-L2^2)/(2*L1*L2));    %������ ���� ����_2
   %teta1(k)=atan((yout(k)*(L1+L2*cos(teta2(k)))-xout(k)*L2*sin(teta2(k)))/(yout(k)*(L2*sin(teta2(k)))+xout(k)*(L1+L2*cos(teta2(k)))));  %������ ���� ����_1
   %if teta1(k)<0
    %   teta1(k)=teta2(k)-abs(teta1(k));
    %   teta2(k)=-teta2(k);
   %end;
   
 % �������� ������ ���������� ��������� x � y ���� ���� Q1 � Q2
 if shturik(k,3) > 180
     shturik(k,3) = 180;
 end
 if shturik(k,3) < 0
     shturik(k,3) = 0;
 end
 
   nT1(k)=(180 - shturik(k,3))*pi/180;
   nT2(k)=(shturik(k,4)-180)*pi/180;
   nx(k)=L1*cos(nT1(k))+L2*cos(nT1(k)+nT2(k));      %������ ���������� � ����� ���� ��������
   ny(k)=L1*sin(nT1(k))+L2*sin(nT1(k)+nT2(k));
   %k= k+1;
   if ny(k) > 1.45
       ny(k) = ny(k-1);
   end
   %if ny(k) < 0
   %    ny(k) = 0.013;
   %end
      
   if nx(k) > 2.5
       nx(k) = nx(k-1);
   end
   if nx(k) < 1
       nx(k) = nx(k-1);
   end
   %k= k+10;
end;
plot(nx./0.01,ny./0.01)
%plot(nx1.*10. - nx./0.01,ny1.*10. - ny./0.01, '--r')
%axis([100, 250, 0, 150])
%xlabel('x, mm')
%ylabel('y, mm')
