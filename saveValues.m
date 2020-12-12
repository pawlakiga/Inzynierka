function [] = saveValues (data,filename)
file = fopen(filename,'w');
for i = 1 : length(data)
    fprintf(file,'%.2f,%.2f,%.2f;\n',data(i,1),data(i,2),data(i,3)); 
end
fclose(file);
end