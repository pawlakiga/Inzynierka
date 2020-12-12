pajacykiModel = readValues('Odczyty/E3/Ewelina/30-Nov-2020/Gyro_1.txt'); 
%%
plotValues(pajacykiModel,'Pajacyki','Gyro');
%%

getMostSensitiveAxis(pajacykiModel);
%%
modelValues2 = pajacykiModel;
ranges = 5:5:30; epsilons = [2:20;2:20;2:20]; 
results2  = zeros(length(ranges),length(epsilons)); 
for range = ranges 
    for epsilon = epsilons 
        if epsilon(1) == 3 && range == 10 
            kupa = 1 ; 
        end
        [s2,e2] = getReps(modelValues2,range,epsilon);
        [s2,e2] = deleteNoiseReps(s2,e2);
        
        results2(range/5,epsilon) = length(e2); 
        if length(e2) == 6
            figure
            lengths = e2 - s2 ; 
            varr = var(lengths); 
            for i = 1 : length(e2)
                plot(modelValues2(s2(i):e2(i),2))
                hold on
            end
            title(sprintf('Range = %d, epsilon = %d, var = %.2f',range,epsilon(1),varr))
            hold off
        end
    end
end

%% 
[ps,pe] = getRepsMinVar(pajacykiModel,6); 
l = strings(1,length(ps));
for i = 1 : length(ps)
    plot(modelValues2(ps(i):pe(i),2))
    hold on
    l(i) = sprintf('Rep. %d',i); 
end
legend(l)
%%
ax = getMostSensitiveAxis(pajacykiModel);
modelValues = pajacykiModel(:,ax); 
modelRep = selectRepForModel(modelValues,ps,pe); 
%%
for degree = 18:2:28
    pModel = AxisPolyModel(modelRep, degree) ;
    l = strings(1,length(ps));
    for i = 1 :length(ps)
        currRep = modelValues(ps(i):pe(i)); 
        pmRep = pModel.evalPoly(currRep); 
        xc = xcorr(currRep,pmRep); 
%         plot(xc); 
%         l(i) = sprintf('Rep. %d',i);
%         hold on 
        plot(currRep);
        hold on;
        plot(pmRep); 
        hold off
    end
%     legend(l); 
%     hold off
end





%%
repsE = zeros(length(18:2:28),length(ps)); 
for degree = 18:2:28
  prep = pajacykiModel(ps(2):pe(2),ax); 
  pm = AxisPolyModel(prep,degree);   
  pp  = pm.evalPoly(prep) ;
  E = (pp- prep')*(pp'-prep);
  figure
  for repp = 1 : length(ps) 
    pprep = pajacykiModel(ps(repp):pe(repp),ax); 
    polyrep = pm.evalPoly(pprep) ;
    repsE((degree-18)/2+1,repp) = (polyrep-pprep')*(polyrep'-pprep);       
    plot(pprep,'b'); 
    hold on
    plot(polyrep,'g'); 
    hold off
    title(sprintf('Degree = %d, E = %.2f',degree,E))
  end
%   figure
%    plot(pajacykiModel(ps(2):pe(2),ax),'b'); 
%     hold on
%     plot(pp,'g'); 
%     hold off
%     title(sprintf('Degree = %d, E = %.2f',degree,E))
end



%%
[ps,pe] = getReps(pajacykiModel,5,[20,20,20]); 
[ps,pe] = deleteNoiseReps(ps,pe); 
ax = getMostSensitiveAxis(pajacykiModel); 
pajacykiPoly = AxisPolyModel(pajacykiModel(ps(2):pe(2),ax),25);
pajacykiPolyRep  = pajacykiPoly.evalPoly(pajacykiModel(ps(3):pe(3),ax)) ;
plot(pajacykiModel(ps(3):pe(3),ax),'m'); 
hold on
plot(pajacykiModel(ps(2):pe(2),ax),'b'); 
hold on
plot(pajacykiPolyRep,'g'); 




%%
polyModel = AxisPolyModel(modelRep,22); 
testValues = readValues('Odczyty/E3/Ewelina/30-Nov-2020/Gyro_2.txt'); 
plotValues(testValues,'Pajacyki','Prêdkoœæ') ; 
%%
plot(testValues(:,ax)); 
testValues2 = readValues('Odczyty/E3/Ewelina/30-Nov-2020/Gyro_3.txt'); 
figure
plot(testValues2(:,ax));
%%
plot(xcorr(testValues(:,ax),testValues(:,ax),'normalized')) ; 


