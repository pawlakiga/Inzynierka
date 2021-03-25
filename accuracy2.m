%% Testowanie dok³adnoœci licznika powtórzeñ 


[mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E1','Iga') ; 

maxDeg  = 20 ; maxCrop = 0.9 ; 
ac = zeros(maxDeg-4); 

for deg = 5 : maxDeg
       ac(deg-4) = getAccuracy(mV,tV,mRN,tRN,deg,cP,a);  
end
%%
ac2 = zeros((maxCrop-0.5)*10,1); 
deg = 13 ; 
for cropParam = 0.5 :0.1: maxCrop 
    ac2(cropParam*10-4) = getAccuracy(mV,tV,mRN,tRN,deg,cropParam,a);  
end
%%
ex = ['E1','E2','E3'] ; 
acDeg = zeros(maxDeg-4,3); %acCrop = zeros(maxCrop*10-4,3);  
for i = 3 : 3
    if i == 1 
        [mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E1','Iga') ;
    else 
        if i == 2
            [mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E2','Iga') ;
        else 
            [mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E3','Iga') ;
        end
    end
        
    for deg = 5 : maxDeg
       acDeg(deg-4,i) = getAccuracy(mV,tV,mRN,tRN,deg,cP,a,0.7,1.5);  
    end
%     for cropParam = 0.5 :0.1: maxCrop 
%         ac2(cropParam*10-4,i) = getAccuracy(mV,tV,mRN,tRN,d,cropParam,a,0.7,1.5);  
%     end
    
   
    
end
%%
clear
acL = zeros(5,10,3); 

for i = 3 : 3 
    
    if i == 1 
        [mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E1','Iga') ;
    else 
        if i == 2
            [mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E2','Iga') ;
        else 
            [mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E3','Ewelina') ;
        end
    end
    
    for minLength = 0.4 : 0.1 : 0.5
        for maxLength = 1.5:0.1:1.5
            acL(round(minLength*10-3),round(maxLength*10-10),i) = getAccuracy(mV,tV,mRN,tRN,d,cP,a,minLength,1.5);  
        end
    end
end
%%
[mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E3','Iga') ;


