function [modelRep] = selectRepForModelAxes(modelValues, starts, ends)

maxXCorrs = zeros(length(ends),length(ends),3); 
meanMaxXCorrs = zeros(1,length(ends)); 

for i = 1: length(ends) 
    for j = 1 : length(ends) 
        for ax = 1 : 3 
        xc = xcorr(modelValues(starts(i):ends(i),ax),modelValues(starts(j):ends(j),ax));
        maxXCorrs (i,j,ax) = max(xc); 
        end
    end     
    meanMaxXCorrs(i) = mean(mean(maxXCorrs(i,:,:))); 
end

[maxx,index] = max(meanMaxXCorrs) ; 
modelRep = modelValues(starts(index):ends(index),:); 

end