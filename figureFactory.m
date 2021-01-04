values1 = readValues('Odczyty/E2/Iga/21-Dec-2020/Gyro_1.txt' ) ; 
values2 = readValues('Odczyty/E2/Iga/21-Dec-2020/Gyro_2.txt' ) ; 
values3 = readValues('Odczyty/E2/Iga/21-Dec-2020/Gyro_3.txt' ) ; 
values4 = readValues('Odczyty/E2/Iga/29-Dec-2020/Gyro_1.txt' ) ; 
%% 1. Wczytanie wartoœci z plików 
mkdir('Wykresy/E1')
% E1 Przysiady 

allModelValues1 = readValues('Odczyty/E1/Iga/30-Dec-2020/Gyro_1.txt' ) ;
allTestValues1 = readValues('Odczyty/E1/Iga/30-Dec-2020/Gyro_2.txt' ) ; 
e1fig = figure;
plot((0:length(allModelValues1)-1)./100,allModelValues1);
legend('Os X','Os Y','Os Z','interpreter','latex');  
title('Pomiar modelowy predkosci - przysiady','interpreter','latex')
xlabel('Czas $[s]$','interpreter','latex'); ylabel('Predkosc katowa $[\frac{m}{s}]$','interpreter','latex'); 
ax = gca; 
ax.XAxis.Limits = [0 (length(allModelValues1)-1)/100];
saveas(e1fig,'Wykresy/E1/model_pomiar.pdf')
%%
e2fig = figure; 
plot((0:63929)./100,allTestValues1(1:63930,:));
legend('Oœ X','Oœ Y','Oœ Z','interpreter','latex','location','best'); 
title('Pomiar testowy predkosci - przysiady','interpreter','latex')
xlabel('Czas $[s]$','interpreter','latex'); ylabel('Predkosc katowa $[\frac{m}{s}]$','interpreter','latex');
ax = gca; 
ax.XAxis.Limits = [0 63929/100];
saveas(e2fig,'Wykresy/E1/test_pomiar.pdf')

%% 
mkdir('Wykresy/E2')
% E2 Pompki 

allModelValues2 = readValues('Odczyty/E2/Iga/21-Dec-2020/Gyro_1.txt' ) ;
allTestValues2 = readValues('Odczyty/E2/Iga/29-Dec-2020/Gyro_1.txt' ) ; 
e1fig = figure;
plot((0:length(allModelValues2)-1000)./100,allModelValues2);
legend('Os X','Os Y','Os Z','interpreter','latex');  
title('Pomiar modelowy predkosci - pompki','interpreter','latex')
xlabel('Czas $[s]$','interpreter','latex'); ylabel('Predkosc katowa $[\frac{m}{s}]$','interpreter','latex'); 
ax = gca; 
ax.XAxis.Limits = [0 (length(allModelValues2)-1000)/100];
saveas(e1fig,'Wykresy/E2/model_pomiar.pdf')
%%
e2fig = figure; 
plot((0:63929)./100,allTestValues2(1:63930,:));
legend('Oœ X','Oœ Y','Oœ Z','interpreter','latex','location','best'); 
title('Pomiar testowy predkosci - przysiady','interpreter','latex')
xlabel('Czas $[s]$','interpreter','latex'); ylabel('Predkosc katowa $[\frac{m}{s}]$','interpreter','latex');
ax = gca; 
ax.XAxis.Limits = [0 63929/100];
saveas(e2fig,'Wykresy/E1/test_pomiar.pdf')


%% 
mkdir('Wykresy/Pomiary2');
addpath("C:\Users\Iga\Downloads\matlab2tikz-matlab2tikz-v1.1.0-82-gf299888\matlab2tikz-matlab2tikz-f299888\src");
allModelValues = readValues('Odczyty/E1/Iga/30-Dec-2020/Gyro_1.txt' ) ;
allTestValues = readValues('Odczyty/E1/Iga/30-Dec-2020/Gyro_2.txt' ) ; 
allTestValues = allTestValues(1:63930,:);
figuresForMeasurmentsv2('E1',allModelValues,allTestValues,0.2,0.25,1)
%%
allModelValues = readValues('Odczyty/E2/Iga/21-Dec-2020/Gyro_1.txt' ) ;
allModelValues = allModelValues(1:2000,:); 
allTestValues = readValues('Odczyty/E2/Iga/29-Dec-2020/Gyro_1.txt' ) ; 
figuresForMeasurmentsv2('E2',allModelValues,allTestValues,0.2,0.4,0)

%% 
allModelValues = readValues('Odczyty/E5/Iga/26-Dec-2020/Gyro_1.txt' ) ;
%allModelValues = allModelValues(1:2000,:); 
allTestValues = readValues('Odczyty/E5/Iga/26-Dec-2020/Gyro_4.txt' ) ; 
figuresForMeasurmentsv2('E5',allModelValues,allTestValues,0.2,0.25,1)

%% 2. Wstêpna obróbka danych 
allModelValues = readValues('Odczyty/E1/Iga/30-Dec-2020/Gyro_1.txt' ) ;
allTestValues = readValues('Odczyty/E1/Iga/30-Dec-2020/Gyro_2.txt' ) ; 
%%
allTestValues = lowpass(allTestValues(1:63930,:),0.1,100);
allModelValues = lowpass(allModelValues,0.1,100);

