function [modelValues] = evalPolyModel(polyModel,modelLength,valuesLength)
    modelValues = polyval(polyModel,(modelLength-1)/valuesLength:((modelLength-1)/valuesLength):modelLength-1);
end