clear;
clear port; 

today = date; 
exercise_name = 'E1';
subject = 'Ewelina';
measure_type = 'Gyro'; 
mkdir(strcat('Odczyty/',exercise_name,'/',subject,'/' , today))
measuring = '_3'; 
filename = strcat('Odczyty/',exercise_name,'/',subject,'/' , today , '/', measure_type , measuring , '.txt'); 

port = serialport("COM5",115200);  
%total time in seconds
totalTime = 1200;

values = zeros(totalTime,3); 
angles = zeros(totalTime,3);

data = strings(totalTime,1); 
test = readline(port); 
done = readline(port); 
enter = readline(port); 

disp("Start"); 
% figure
for i = 1 : totalTime*100
    data(i) = readline(port); 
    values(i,1:end) = str2num(data(i)');
%     angles(i,1) = sum(values(1:i,2))/10; 
%     angles(i,2) = sum(values(1:i,2))/10; 
% %     angles(i,3) = sum(values(1:i,2))/10; 
%     plot(1:i,values(1:i,2),'r')
%     hold on
% %     plot(1:totalTime,angles(1:end,2),'b'); 
%     drawnow 
    
% plot(values(1:i,2));
% drawnow 
end 
%%
saveValues(values,filename)  
%%
figure
plot(values);
%%
for k = 1 : 3
figure
plot(lowpass(values(:,k),0.01,200));
end
legend('X','Y','Z')
%% 
figure
plot(lowpass(values(1:1000,2),0.01,200));
figure
plot(lowpass(values(26180:27180,2),0.01,200));

%% 
angles = zeros(length(values),3); 
for j = 1 : length(values)
    for ax = 1 : 3 
        angles(j,ax) = sum(values(1:j,ax))/100; 
    end
end
plot(angles(:,3))
%%
clear port