exerciseName = 'przysiady'; 
exercise = 'E1'; 
saving = 1 ; 
figuresForMeasurmentsv2('E1',allModelValues,allTestValues,0.2,0.25,1)
%%
fig = figure;

subplot(3,1,1)
plot((0:length(allModelValues)-1)./100,allModelValues(:,1),'Color','#D95319');
ax = gca;
ax.XAxis.Limits = [0 (length(allModelValues)-1)/100];
legend('Oœ X','interpreter','latex'); 
xlabel('Czas $[s]$','interpreter','latex');  
title(strcat('Dane modelowe po filtracji - ',' ',exerciseName),'interpreter','latex')

subplot(3,1,2)
plot((0:length(allModelValues)-1)./100,allModelValues(:,2),'Color','#7E2F8E');
legend('Oœ Y','interpreter','latex');  
xlabel('Czas $[s]$','interpreter','latex'); ylabel('Predkosc katowa $[\frac{\deg}{s}]$','interpreter','latex'); 
ax = gca;
ax.XAxis.Limits = [0 (length(allModelValues)-1)/100];

subplot(3,1,3)
plot((0:length(allModelValues)-1)./100,allModelValues(:,3),'Color','#91E478');
legend('Oœ Z','interpreter','latex');  
xlabel('Czas $[s]$','interpreter','latex'); 
ax = gca;
ax.XAxis.Limits = [0 (length(allModelValues)-1)/100]; 
if saving == 1
saveas(fig,strcat('Wykresy/Pomiary2/',exercise,'_model_filter','.pdf'))
matlab2tikz(strcat('Wykresy/Pomiary2/Tikz_',exercise,'_model_filter','.tex'))
end
%%
fig2 = figure;

subplot(3,1,1)
plot((0:length(allTestValues)-1)./100,allTestValues(:,1),'Color','#D95319');
legend('Oœ X','interpreter','latex'); 
xlabel('Czas $[s]$','interpreter','latex');  
title(strcat('Dane testowe po filtracji -    ',' ',exerciseName),'interpreter','latex')
ax = gca;
ax.XAxis.Limits = [(testDisplayStart*length(allTestValues)-1)/100 (testDisplayEnd*length(allTestValues)-1)/100];
subplot(3,1,2)

plot((0:length(allTestValues)-1)./100,allTestValues(:,2),'Color','#7E2F8E');
legend('Oœ Y','interpreter','latex');  
xlabel('Czas $[s]$','interpreter','latex'); ylabel('Predkosc katowa $[\frac{\deg}{s}]$','interpreter','latex'); 
ax = gca;
ax.XAxis.Limits = [(testDisplayStart*length(allTestValues)-1)/100 (testDisplayEnd*length(allTestValues)-1)/100];
subplot(3,1,3)

plot((0:length(allTestValues)-1)./100,allTestValues(:,3),'Color','#91E478');
legend('Oœ Z','interpreter','latex');  
xlabel('Czas $[s]$','interpreter','latex'); 
ax = gca;
ax.XAxis.Limits = [(testDisplayStart*length(allTestValues)-1)/100 (testDisplayEnd*length(allTestValues)-1)/100];
if saving == 1 
saveas(fig2,strcat('Wykresy/Pomiary2/',exercise,'_test_filter','.pdf'))
matlab2tikz(strcat('Wykresy/Pomiary2/Tikz_',exercise,'_test_filter','.tex'))
end

%% 3.1 Wycinanie powtórzeñ 
allModelValues = readValues('Odczyty/E1/Iga/30-Dec-2020/Gyro_1.txt' ) ; 
allTestValues = readValues('Odczyty/E1/Iga/30-Dec-2020/Gyro_2.txt' ) ; 

fs = 100 ; 
fmin = 0.01; 
allModelValues = lowpass(allModelValues,fmin,fs);
allTestValues = lowpass(allTestValues,fmin,fs);

repsNo  = 5 ;
ax = 2 ; 

[starts,ends, bestRange, bestEpsilon] = getRepsMinVar(allModelValues, repsNo) ;

%% 
mkdir('Wykresy/3')
fig = figure; 
exercise = 'E1'; 
l = strings(1,length(ends));
for i = 1 : length(ends) 
    plot((0:(ends(i)-starts(i)))./100,modelValues(starts(i):ends(i)));
    hold on
    l(i) = sprintf('Powtórzenie %d',i); 
end
legend(l)
title('Znalezione powtórzenia')
ax = gca ; ax.XAxis.Limits = [0 max(ends-starts)/100];
hold off 
xlabel('Czas $[s]$','interpreter','latex'); ylabel('Prêkoœæ k¹towa $[\frac{\deg}{s}]$','interpreter','latex'); 
matlab2tikz(strcat('Wykresy/3/Tikz_',exercise,'_reps','.tex'))
saveas(fig,strcat('Wykresy/3/',exercise,'__reps','.pdf'))

%% 
