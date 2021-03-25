function [accuracy,xcorrs] = getAccuracy(allModelValues,allTestValues,modelRepsNo,testRepsNo,degree,cropParam,ax,minLength,maxLength)

fs = 100 ; 
fmin = 0.01; 
allModelValues = lowpass(allModelValues,fmin,fs);
allTestValues = lowpass(allTestValues,fmin,fs);

repsNo  = modelRepsNo ;

modelValues  = allModelValues(:,ax); 
testValues = allTestValues(:,ax) ; 

[starts,ends, bestRange, bestEpsilon] = getRepsMinVar(allModelValues, repsNo) ;

modelRep = selectRepForModel(modelValues,starts,ends); 
%przycinanie powtórzenia modelowego 
cropstart = round(length(modelRep)*(1-cropParam)/2); cropend = round(length(modelRep)-cropstart); 
modelRepCropped = modelRep(cropstart:cropend); 

polyModel = AxisPolyModel(modelRepCropped,ax, degree, bestRange, bestEpsilon) ; 

[s,e,xcorrs] = countAndCompareCropped(allTestValues, polyModel, minLength/cropParam*polyModel.sourceLength, maxLength/cropParam*polyModel.sourceLength, 0.9);
% 
% plot((0:length(testValues)-1)./100,testValues,'Color','#7E2F8E');
% hold on
% ax = gca;
% ax.XAxis.Limits = [0 (length(testValues)-1)/100];
% for i = 1 : length(e) 
% %     xline(s(i)/100,'k--');
% %     xline(e(i)/100,'r--'); 
%     x = [s(i)/100 e(i)/100  e(i)/100 s(i)/100];
%     y = [ax.YAxis.Limits(1),ax.YAxis.Limits(1),ax.YAxis.Limits(2),ax.YAxis.Limits(2)];
%      patch(x,y,[1,1,.9]); 
% end
% plot((0:length(testValues)-1)./100,testValues,'Color','#7E2F8E');
% legend('Os Y','interpreter','latex');  
% xlabel('Czas $[s]$','interpreter','latex'); ylabel('Predkosc katowa $[\frac{\deg}{s}]$','interpreter','latex'); 
% hold off

accuracy = 1 - abs(length(s) - testRepsNo)/testRepsNo; 

end