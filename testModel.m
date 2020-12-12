%%
values = readValues('Odczyty\Nieokreœlone\Przysiady_prawa_dlon_06-Nov-2020_1'); 
%%
plotValues(values,length(values),'Przysiady','Prêdkoœæ'); 
%% 
rep1 = values(581:752,1:end); 
rep1Y = rep1(1:end,2); 
[poly1Y,S1Y] = polyRepModel(rep1Y); 
%% 
rep1Ypoly = polyval(poly1Y,1:length(rep1Y))
%%
figure
plot(rep1Ypoly,'g'); 
hold on
plot(rep1Y'); 
%% 
rep2 = values(752:908,1:end);
rep2Y = rep2(1:end,2); 
rep3Y = values(1955:2125,2); 
rep0Y = values(2708:2886,2); 
rep1poly0 = polyval(poly1Y,1:length(rep0Y)); 
rep1poly2 = polyval(poly1Y,1:length(rep2Y)); 
figure
plot(rep2Y,'r');
hold on 
plot(rep1poly2,'g'); 
plot(rep0Y,'k'); 
rep1poly3 = polyval(poly1Y,1:length(rep3Y)); 
plot(rep1poly3,'m'); 
plot(rep3Y,'b');
figure 
plot(xcorr(rep1poly2,rep2Y),'b'); 
hold on
plot(xcorr(rep1poly0,rep0Y),'k'); 
plot(xcorr(rep1poly3,rep3Y),'g');
plot(xcorr(rep1Ypoly,rep1Y),'m'); 
figure
plot(xcorr(xcorr(rep1poly0,rep0Y),xcorr(rep1Ypoly,rep1Y)),'b')
hold on
plot(xcorr(xcorr(rep1poly2,rep2Y),xcorr(rep1Ypoly,rep1Y)),'k')
plot(xcorr(xcorr(rep1poly3,rep3Y),xcorr(rep1Ypoly,rep1Y)),'c')
%% 



