classdef AxisPolyModel
%Class repersenting the polynomial model of a repetition
%poly - polynomial object, returned by polyfit 
%sourceXCorr - cross corelation of the model and its source rep 
%sourceLength - length of the source rep 
    properties
        poly                        
        sourceXCorr
        sourceLength 
        axis
        range
        epsilon
    end
    
    methods
        function obj = AxisPolyModel(sourceValues, axis, degree, range, epsilon)
            %constructor, creating the polyModel 
            [polyRep,S] = polyfit((0:length(sourceValues)-1)',sourceValues,degree); 
            obj.poly = polyRep;
            sourcePoly = polyval(polyRep,1:length(sourceValues));
            obj.sourceXCorr = xcorr(sourceValues,sourcePoly,'normalized'); 
            obj.sourceLength = length(sourceValues); 
            obj.range = range ;
            obj.epsilon = epsilon ;  
            obj.axis = axis; 
        end
        
        function [modelValues] = evalPoly(obj,values)
            %evaluates the polynomial to be compared with values 
            %modelValues - vector of polynomial values, length the same as the
            %'values' vector 
            
            valuesLength = length(values); 
            modelValues = polyval(obj.poly,...
                (obj.sourceLength-1)/valuesLength:((obj.sourceLength-1)/valuesLength):obj.sourceLength-1);
        end

        function obj = rebuild(obj,sourceValues,degree)
            % same as constructor, allows to rebuild the model, based on
            % some source values
            [polyRep,S] = polyfit((0:length(sourceValues)-1)',sourceValues,degree); 
            obj.poly = polyRep;
            sourcePoly = polyval(polyRep,1:length(source));
            obj.sourceXCorr = xcorr(sourceValues,sourcePoly,'normalized'); 
            obj.sourceLength = length(source); 
        end
        
        function xcproperties = getXCorrProperties()
            % returns the properties of xcorrelation with the source, to be
            % used when comparing the model to other values 
            [xcmax,index] = max(obj.sourceXCorr); 
            xcshift = (index - length(xcmax)/2)/length(xcmax);
            xcproperties = [xcmax;xcshift]; 
        end
    end
end

