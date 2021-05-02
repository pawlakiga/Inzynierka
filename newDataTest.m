%%
mfilename = 'Odczyty/E2/Ewelina/01-May-2021/Gyro_1.txt'; 
e2em = readValues(mfilename); 
tfilename = 'Odczyty/E2/Ewelina/01-May-2021/Gyro_2.txt';
e2et = readValues(tfilename);
plot(e2et(1:3000,3));
%%
m3filename = 'Odczyty/E3/Ewelina/01-May-2021/Gyro_1.txt'; 
e3em = readValues(m3filename); 
t3filename = 'Odczyty/E3/Ewelina/01-May-2021/Gyro_2.txt';
e3et = readValues(t3filename);
plot(e3et(:,2));
%%
[ac,xcorrs1,xcorrs2,starts,ends]= getAccuracy(e3em,e3et(1:end-300,:),5,44,11,0.85,2,0.7,1.5); 
%%
drawApproximation(xcorrs1, 2); 
drawApproximation(xcorrs2, 2); 
%%
s = starts ; e = ends;
etV = e3et(:,2);    
plot((0:length(etV)-1)./100,etV,'Color','#7E2F8E');
hold on
ax = gca;
ax.XAxis.Limits = [0 (length(etV)-1)/100];
for i = 1 : length(e) 
%     xline(s(i)/100,'k--');
%     xline(e(i)/100,'r--'); 
    x = [s(i)/100 e(i)/100  e(i)/100 s(i)/100];
    y = [ax.YAxis.Limits(1),ax.YAxis.Limits(1),ax.YAxis.Limits(2),ax.YAxis.Limits(2)];
     patch(x,y,[1,1,.9]); 
end
plot((0:length(etV)-1)./100,etV,'Color','#7E2F8E');
legend('Os Y','interpreter','latex');  
xlabel('Czas $[s]$','interpreter','latex'); ylabel('Predkosc katowa $[\frac{\deg}{s}]$','interpreter','latex'); 
hold off
