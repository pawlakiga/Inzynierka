function [] = figuresForGetReps(values,s,e,range,epsilon,varr,saving)
addpath("C:\Users\Iga\Downloads\matlab2tikz-matlab2tikz-v1.1.0-82-gf299888\matlab2tikz-matlab2tikz-f299888\src");
fig = figure;
filename = sprintf('Wykresy/Wycinanie/r%d_e%d',range,epsilon); 
vlinesfile = fopen(filename); 
subplot(3,1,1)
plot((0:length(values)-1)./100,values(:,1),'Color','#D95319');
hold on 
ax = gca;
ax.XAxis.Limits = [0 (length(values)-1)/100];
for i = 1 : length(e) 
%     xline(s(i)/100,'k--');
%     xline(e(i)/100,'r--'); 
    x = [s(i)/100 e(i)/100  e(i)/100 s(i)/100];
    y = [ax.YAxis.Limits(1),ax.YAxis.Limits(1),ax.YAxis.Limits(2),ax.YAxis.Limits(2)];
    patch(x,y,[1,1,.9]); 
end
plot((0:length(values)-1)./100,values(:,1),'Color','#D95319');
legend('Os X','interpreter','latex'); 
xlabel('Czas $[s]$','interpreter','latex');  
title(sprintf('Odcinki z odczytami ruchu dla $r = %d$, $\\epsilon = %d$,$V = %.2f$',range,epsilon(1),varr),'interpreter','latex')

subplot(3,1,2)
plot((0:length(values)-1)./100,values(:,2),'Color','#7E2F8E');
hold on
ax = gca;
ax.XAxis.Limits = [0 (length(values)-1)/100];
for i = 1 : length(e) 
%     xline(s(i)/100,'k--');
%     xline(e(i)/100,'r--'); 
    x = [s(i)/100 e(i)/100  e(i)/100 s(i)/100];
    y = [ax.YAxis.Limits(1),ax.YAxis.Limits(1),ax.YAxis.Limits(2),ax.YAxis.Limits(2)];
     patch(x,y,[1,1,.9]); 
end
plot((0:length(values)-1)./100,values(:,2),'Color','#7E2F8E');
legend('Os Y','interpreter','latex');  
xlabel('Czas $[s]$','interpreter','latex'); ylabel('Predkosc katowa $[\frac{\deg}{s}]$','interpreter','latex'); 
hold off

subplot(3,1,3)
plot((0:length(values)-1)./100,values(:,3),'Color','#91E478');
hold on
ax = gca;
ax.XAxis.Limits = [0 (length(values)-1)/100]; 
for i = 1 : length(e) 
    x = [s(i)/100 e(i)/100  e(i)/100 s(i)/100];
    y = [ax.YAxis.Limits(1),ax.YAxis.Limits(1),ax.YAxis.Limits(2),ax.YAxis.Limits(2)];
    patch(x,y,[1,1,.9]);  
end
plot((0:length(values)-1)./100,values(:,3),'Color','#91E478');
ax.YAxis.Limits = [y(1) y(3)];
legend('Os Z','interpreter','latex');  
xlabel('Czas $[s]$','interpreter','latex'); 

if saving == 1
saveas(fig,sprintf('Wykresy/Wycinanie/r_%d_e_%d.pdf',range,epsilon(1)))
matlab2tikz(sprintf('Wykresy/Wycinanie/Tikz_r_%d_e_%d.tex',range,epsilon(1)))
end



end