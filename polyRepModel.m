function [polyRep,S] = polyRepModel(values,degree)
[polyRep,S] = polyfit((0:length(values)-1)',values,degree); 
end