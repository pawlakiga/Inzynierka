function [] = figuresForMeasurmentsv2(exercise, allModelValues, allTestValues, testDisplayStart, testDisplayEnd,saving)

if strcmp(exercise, 'E1')
   exerciseName = 'przysiady' ;
else
    if strcmp(exercise, 'E2')
        exerciseName = 'pompki' ;
    else
        if strcmp(exercise, 'E3')
            exerciseName = 'pajacyki';
        else
            if strcmp(exercise, 'E5')
                exerciseName = 'brzuszki';
            end
        end
    end
end


allTestValues = allTestValues(testDisplayStart*length(allTestValues):testDisplayEnd*length(allTestValues),:)


mkdir('Wykresy/Pomiary')
fig = figure;

subplot(3,1,1)
plot((0:length(allModelValues)-1)./100,allModelValues(:,1),'Color','#D95319');
ax = gca;
ax.XAxis.Limits = [0 (length(allModelValues)-1)/100];
legend('Oœ X','interpreter','latex'); 
xlabel('Czas $[s]$','interpreter','latex');  
title(sprintf('Pomiar modelowy prêdkoœci - %s',exerciseName),'interpreter','latex')

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
saveas(fig,strcat('Wykresy/Pomiary2/',exercise,'_model','.pdf'))
matlab2tikz(strcat('Wykresy/Pomiary2/Tikz_',exercise,'_model','.tex'))
end
% 
% fig2 = figure; 
% plot((0:length(allTestValues)-1)./100,allTestValues);
% legend('Oœ X','Oœ Y','Oœ Z','interpreter','latex'); 
% title(strcat('Pomiar testowy predkosci - ',exerciseName),'interpreter','latex')
% xlabel('Czas $[s]$','interpreter','latex'); ylabel('Predkosc katowa $[\frac{m}{s}]$','interpreter','latex');
% ax = gca; 
% ax.XAxis.Limits = [0 (length(allTestValues)-1)/100];

fig2 = figure;

subplot(3,1,1)
plot((0:length(allTestValues)-1)./100,allTestValues(:,1),'Color','#D95319');
legend('Oœ X','interpreter','latex'); 
xlabel('Czas $[s]$','interpreter','latex');  
title(sprintf('Pomiar testowy prêdkoœci - %s',exerciseName),'interpreter','latex')
ax = gca;
ax.XAxis.Limits = [0 (length(allTestValues)-1)/100];

subplot(3,1,2)

plot((0:length(allTestValues)-1)./100,allTestValues(:,2),'Color','#7E2F8E');
legend('Oœ Y','interpreter','latex');  
xlabel('Czas $[s]$','interpreter','latex'); ylabel('Predkosc katowa $[\frac{\deg}{s}]$','interpreter','latex'); 
ax = gca;
ax.XAxis.Limits = [0 (length(allTestValues)-1)/100];
subplot(3,1,3)

plot((0:length(allTestValues)-1)./100,allTestValues(:,3),'Color','#91E478');
legend('Oœ Z','interpreter','latex');  
xlabel('Czas $[s]$','interpreter','latex'); 
ax = gca;
ax.XAxis.Limits = [0 (length(allTestValues)-1)/100];
if saving == 1 
saveas(fig2,strcat('Wykresy/Pomiary2/',exercise,'_test','.pdf'))
matlab2tikz(strcat('Wykresy/Pomiary2/Tikz_',exercise,'_test','.tex'))
end
end