%% 1. Setup - wczytanie danych, definicja parametrów ustawianych rêcznie
clear
% allModelValues = readValues('Odczyty/E3/Ewelina/30-Nov-2020/Gyro_1.txt' ) ; 
% allTestValues = readValues('Odczyty/E3/Ewelina/30-Nov-2020/Gyro_2.txt') ; 

% allModelValues = readValues('Odczyty/E1/Iga/19-Nov-2020/Gyro_2.txt' ) ; 
% allTestValues = readValues('Odczyty/E1/Iga/29-Nov-2020/Gyro_1.txt') ;


% allModelValues = readValues('Odczyty/E2/Iga/21-Dec-2020/Gyro_1.txt' ) ;
% allTestValues = readValues('Odczyty/E2/Iga/21-Dec-2020/Gyro_4.txt' ) ;

% allModelValues = readValues('Odczyty/E2/Iga/21-Dec-2020/Gyro_1.txt' ) ; 
% allTestValues = readValues('Odczyty/E2/Iga/29-Dec-2020/Gyro_1.txt' ) ; 
% 
% allModelValues = readValues('Odczyty/E1/Iga/30-Dec-2020/Gyro_1.txt' ) ; 
% allTestValues = readValues('Odczyty/E1/Iga/30-Dec-2020/Gyro_2.txt' ) ; 

% allModelValues = readValues('Odczyty/E5/Iga/26-Dec-2020/Gyro_1.txt' ) ; 
% allTestValues = readValues('Odczyty/E5/Iga/26-Dec-2020/Gyro_4.txt' ) ; 

% 
allModelValues = readValues('Odczyty/E3/Iga/03-Jan-2021/Gyro_1.txt' ) ; 
allTestValues = readValues('Odczyty/E3/Iga/03-Jan-2021/Gyro_2.txt' ) ; 


%%
% fs = 100 ; 
% fmin = 0.01; 
% allModelValues = readValues('Odczyty/E5/Ania/19-Dec-2020/Gyro_2.txt' ) ;
% allModelValues = lowpass(allModelValues,fmin,fs);
% allModelVal = readValues('Odczyty/E5/Iga/21-Dec-2020/Gyro_1.txt' ) ;
% allModelVals = lowpass(allModelVal,fmin,fs);
% figure
% plot(allModelValues(1:1500,:)); 
% figure
% plot(allModelVals); 
%%
fs = 100 ; 
fmin = 0.01; 
allModelValues = lowpass(allModelValues,fmin,fs);
allTestValues = lowpass(allTestValues,fmin,fs);

plot(allModelValues);
legend('X','Y','Z')

repsNo  = 5 ; 
ax = getMostSensitiveAxis(allModelValues); 
ax = 2; 
modelValues  = allModelValues(:,ax); 
testValues = allTestValues(:,ax) ; 

% stopieñ wielomianu, jakim przybli¿ane bêdzie powtórzenie
degree = 10; 

%czêœæ powtórzenia przycinania do modelu 
cropParam = 0.9; 

% rysowanie wykresów 
figures = 1; 

%% 1a Wyliczanie pozycji k¹towej
% angleModelValues = zeros(length(modelValues),3) ;
% 
for i  = 1 : length(allModelValues) 
    angleModelValues(i,1) = sum(allModelValues(1:i,1)/180*pi/100); 
    angleModelValues(i,2) = sum(allModelValues(1:i,2)/180*pi/100); 
    angleModelValues(i,3) = sum(allModelValues(1:i,3)/180*pi/100); 
end

angleTestValues = zeros(length(testValues(1:1000)),1) ;

for i  = 1 : length(allTestValues(1:1000)) 
    angleTestValues(i) = sum(allTestValues(1:i,ax)); 
