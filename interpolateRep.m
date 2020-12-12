function [pp] = interpolateRep(values)
pp = interp1(1:length(values),values,'pchip','pp'); 