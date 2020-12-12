clear 
values = readValues('Odczyty/E1/Iga/19-Nov-2020/Gyro_2.txt')

[s,e] = getReps(values,20,[7;7;7]);
[s,e] = deleteNoiseReps(s,e); 
%%
values2 = values(1:4833,2); 
plot(values2)
figure
axc = xcorr(values2,values2); 
plot(-length(values2)+1:1:length(values2)-1,axc);
%%
figure
for i = 1 : length(e)
    plot(values(s(i):e(i),2))
    hold on
end

%% test model 
rep1 = values(s(1):e(1),1:end); 
rep1Y = rep1(1:end,2); 
[poly1Y,S1Y] = polyRepModel(rep1Y,40); 
rep1Ypoly = polyval(poly1Y,1:length(rep1Y))
% figure
% plot(rep1Ypoly,'g'); 
% hold on
% plot(rep1Y'); 
% 
% for i = 1 : length(s) 
%     newRepY = values(s(i):e(i),2); 
%     rep1Ypoly2 = polyval(poly1Y,1:length(newRepY)); 
%     plot(newRepY); 
%     hold on
%     plot(rep1Ypoly2); 
%     hold on
% 
% end
figure
l = strings(1,length(s));
lengths = e - s;
xc_max = zeros(length(s),1); 
shift = zeros(length(s),1); 
for j = 1:length(s)
    newRepY = values(s(j):e(j),2); 
    rep1Ypoly2 = polyval(poly1Y,1:length(newRepY));
    xc = xcorr(newRepY,rep1Ypoly2,'normalized'); 
    if j == 1 
        xc1 = xc; 
    end
    plot(xcorr(xc,xc1)); 
    hold on
    %plot(xc)
    hold on 
    xc_max(j) = max(xc); 
    shift(j) = find(xc_max(j)) - length(xc)/2 ; 
    l(j) = sprintf('Rep%d',j); 
    hold on
end
legend(l); 

figure 
plot(1:length(s),xc_max/1000); 
hold on
plot(1:length(s),lengths) ;

%% test2

lengths = e - s;
meanLength = round(mean(lengths));
deg = 20;
figure
for i = 1: length(s) 
    repY = values(s(i):e(i),2); 
    [polyY,SY] = polyRepModel(repY,deg);
    lengths(i)
    %repYpoly = polyval(polyY,0:(lengths(i)-1)/meanLength:lengths(i)-1)
    repYpoly = polyval(polyY,0:length(repY)-1); 
    plot(repYpoly); 
    hold on
    plot(repY);
    hold off;
end
%% 

%testValues = readValues('Odczyty/E1/Iga/19-Nov-2020/Gyro_1.txt'); 
%plot(testValues)
minLength = 200; maxLength = 400; 
iBest = 0 ; jBest = 0; xcBest = 0 ; 
% xcmin = 0.7 * xc_max(7); 
shiftTest = 0; 
decrease = 0 ; 
figure
for i = minLength+1 : length(testValues) 
    for j = i - minLength  :-1 : max(i - maxLength,1) 
        if j >0 
            polytest = evalPolyModel(polyY,lengths(7),length(testValues(j:i,2))); 
            xctest = xcorr(testValues(j:i,2), polytest,'normalized'); 
            plot(xctest) 
            axis ([0 length(xctest)-1 -1 1])
            drawnow
            [maxxc,index] = max(xctest);
%             shiftTest = (index - length(xctest)/2)/length(xctest) ;
%             if max(xctest) > xcBest && abs(shiftTest) < 0.3
%                 xcBest = max(xctest); 
%                 if xcBest > xcmin
%                     iBest = i ; jBest = j; 
%                     plot(xctest);
%                     decrease = 1; 
%                 end
%            end
%             if i == 400 && j == 80
%               plot(xctest);
%             end
        end
    end
%     if max(xctest) < xcBest 
%         decrease = decrease*2; 
%     end
%     if decrease == 1024 
%         plot(polytest); 
%         hold on
%         plot(testValues(j:i,2));
%     end
end
%% 

testValues = readValues('Odczyty/E1/Iga/19-Nov-2020/Gyro_1.txt'); 
polymodel = PolyModel(values(s(1):e(1),1:end),[20,20,20]); 
%%
rep2 = values(s(3):e(3),2); 
polyRep2 = polymodel.yPolyModel.evalPoly(rep2); 
plot(rep2); 
hold on 
plot(polyRep2); 
%[k,n] = findRep(testValues,polymodel,200,400);

xcorrelation = xcorr(rep2,polyRep2,'normalized');
%fft1 = fft(xcorrelation); 
figure
plot(xcorrelation); 
figure
xcorrel = xcorr(values(:,2),values(:,2),'normalized') ; 
plot(xcorrel); 

%% 
len = 300; 
count = 1; 
modelValues = readValues('Odczyty/E1/Iga/19-Nov-2020/Gyro_2.txt');

[s,e] = getReps(modelValues,20,[7;7;7]);
[s,e] = deleteNoiseReps(s,e); 

%%
polymodel = AxisPolyModel(values(s(2):e(2),2),20);
imax = []; 
count = 1 ; 
figure
for index  = len + 1 : length(values)
    prep = values(index-len:index,2); 
    pr = polymodel.evalPoly(prep); 
    if ~isempty(imax) && index < imax(end) + 230
        continue
    end
    xc = xcorr(prep,pr,'normalized'); 
    axis([-length(prep)+1 length(prep)-1 -0.8 1.1])
    plot(xc)
   plot(prep); hold on; plot(pr);hold off
    drawnow
    [maxx, i] = max(xc) ; 
%     imxc(index) = i ; 
    if i == length(xc)/2+0.5 && maxx > 0.9
       imax(count) = index ; 
       imxc(count) = maxx; 
       count = count+1; 
    end
end

%% 
xcmaxx = zeros(length(values2),1); 
for index = 1 : length(values2) 
   xc = xcorr(values2(1:index),values2(1:index),'normalized');  
   plot(xc)
   axis([0 2*index-1 -0.5 1.1])
   drawnow
end
%plot(xcmaxx) 
%% 
pushups = readValues('Odczyty/Nieokreœlone/Przysiady_prawa_dlon_01-Nov-2020_1.txt'); 
plot(pushups(:,2)); 
figure 
pushups_xc = xcorr(pushups(:,2),pushups(:,2),'normalized'); 
plot(-length(pushups)+1:1:length(pushups)-1,pushups_xc); 
%% 
pompkiEa = zeros(3000,1); pompkiIa = zeros(3000,1); 
for k = 1 : 3000 
    pompkiEa(k) = -sum(pompkiE(1:k,3)); 
    pompkiIa(k) = sum(pompkiI(1:k,2)); 
end
plot(pompkiEa,'m') ; hold on ; plot(pompkiIa,'b') ; 
%%
 plot(pompkiI(1:end,2))
hold on
plot(pompkiE(1:3000,a))

a = getMostSensitiveAxis(pompkiE)


