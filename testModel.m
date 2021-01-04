
pushups = readValues('Odczyty/Nieokreslone/Przysiady_prawa_dlon_01-Nov-2020_1.txt'); 
values2 = readValues('Odczyty/Nieokreslone/Przysiady_prawa_dlon_06-Nov-2020_1.txt');
nina = readValues('Odczyty/E2/Ewelina/30-Nov-2020/Gyro_1.txt');

figure
plot(pushups(:,2));
figure
plot(values2(:,2));


figure
plot(nina(:,2));

fs = 100 ; 
fmin = 0.01;
pushups = lowpass(pushups,fmin,fs);
values2 = lowpass(values2,fmin,fs); 
nina = lowpass(nina,fmin,fs); 
%%
figure
%plot(pushups(:,2));
% figure
plot(values2(:,2));
axis([1 length(values2) -100 100])
figure
plot(nina(1:length(values2),2));
axis([1 length(values2) -100 100])