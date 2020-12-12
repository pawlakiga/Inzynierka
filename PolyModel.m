classdef PolyModel

    properties
        xPolyModel
        yPolyModel
        zPolyModel
    end
    
    methods
        function obj = PolyModel(values,degrees)
            % values - vector of values for all axes
            % degrees 3x1 vector of polynomial degrees for each axis
            
            obj.xPolyModel = AxisPolyModel(values(1:end,1),degrees(1)); 
            obj.yPolyModel = AxisPolyModel(values(1:end,2),degrees(2)); 
            obj.zPolyModel = AxisPolyModel(values(1:end,3),degrees(3)); 
         
        end
       
        function modelValues = evalPoly(obj,values)
            valuesLength = length(values);
            modelValues = zeros(valuesLength,3);
            modelValues(1:end,1) = obj.xPolyModel.evalPoly(values(1:end,1)); 
            modelValues(1:end,2) = obj.yPolyModel.evalPoly(values(1:end,2)); 
            modelValues(1:end,3) = obj.zPolyModel.evalPoly(values(1:end,3)); 
        end
        
        function xcproperties = getXCorrProperties()
  
            xcproperties(1) = obj.xPolyModel.getXCorrProperties();
            xcproperties(2) = obj.yPolyModel.getXCorrProperties();
            xcproperties(3) = obj.zPolyModel.getXCorrProperties();
            
        end
    end
end

