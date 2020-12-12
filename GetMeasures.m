clear;
clear port; 


today = date; 
exercise_name = 'E4';
subject = 'Ewelina';
measure_type = 'Gyro'; 
mkdir(strcat('Odczyty/',exercise_name,'/',subject,'/' , today))
measuring = '_3'; 
filename = strcat('Odczyty/',exercise_name,'/',subject,'/' , today , '/', measure_type , measuring , '.txt'); 

port = serialport("COM5",115200);
totalTime = 10000;

values = zeros(totalTime,3); 
angles = zeros(totalTime,3);

data = strings(totalTime,1); 
test = readline(port); 
done = readline(port); 
enter = readline(port); 

disp("Start"); 
figure
for i = 1 : totalTime
    data(i) = readline(port); 
    values(i,1:end) = str2num(data(i)');
%     angles(i,1) = sum(values(1:i,2))/10; 
%     angles(i,2) = sum(values(1:i,2))/10; 
% %     angles(i,3) = sum(values(1:i,2))/10; 
%     plot(1:i,values(1:i,2),'r')
%     hold on
% %     plot(1:totalTime,angles(1:end,2),'b'); 
%     drawnow 

end 
 
saveValues(values,filename)
%%
clear port
