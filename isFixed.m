function [fixed] = isFixed(values, epsilon) 

diff1 = max(values) ; 
diff2 = - min(values);
for axis = 1 : 3 
    if diff1(axis) > epsilon(axis) ||  diff2(axis) > epsilon(axis)
        fixed = 0 ;
        break; 
    else
        fixed = 1 ;
    end
end

end