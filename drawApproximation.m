function []  = drawApproximation (xcorrs, ax)

figure
[as12, min12] = squareApproximation(xcorrs(:,ax),0);
stairs(xcorrs(:,ax)); 
hold on 
plot(as12); 
title(sprintf('E = %2f',min12))


end