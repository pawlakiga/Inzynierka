function [repStartRuntime] = getRepStartRuntime(values,i,range,epsilon)
repStartRuntime = 0 ;
if i > 2*range
   if repStarts(values, i-range, range, epsilon)
       repStartRuntime = i - range; 
   end   
end
end