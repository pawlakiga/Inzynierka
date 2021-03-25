function [vector] = readVector(filename)
vector = readmatrix(filename, 'LineEnding',';\n'); 
end