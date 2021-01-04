function [values] = readValuesFromFile(exercise_name,date,measure_type,measurement)

filename = strcat('Odczyty/',exercise_name,'/',subject,'/' ,...
    today , '/', measure_type ,'_', measuring , '.txt');

values = readmatrix(filename, 'LineEnding',';\n'); 
end
