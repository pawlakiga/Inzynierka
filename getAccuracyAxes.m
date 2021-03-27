function [accuracy,xcorrs,s,e] = getAccuracyAxes(allModelValues,allTestValues,modelRepsNo,testRepsNo,degrees,cropParam,minLength,maxLength,minxcmax)

fs = 100 ; 
fmin = 0.01; 
allModelValues = lowpass(allModelValues,fmin,fs);
allTestValues = lowpass(allTestValues,fmin,fs);

repsNo  = modelRepsNo ;

[starts,ends, bestRange, bestEpsilon] = getRepsMinVar(allModelValues, repsNo) ;

modelRep = selectRepForModelAxes(allModelValues,starts,ends); 
%przycinanie powtórzenia modelowego 
cropstart = round(length(modelRep)*(1-cropParam)/2); cropend = round(length(modelRep)-cropstart); 
modelRepCropped = modelRep(cropstart:cropend,:); 

polyModel = PolyModel(modelRepCropped, degrees, bestRange, bestEpsilon) ; 

[s,e,xcorrs] = countAndCompareCroppedAxes(allTestValues, polyModel, minLength/cropParam*polyModel.sourceLength, maxLength/cropParam*polyModel.sourceLength, minxcmax);

accuracy = 1 - abs(length(s) - testRepsNo)/testRepsNo; 

figure
plot(allTestValues) ; 
for r = 1 : length(s) 
    xline(s(r),'g') ; 
    xline(e(r),'r'); 
end

end