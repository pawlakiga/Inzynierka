function [repEnds] = repEnds(values, i, range , epsilon)

if ~isFixed(values(i-range:i,1:end),epsilon) && isFixed(values(i:i+range,1:end),epsilon) 
    repEnds = 1; 
else 
    repEnds = 0; 
end

end