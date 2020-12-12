function [n_starts,n_ends] = deleteNoiseReps(starts,ends)

lengths = ends-starts; 
meanLength = mean(lengths); 
noiseRepsCount = 0; 
n_starts = []; n_ends = []; 


% poprawiæ - uwzglêdniæ dla i = 1
for i = 1 : length(ends) 
    if lengths(i) > meanLength*0.7
        n_starts = [n_starts,starts(i)];
        n_ends = [n_ends,ends(i)]; 
    end
end
end