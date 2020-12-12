function [repStarts] = repStarts(values, i, range , epsilon)

if isFixed(values(i-range:i,1:end),epsilon) && ~isFixed(values(i:i+range,1:end),epsilon) 
    repStarts = 1; 
else 
    repStarts = 0; 
end



end