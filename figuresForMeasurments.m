function [] = figuresForMeasurments(exercise, allModelValues, allTestValues)

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

mkdir('Wykresy/Pomiary')
fig = figure;
plot((0:length(allModelValues)-1)./100,allModelValues);
legend('Os X','Os Y','Os Z','interpreter','latex');  
title(strcat('Pomiar modelowy predkosci - ',exerciseName),'interpreter','latex')
xlabel('Czas $[s]$','interpreter','latex'); ylabel('Predkosc katowa $[\frac{m}{s}]$','interpreter','latex'); 
ax = gca; 
ax.XAxis.Limits = [0 (length(allModelValues)-1)/100];
saveas(fig,strcat('Wykresy/Pomiary/',exercise,'_model','.pdf'))
matlab2tikz(strcat('Wykresy/Pomiary/Tikz_',exercise,'_model','.tex'))
fig2 = figure; 
plot((0:length(allTestValues)-1)./100,allTestValues);
legend('Oœ X','Oœ Y','Oœ Z','interpreter','latex'); 
title(strcat('Pomiar testowy predkosci - ',exerciseName),'interpreter','latex')
xlabel('Czas $[s]$','interpreter','latex'); ylabel('Predkosc katowa $[\frac{m}{s}]$','interpreter','latex');
ax = gca; 
ax.XAxis.Limits = [0 (length(allTestValues)-1)/100];
saveas(fig2,strcat('Wykresy/Pomiary/',exercise,'_test','.pdf'))
matlab2tikz(strcat('Wykresy/Pomiary/Tikz_',exercise,'_test','.tex'))
end