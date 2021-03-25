
[lambda,P] = getData2(); 

figure
for i = 1 : 12 
    plot(lambda,P(:,i))
    hold on
end

Temp = [85.6	81.7	70.7	61.5	51.6	41.9	31.6	21.5	17.5	13	10.9	20.4]

legend('T = 85,6','T = 41,9','T = 20,4')
title('Rodzina charakterystyk spektralnych')
xlabel('D³ugoœæ fali') 
ylabel('P [dB]')
%%
lB = min(P) 

figure 
plot(Temp,lB); 
title('Zmiany d³ugoœci fali Bragga')
xlabel('Temperatura $[^{\circ}C]$','interpreter','latex') 
ylabel('$\lambda_{B}$ [nm]')

