clear;
clear port; 

today = date; 
exercise_name = 'E1';
mostSensitiveAxis = 2;  
modelValues = readValues('Odczyty/E1/Iga/19-Nov-2020/Gyro_2.txt');
[s,e] = getReps(modelValues,20,[7;7;7]);
[s,e] = deleteNoiseReps(s,e); 
polyModel = AxisPolyModel(values(s(2):e(2),mostSensitiveAxis)); 
minLength = 0.6 * mean(e-s); 
maxLength = 1.4 * mean(e-s); 

subject = 'Iga';
measure_type = 'Gyro'; 
mkdir(strcat('Odczyty/',exercise_name,'/',subject,'/' , today))
measuring = '_3'; 
filename = strcat('Odczyty/',exercise_name,'/',subject,'/' , today , '/', measure_type , measuring , '.txt'); 

port = serialport("COM5",115200);
totalTime = 5000;

values = zeros(totalTime,3); 
angles = zeros(totalTime,3);


repCount = 0;
starts =[]; ends=[]; 
range = 15; epsilon = [7,7,7]; 
data = strings(totalTime,1); 
test = readline(port); 
done = readline(port); 
enter = readline(port); 

disp("Start"); 
figure
for i = 1 : totalTime
    data(i) = readline(port); 
    values(i,1:end) = str2num(data(i)');
    if repCount == 0 
        starts(1) = getRepStartRuntime(values,i, range, epsilon); 
        if starts(1) ~= 0 
            repCount = repCount + 1; 
        end
    else
        if i >= minLength + starts(repCount) && i <= maxLength + starts(repCount) 
            potentialRep = values(starts(repCount):i); 
            polyRep = polyModel.evalPoly(potentialRep);
            xc = xcorr(potentialRep,polyRep,'normalized'); 
            [xcmax, index] = max(xc); 
            if index == length(xc)/2+0.5 && xcmax >= minXCmax
               ends(repCount) = i ; 
               plot(values(starts(repCount):ends(repCount),mostSensitiveAxis));
               title(sprintf('Powtorzenie %d',repCount))
               repCount = repCount + 1; 
               starts(repCount) = i+1; 
            end
        end
    end
%     angles(i,1) = sum(values(1:i,2))/10; 
%     angles(i,2) = sum(values(1:i,2))/10; 
%     angles(i,3) = sum(values(1:i,2))/10; 
%     plot(1:i,values(1:i,2),'r')
%     hold on
%     plot(1:totalTime,angles(1:end,2),'b'); 
%     drawnow 

end 
saveValues(values,filename)
