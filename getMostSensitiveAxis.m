function [mostSensitiveAxis] = getMostSensitiveAxis(values)
% function to get the most sensitive axis to be later 
% used to build the model and detect exercise reps
axVariance = zeros(3,1); 
for axis = 1 : 3
    axVariance(axis) = var(values(:,axis)); 
end
[~,mostSensitiveAxis] = max(axVariance); 
end