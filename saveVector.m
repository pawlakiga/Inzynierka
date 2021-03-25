function [] = saveVector(vector,filename) 
file = fopen(filename,'w');
for i = 1 : length(vector)
    fprintf(file,'%g;\n',vector(i)); 
end
fclose(file);
end