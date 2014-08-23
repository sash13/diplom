nt11 = [];
nt1 = [];
nt22 = [];
nt1 = [];
for k=1:1:length(nT1) 
    if nT1(k)*180/pi ~= 0
        nt1(k) = nT1(k);
        end
end
for k=1:1:length(nT2)
    nt2(k) = nT2(k);
end

for k=1:1:length(nT11) 
    if nT11(k)*180/pi ~= 0
    nt11(k) = nT11(k);
    end
end
for k=1:1:length(nT22) 
    nt22(k) = nT22(k);
end

figure
subplot(2,1,1)

plot(nt1.*180./pi)
hold
plot(nt11.*180./pi, '--r')
grid
axis([0 3500 0 90])
s = sprintf('Кут, %c', char(176));
xlabel('Кількіст вибірок')
ylabel(s)

subplot(2,1,2)
plot(nt11.*180./pi-nt1.*180./pi, '--r')
grid
axis([0 3500 -10 60])
s = sprintf('Помилка, %c', char(176));
xlabel('Кількіст вибірок')
ylabel(s)

figure
subplot(2,1,1)
plot(nt2.*180./pi)
axis([0 3500 -120 -50])
hold
plot(nt22.*180./pi, '--r')
grid
s = sprintf('Кут, %c', char(176));
xlabel('Кількіст вибірок')
ylabel(s)

subplot(2,1,2)
plot(nt22.*180./pi-nt2.*180./pi, '--r')
axis([0 3500 -20 20])
grid
s = sprintf('Помилка, %c', char(176));
xlabel('Кількіст вибірок')
ylabel(s)