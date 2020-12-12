%% 1. Setup - wczytanie danych, definicja parametrów ustawianych rêcznie
clear
allModelValues = readValues('Odczyty/E3/Ewelina/30-Nov-2020/Gyro_1.txt' ) ; 
allTestValues = readValues('Odczyty/E3/Ewelina/30-Nov-2020/Gyro_2.txt') ; 
% allModelValues = readValues('Odczyty/E1/Iga/19-Nov-2020/Gyro_2.txt' ) ; 
% allTestValues = readValues('Odczyty/E1/Iga/29-Nov-2020/Gyro_1.txt') ; 

fs = 100 ; 
fmin = 0.4; 
allModelValues = lowpass(allModelValues,fmin,fs);
allTestValues = lowpass(allTestValues,fmin,fs);

plot(allModelValues(:,3)); 

repsNo  = 9 ; 
ax = getMostSensitiveAxis(allModelValues); 
modelValues  = allModelValues(:,ax); 
testValues = allTestValues(:,ax) ; 

% stopieñ wielomianu, jakim przybli¿ane bêdzie powtórzenie
degree = 22; 

% rysowanie wykresów 
figures = 1; 

%% 1a Wyliczanie pozycji k¹towej
angleModelValues = zeros(length(modelValues),3) ;

for i  = 1 : length(allModelValues) 
    angleModelValues(i,1) = sum(allModelValues(1:i,1)/180*pi/100); 
    angleModelValues(i,2) = sum(allModelValues(1:i,2)/180*pi/100); 
    angleModelValues(i,3) = sum(allModelValues(1:i,3)/180*pi/100); 
end
plot(angleModelValues); 
hold on 
plot(modelValues) ; 
angleTestValues = zeros(length(testValues(1:1000)),1) ;

for i  = 1 : length(allTestValues(1:1000)) 
    angleTestValues(i) = sum(allTestValues(1:i,ax)); 
end
figure
plot(angleTestValues); 
hold on 
plot(testValues(1:1000)); 

%% 1b. Wizualizacja ruchu 

 
r = 1; 
    hold off
for i = 1 : length(angleModelValues) 
    
    a = angleModelValues(i,1); 
    b = angleModelValues(i,2); 
    c = angleModelValues(i,3); 
%     
%     Rx = [1 0 0; 0 cos(a) -sin(a); 0 sin(a) -cos(a)]; 
%     Ry = [cos(b) 0 sin(b); 0 1 0; -sin(b) 0 cos(b)];
%     Rz = [cos(c) -sin(c) 0 ;sin(c) cos(c) 0 ; 0 0 1]; 
%     
%     xyz = Rz*Ry*Rx*[x;y;z];
    
%     x = r*sin(a)*cos(b); y = -r*sin(c)*cos(a); z = r*cos(a)*cos(b);
%     plot(i,x,'r.')
%     hold on
%     drawnow
%     plot3(z,y,x,'r.');
%     xlabel('x'), ylabel('y'), zlabel('z'); 
%     hold on
%     drawnow 

    x = r * cos(b)*cos(c) ; 
    y = r * cos(b)*sin(c); 
    z = r * cos(b); 
    %xyz = rotz(angleModelValues(i,3))*roty(angleModelValues(i,2))*rotx(angleModelValues(i,1))*[x;y;z]
    plot3(z,y,x,'.')
    xlabel ('x'); ylabel('y');zlabel('z');
    hold on
    drawnow
end

%%
A = angleModelValues(:,1); 
B = angleModelValues(:,2); 
C = angleModelValues(:,3); 
%%
p



%% 2. Wycinanie z modelowych danych konkrenych powtórzeñ z minimalizacj¹ 
%     wariancji d³ugoœci powtórzeñ

[starts,ends, bestRange, bestEpsilon] = getRepsMinVar(allModelValues, repsNo) ;

if figures == 1 
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
polyModel = AxisPolyModel(modelRep,ax, degree, bestRange, bestEpsilon) ; 

if figures == 1 
    plot(modelRep,'b') ;
    polyModelRep = polyModel.evalPoly(modelRep);
    hold on
    plot(polyModelRep,'r'); 
    title(sprintf('Powtórzenie wzorcowe i jego model w postaci wielomianu stopnia %d',degree))
    legend('Dane','Wielomian')
end
%% 4. Zliczanie powtórzeñ jako porównywanie 

countAndCompareReps(allTestValues, polyModel, 0.7*polyModel.sourceLength, 1.5*polyModel.sourceLength, 0.7)

%% 
countAndCompare(allTestValues, polyModel, 0.7);


