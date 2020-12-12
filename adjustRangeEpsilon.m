modelValues  = readValues('Odczyty/E1/Iga/19-Nov-2020/Gyro_2.txt'); 
modelValues2  = readValues('Odczyty/E1/Iga/19-Nov-2020/Gyro_3.txt'); 

ranges = 5:5:30; epsilons = [2:20;2:20;2:20]; 
results  = zeros(length(ranges),length(epsilons)); 
% for range = ranges 
%     for epsilon = epsilons 
%         [s,e] = getReps(modelValues,range,epsilon);
%         [s,e] = deleteNoiseReps(s,e);
%         results(range/5,epsilon) = length(e); 
%     end
% end

% figure
% for i = 1 : length(e)
%     plot(modelValues(s(i):e(i),2))
%     hold on
% end

results2  = zeros(length(ranges),length(epsilons)); 
for range = ranges 
    for epsilon = epsilons 
        [s2,e2] = getReps(modelValues2,range,epsilon);
        [s2,e2] = deleteNoiseReps(s2,e2);
        results2(range/5,epsilon) = length(e2); 
        if length(e2) == 9 
            figure
            for i = 1 : length(e)
                plot(modelValues2(s2(i):e2(i),2))
                hold on
            end
            title(sprintf('Range = %d, epsilon = %d',range,epsilon))
        end
    end
end
