function [values] = readValues(filename)
values = readmatrix(filename, 'LineEnding',';\n'); 
end