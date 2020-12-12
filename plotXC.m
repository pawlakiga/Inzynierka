function [] = plotXC (xc,t)
halfLen = length(xc)/2 - 0.5; 
figure
axis([-halfLen halfLen min(xc)-0.1 1.1])
plot(-halfLen:halfLen, xc) 
xlabel('Przesuniêcie'); ylabel('Korelacja wzajemna'); 
title(t); 
end