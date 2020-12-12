function [modelRep] = selectRepForModel(modelValues, starts, ends)

maxXCorrs = zeros(length(ends)); 
meanMaxXCorrs = zeros(1,length(ends)); 

for i = 1: length(ends) 
    for j = 1 : length(ends) 
        xc = xcorr(modelValues(starts(i):ends(i)),modelValues(starts(j):ends(j)));
        maxXCorrs (i,j) = max(xc); 
        plot(xc); 
        hold on
    end    
    hold off;
    meanMaxXCorrs(i) = mean(maxXCorrs(i,:)); 
end

[maxx,index] = max(meanMaxXCorrs) ; 
modelRep = modelValues(starts(index):ends(index)); 

end