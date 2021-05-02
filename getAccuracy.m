function [accuracy,xcc1,xcc2,s,e] = getAccuracy(allModelValues,allTestValues,modelRepsNo,testRepsNo,degree,cropParam,ax,minLength,maxLength)
% Funkcja do znajdywania powt�rze� w przebiegu testowym 
% Argumenty:
% allModelValues    macierz odczyt�w z pomiaru modelowego
% allTestvalues     macierz odczyt�w z pomiaru testowego
% modelRepsNo       liczba powt�rze� w przebiegu modelowym 
% testRepsNo        liczba powt�rze� w przebiegu testowym 
% degree            stopie� wielomianu, jakim b�d� przybli�ane odczyty 
% cropParam         cz�� ze �rodka powt�rzenia, kt�ra zostanie u�yta do
%                   stworzenia modelu wielomianu i wyszukiwania powt�rze�
% ax                o� u�ywana przy badaniach 
% minLength         minimalna d�ugo�� powt�rzenia 
% maxLength         maksymalna d�ugo�� powt�rzenia 

% filtr dolnoprzepustowy 
fs = 100 ; 
fmin = 0.01; 
allModelValues = lowpass(allModelValues,fmin,fs);
allTestValues = lowpass(allTestValues,fmin,fs);

modelValues  = allModelValues(:,ax); 
testValues = allTestValues(:,ax) ; 

% wycinanie powt�rze� z przebiegu modelowego
[starts,ends, bestRange, bestEpsilon] = getRepsMinVar(allModelValues, modelRepsNo) ;
% wyb�r powt�rzenia modelowego 
modelRep = selectRepForModel(modelValues,starts,ends); 
%przycinanie powt�rzenia modelowego 
cropstart = round(length(modelRep)*(1-cropParam)/2); cropend = round(length(modelRep)-cropstart); 
modelRepCropped = modelRep(cropstart:cropend); 

polyModel = AxisPolyModel(modelRepCropped,ax, degree, bestRange, bestEpsilon) ; 
% s - wektor pr�bek startowych powt�rze�
% e - wektor pr�bek ko�cowych powt�rze�
% zliczanie i znajdywanie powt�rze�
[s,e,~] = countAndCompareCropped(allTestValues, polyModel, minLength/cropParam*polyModel.sourceLength, maxLength/cropParam*polyModel.sourceLength, 0.9);
% 
% plot((0:length(testValues)-1)./100,testValues,'Color','#7E2F8E');
% hold on
% ax = gca;
% ax.XAxis.Limits = [0 (length(testValues)-1)/100];
% for i = 1 : length(e) 
% %     xline(s(i)/100,'k--');
% %     xline(e(i)/100,'r--'); 
%     x = [s(i)/100 e(i)/100  e(i)/100 s(i)/100];
%     y = [ax.YAxis.Limits(1),ax.YAxis.Limits(1),ax.YAxis.Limits(2),ax.YAxis.Limits(2)];
%      patch(x,y,[1,1,.9]); 
% end
% plot((0:length(testValues)-1)./100,testValues,'Color','#7E2F8E');
% legend('Os Y','interpreter','latex');  
% xlabel('Czas $[s]$','interpreter','latex'); ylabel('Predkosc katowa $[\frac{\deg}{s}]$','interpreter','latex'); 
% hold off

accuracy = 1 - abs(length(s) - testRepsNo)/testRepsNo; 

% relacje wzajemne pomi�dzy kolejnymi powt�rzeniami a pierwszym i drugim
% powt�rzeniem
selectedRep = 1 ; 
polyModel = PolyModel(allTestValues(s(selectedRep):e(selectedRep),:),[degree;degree;degree],bestRange,bestEpsilon); 
xcc = zeros(length(starts),3); 
for r = 1 : length(s) 
    if r == selectedRep 
        continue 
    end
    valRep = allTestValues(s(r):e(r),:); 
    polyRep = polyModel.evalPoly(valRep); 
    for axis = 1 : 3
        xcc(r,axis) = max(xcorr(valRep(:,axis),polyRep(:,axis),'normalized'));  
    end
    
end
xcc1 = xcc(2:end,:); 

selectedRep = 2 ; 
r2 = 1 ; 
polyModel = PolyModel(allTestValues(s(selectedRep):e(selectedRep),:),[degree;degree;degree],bestRange,bestEpsilon); 
xcc = zeros(length(starts),3); 
xcc2 = zeros(length(starts)-1,3); 
for r = 1 : length(s) 
    if r == selectedRep 
        continue 
    end
    valRep = allTestValues(s(r):e(r),:); 
    polyRep = polyModel.evalPoly(valRep); 
    for axis = 1 : 3
        xcc(r,axis) = max(xcorr(valRep(:,axis),polyRep(:,axis),'normalized'));  
    end
    xcc2(r2,:) = xcc(r,:); 
    r2 = r2 + 1; 
end


end