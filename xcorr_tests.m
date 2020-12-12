sinn = @ (x) sin (x) ; 
sin2 = @ (x) sin (x+3.14/4); 
sixx1 = sinn(0:0.01:2*3.14);
sixx2 = sin2((0:0.01:2*3.14)); 
xc = xcorr(sixx1,sixx2,'normalized'); 
axc = xcorr(sixx1,sixx1,'normalized'); 
plot(sixx1) 
hold on
plot(sixx2)
figure
plot(-length(sixx1)+1:1:length(sixx1)-1,xc)
hold on
plot(-length(sixx1)+1:1:length(sixx1)-1,axc)
axis([-629 628 min(xc)-0.1 max(xc)+0.1])