end
% figure
% plot(angleTestValues); 
% hold on 
% plot(testValues(1:1000)); 
% 
% %% 1b. Wizualizacja ruchu 
% 
%  
% r = 1; 
%     hold off
% for i = 1 : length(angleModelValues) 
%     
%     a = angleModelValues(i,1); 
%     b = angleModelValues(i,2); 
%     c = angleModelValues(i,3); 
% %     
% %     Rx = [1 0 0; 0 cos(a) -sin(a); 0 sin(a) -cos(a)]; 
% %     Ry = [cos(b) 0 sin(b); 0 1 0; -sin(b) 0 cos(b)];
% %     Rz = [cos(c) -sin(c) 0 ;sin(c) cos(c) 0 ; 0 0 1]; 
% %     
% %     xyz = Rz*Ry*Rx*[x;y;z];
%     
% %     x = r*sin(a)*cos(b); y = -r*sin(c)*cos(a); z = r*cos(a)*cos(b);
% %     plot(i,x,'r.')
% %     hold on
% %     drawnow
% %     plot3(z,y,x,'r.');
% %     xlabel('x'), ylabel('y'), zlabel('z'); 
% %     hold on
% %     drawnow 
% 
%     x = r * cos(b)*cos(c) ; 
%     y = r * cos(b)*sin(c); 
%     z = r * cos(b); 
%     %xyz = rotz(angleModelValues(i,3))*roty(angleModelValues(i,2))*rotx(angleModelValues(i,1))*[x;y;z]
%     plot3(z,y,x,'.')
%     xlabel ('x'); ylabel('y');zlabel('z');
%     hold on
%     drawnow
% end

%% 2. Wycinanie z modelowych danych konkrenych powtórzeñ z minimalizacj¹ 
%     wariancji d³ugoœci powtórzeñ

[starts,ends, bestRange, bestEpsilon] = getRepsMinVar(allModelValues, repsNo) ;

if figures == 1 
    figure
    l = strings(1,length(ends));
    for i = 1 : length(ends) 
        plot(modelValues(starts(i):ends(i)));
        hold on
        l(i) = sprintf('Rep. %d',i); 
    end
    legend(l)
    title('Znalezione powtórzenia modelowe')
    hold off 
end


%% 3. Wybór powtórzenia do u¿ycia jako wzorcowe i budowa modelu w postaci 
%     wielomianu 

modelRep = selectRepForModel(modelValues,starts,ends); 
%przycinanie powtórzenia modelowego 
cropstart = round(length(modelRep)*(1-cropParam)/2); cropend = round(length(modelRep)-cropstart); 
modelRepCropped = modelRep(cropstart:cropend); 
degrees = 1:30;

for deg = degrees
    polyModel = AxisPolyModel(modelRepCropped,ax, deg, bestRange, bestEpsilon) ;
    polyModelRep = polyModel.evalPoly(modelRepCropped);
    E(deg) = (polyModelRep - modelRepCropped')*(polyModelRep'-modelRepCropped); 
end
semilogy(1:30,E);
figure
plot(diff(E));


%%
polyModel = AxisPolyModel(modelRepCropped,ax, degree, bestRange, bestEpsilon) ; 

if figures == 1 
    plot(modelRepCropped,'b') ;
    polyModelRep = polyModel.evalPoly(modelRepCropped);
    hold on
    plot(polyModelRep,'r'); 
    title(sprintf('Powtórzenie wzorcowe i jego model w postaci wielomianu stopnia %d',degree))
    legend('Dane','Wielomian')
end
%% 4. Zliczanie powtórzeñ jako porównywanie 

[s,e] = countAndCompareCropped(allTestValues, polyModel, 0.7/cropParam*polyModel.sourceLength, 1.5/cropParam*polyModel.sourceLength, 0.9)

%% 

for r = 1 : length(s)
    plot(testValues(s(r):e(r)))
    hold on 
end
%% 
repsToCompare = round(length(s)/2) ; 
xcmax = zeros(1,repsToCompare); 
for i = 1 : repsToCompare
    %figure
    indexA = i; indexB = length(s)-i+1; 
    repA = testValues(s(indexA):e(indexA)); repB = testValues(s(indexB):e(indexB)); 
%     plot(repA); 
%     hold on ; 
%     plot(repB); 
%     legend(sprintf('Powtórzenie %d',indexA),sprintf('Powtórzenie %d',indexB));  
%     title(sprintf('Powtórzenie %d i %d', indexA, indexB)); 
    xc = xcorr(repA,repB); 
    xcmax(i) = max(xc); 
end
figure
stairs(xcmax);
%%
x= 1; 
pm = AxisPolyModel(xcmax',1,5,1,[1,1,1])

stairs(xcmax); 
hold on 
plot(pm.evalPoly(xcmax))



%% 
% countAndCompare(allTestValues, polyModel, 0.7);


