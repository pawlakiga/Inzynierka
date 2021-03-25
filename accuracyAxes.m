degrees = 4:2:20; 
acDeg  = zeros(length(degrees)^2,3); 


cropParams = 0.5 : 0.1 : 0.9 ;
acP = zeros(length(cropParams),3); 

minxcmaxs1 = 0.1 : 0.1 : 0.6;
minxcmaxs2 = 0.4 : 0.1 : 0.9;
minxcmaxs3 = 0.5 : 0.1 : 0.9; 
acM = zeros(length(minxcmaxs1)*length(minxcmaxs2)*length(minxcmaxs3),3); 



for i = 1 : 3 
     
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
    k = 1; m = 1 ; n = 1; 

    for minxcmax1 = minxcmaxs1 
        for minxcmax2 = minxcmaxs2
            for minxcmax3 = minxcmaxs3 
                acM(k,i) = getAccuracyAxes(mV,tV,mRN,tRN,[d,d,d],cP,0.6,1.5,[minxcmax1,minxcmax2,minxcmax3]); 
                k = k + 1 ;
            end
        end
    end
    
    [maxac,maxi] = max(acM(:,i)); 
    bestminxcmax = minxcmaxs(maxi); 
    
    degshis = zeros(length(degrees)^2,3); 
    for deg1 = degrees
        for deg2 = degrees 
            if i == 2 
                degs = [deg1,deg2,d]; 
                degshis(m,:) = degs;
                acDeg(m,i) = getAccuracyAxes(mV,tV,mRN,tRN,degs,cP,0.6,1.5,bestminxcmax); 
                m = m + 1 ; 
            else 
                degs = [deg1,d,deg2]; 
                degshis(m,:) = degs;
                acDeg(m,i) = getAccuracyAxes(mV,tV,mRN,tRN,degs,cP,0.6,1.5,bestminxcmax); 
                m = m + 1 ; 
            end
            
        end
    end
    
    [maxacd,maxid] = max(acDeg(:,i)); 
    bestdegs = degshis(maxid,:);
    
    for cPP = cropParams 
        acP(n,i) = getAccuracyAxes(mV,tV,mRN,tRN,bestdegs,cPP,0.6,1.5,bestminxcmax); 
        n = n + 1;  
    end
    
end