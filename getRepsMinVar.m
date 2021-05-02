function [starts, ends, bestRange, bestEpsilon] = getRepsMinVar(modelValues, repsNo)

%   function to get reps from model values with automatic adjustment 
%   of range and epsilon to minimize lengths variance 
%
%   Arguments 
%   modelValues - sensor measurements 
%   repsNo - number of reps that where actually done

%   Returns 
%   starts - vector 1 by repsNo; rep starts indexes
%   ends - vector 1 by repNo; rep ends indexes 

ranges = 5:5:30; epsilons = [2:10;2:10;2:10]; 

minVar = 100000000; 
for range = ranges 
    for epsilon = epsilons 
        [s,e] = getReps(modelValues,range,epsilon);
        [s,e] = deleteNoiseReps(s,e);
          
        if length(e) == repsNo
            lengths = e - s ; 
            varr = var(lengths); 
            if varr < minVar 
                minVar = varr; 
                starts = s; 
                ends = e ; 
                bestRange = range ; 
                bestEpsilon = epsilon; 
            end
        end
    end
end

end