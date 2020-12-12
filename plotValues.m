function [] = plotValues(values,exercise_name, type) 
figure 
today = date; 
plot(values(1:end,1),'g'); 
hold on
plot(values(1:end,2),'m'); 
plot(values(1:end,3),'b'); 
space = ' '; 
t = strcat('Odczyty wielkosci: ', type ,',',' Æwiczenie: ',exercise_name);
title(t); 
xlabel('Czas'); ylabel(type); 
legend('Oœ X','Oœ Y','Oœ Z','location','northwest'); 
end