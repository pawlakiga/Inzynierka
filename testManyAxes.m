
for i = 1 : 1
    if i == 1 
        [mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E1','Iga') ;
        ex = 'E1';
    else 
        if i == 2
            [mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E2','Iga') ;
            ex = 'E2';
        else 
            [mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E3','Iga') ;
            ex = 'E3';
        end
    end
    fs = 100 ; 
    fmin = 0.01; 
    allModelValues = lowpass(mV,fmin,fs);
    allTestValues = lowpass(tV,fmin,fs);

    repsNo  = mRN ;

    modelValues  = allModelValues(:,1); 
    testValues = allTestValues(:,1) ; 

    [starts,ends, bestRange, bestEpsilon] = getRepsMinVar(allModelValues, repsNo) ;

    plotReps(allModelValues,starts,ends,ex,'Iga'); 
    
end

%%
cropParam = cP;
modelRep = selectRepForModelAxes(allModelValues,starts,ends); 
plot(modelRep)

%przycinanie powtórzenia modelowego 
cropstart = round(length(modelRep)*(1-cropParam)/2); cropend = round(length(modelRep)-cropstart); 
modelRepCropped = modelRep(cropstart:cropend,:); 
plot(modelRepCropped);
%%

polyModel = PolyModel(modelRepCropped, [15,d,15], bestRange, bestEpsilon) ; 

pp = polyModel.evalPoly(modelRepCropped);
plot (modelRepCropped(:,3),'r')
hold on
plot(pp(:,3),'b')
%%
[s,e] = countAndCompareCroppedAxes(allTestValues, polyModel, 0.7/cropParam*polyModel.sourceLength, 1.5/cropParam*polyModel.sourceLength, 0.5);
%% 
plot(allTestValues)