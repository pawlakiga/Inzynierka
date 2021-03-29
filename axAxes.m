degrees = [8,14,6; 
           8,14,4;
           12,14,4]; 

cropParams = [0.9,0.7,0.7]; 

minxcmaxs = [0.5, 0.6, 0.9; 0.2, 0.2, 0.6; 0.3, 0.3, 0.9] ;


xcorrs = zeros(220,3,3); 
starts = zeros(220,3) ; 
ends = zeros(220,3);
acc = zeros(1,3); 

for i = 2 : 2
    
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
 
    [acc(i),xcc,s,e] = getAccuracyAxes(mV,tV,mRN,tRN,degrees(i,:),cropParams(i),0.6,1.5,minxcmaxs(i,:)); 
    xcorrs(1:length(xcc),:,i) = xcc; 
    starts(1:length(s),i) = s; 
    ends(1:length(e),i) = e; 
    
end

%%
for r = 1  :length(s)
plot(tV(s(r):e(r),2))
hold on
end

%% 
for i = 1:1
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
     figure
     plot(tV,'b'); 
     hold on 
     for ss = 1 : length(starts) 
         if starts(ss,i) == 0 
             break 
         end
         xline(starts(ss,i),'r'); 
         xline(ends(ss,i),'g');
     end
     title(strcat(ex,'- xcorrs')); 
     figure
     for ss = 1 : length(starts) 
         if starts(ss,i) == 0 
             break 
         end
         plot(tV(starts(ss,i):ends(ss,i),a)); 
         hold on
     end
    title(strcat(ex,' - reps')) ; 
end
