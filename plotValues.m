function [] = plotValues(values,exercise_name, type) 
figure 
today = date; 
plot(values(1:end,1),'g'); 
hold on
plot(values(1:end,2),'m'); 
plot(values(1:end,3),'b'); 
space = ' '; 
t = strcat('Odczyty wielkosci: ', type ,',',' �wiczenie: ',exercise_name);
title(t); 
xlabel('Czas'); ylabel(type); 
legend('O� X','O� Y','O� Z','location','northwest'); 
end