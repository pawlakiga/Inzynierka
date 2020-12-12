function [starts, ends] = getReps(values, range, epsilon)

repCount = 0 ; 
repStarted = 0; 
for i = range + 1 : length(values) - range - 1
    if repStarted == 0
        if repStarts (values, i, range, epsilon)
            starts(repCount+1) = i; 
            repStarted = 1;
        end
        continue 
    else 
        if repEnds(values,i,range,epsilon)
            repCount = repCount + 1 ; 
            ends(repCount) = i ; 
            repStarted = 0 ; 
        end
    end
    
end
starts = starts(1:length(ends)) ; 
end