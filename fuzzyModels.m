% Sterowanie d³ugoœci¹ serii na podstawie odczytów 
%% Wybór danych
clear
i = 1 ; 
% minimalna i maksymalna d³ugoœæ powtórzenia - sta³a dla wszystkich
minLength = 0.7 ; maxLength = 1.5; 

if i == 1 
    [mV,tV,mRN,tRN,d,cP,ax] = valuesAndParamsBank('E1','Iga') ;
else 
    if i == 2
        [mV,tV,mRN,tRN,d,cP,ax] = valuesAndParamsBank('E2','Iga2') ;
    else 
        [mV,tV,mRN,tRN,d,cP,ax] = valuesAndParamsBank('E3','Iga') ;
    end
end
% znalezienie powtórzeñ, wyliczenie dok³adnoœci i korelacji z pierwszym lub
% drugim powtórzeniem 
[ac,xcorrs1,xcorrs2,starts,ends]= getAccuracy(mV,tV,mRN,tRN,d,cP,ax,minLength,maxLength); 
%% Wykresy z wektorami maksimum korelacji i ich przybli¿eniami
drawApproximation(xcorrs1, ax); 
drawApproximation(xcorrs2, ax); 
%% Przybli¿enie funkcj¹ kwadratow¹, wyznaczenie centrów funkcji przynale¿noœci 
xcap = squareApproximation(xcorrs1(:,ax),0);
% figure
% stairs(xcorrs1(:,ax)); 
% hold on 
% plot(xcap); 
% legend('Korelacje wzajemne','Model w postaci funkcji kwadratowej')
% xlabel('Powtórzenie') ;
% ylabel('Maksimum korelacji w porównaniu z powtórzeniem pierwszym')

x = min(xcap):0.0001:max(xcap); 
centers = [max(xcap) - 0.3*(max(xcap) - min(xcap)), ... 
           max(xcap)-4/7*(max(xcap)-min(xcap)),...
           min(xcap) + 0.3*(max(xcap) - min(xcap))];
       
sigAngle = 30/(max(xcap)-min(xcap)); 
gbellAngle = (max(xcap)-min(xcap))/4;

a1 = 0.7/(max(xcap)-min(xcap)); b1 = -(a1-1)*centers(2);
a3 = 0.1/(max(xcap)-min(xcap)); b3 = -(a3-0.5)*centers(2)/0.85;
%% Takagi-Sugeno napisany rêcznie 

% Funkcje przynale¿noœci 
mf1 = fismf("sigmf",[sigAngle centers(1)]);
mf2 = fismf("gbellmf",[gbellAngle 1.5 centers(2)]);
mf3 = fismf("sigmf",[-sigAngle,centers(3)]);
% Rysowanie funkcji przynale¿noœci 
figure
hold on
plot(x,evalmf(mf1,x));
plot(x,evalmf(mf2,x));
plot(x,evalmf(mf3,x));
legend('Lekko zmêczony','Zmêczony','Wyczerpany'); 
xlabel('Maksimum korelacji - model')

% wektor wspó³czynników kierunkowych prostych 
a = [a1,0,a3];
% wyrazy wolne
b = [b1,1,b3]; 
% lokalne wyjœcie 
y = @ (ak,bk,x) ak.*x + ones(1,length(x))*bk ;
% sumaryczne wyjœcie 
ysum = @(w,yk) w*yk/sum(w) ; 

% macierz wyjœæ lokalnych
yl = zeros(3,length(x)); 
for i = 1:3 
    yl(i,:) = y(a(i),b(i),x); 
end

%wektor wyjœæ globalnych
ys = zeros(1,length(x)); 
for j = 1 : length(x)
    w = [evalmf(mf1,x(j)), evalmf(mf2,x(j)),evalmf(mf3,x(j))]; 
    ys(j) = ysum(w,yl(:,j)); 
end
figure
plot(x,ys)
xlabel('Maksimum korelacji - model')
ylabel('Wspó³czynnik d³ugoœci nastêpnej serii')

%% Z wykorzystaniem wbudowanych funkcji MATLABa
fis = sugfis('NumInputs',1,'NumOutputs',1) ;
fis.Inputs(1).Name = "performance"; 
fis.Inputs(1).Range = [min(x) max(x)]; 
% funkcje przynale¿noœci
fis = addMF(fis, "performance","sigmf",[sigAngle centers(1)],'Name',"a_little_tired"); 
fis = addMF(fis, "performance","gbellmf",[gbellAngle 1.5 centers(2)],'Name',"tired");
fis = addMF(fis, "performance","sigmf",[-sigAngle,centers(3)],'Name',"exhausted"); 
fis.DefuzzificationMethod = "wtaver";
% fis.AndMethod = "min"; 
% fi s.OrMethod = "max"; 

% Wyjscie - d³ugoœæ serii 
fis = addMF(fis,"output1","linear",[a1,b1],'Name',"longer"); 
fis = addMF(fis,"output1","linear",[0,1],'Name',"same"); 
fis = addMF(fis,"output1","linear",[a3,b3],'Name',"shorter"); 
fis.Outputs(1).Name = "series_length"; 

rule1 = "performance==a_little_tired => series_length = longer";
rule2 = "performance==tired => series_length = same";
rule3 = "performance==exhausted => series_length = shorter";
fis = addRule(fis,rule1);
fis = addRule(fis,rule2);
fis = addRule(fis,rule3);

% usuniêcie regu³ dodanych automatycznie
fis = removeMF(fis,"performance","mf1");
fis = removeMF(fis,"performance","mf2");
fis = removeMF(fis,"performance","mf3");
fis = removeMF(fis,"series_length","mf1");
fis = removeMF(fis,"series_length","mf2");
fis = removeMF(fis,"series_length","mf3");

% Rysowanie funkcji przynale¿noœci
plotmf(fis,'input',1)
% Rysowanie wyjœcia 
figure
gensurf(fis);
%% 
fis2 = sugfis('NumInputs',1,'NumOutputs',1) ;
fis2.Inputs(1).Name = "performance"; 
fis2.Inputs(1).Range = [min(x) max(x)]; 
% funkcje przynale¿noœci
fis2 = addMF(fis2, "performance","sigmf",[sigAngle centers(1)],'Name',"a_little_tired"); 
fis2 = addMF(fis2, "performance","gbellmf",[gbellAngle 1.5 centers(2)],'Name',"tired");
fis2 = addMF(fis2, "performance","sigmf",[-sigAngle,centers(3)],'Name',"exhausted"); 
fis2.DefuzzificationMethod = "wtaver";
% fis2.AndMethod = "min"; 
% fi s.OrMethod = "max"; 

% Wyjscie - d³ugoœæ przerwy 
fis2.Outputs(1).Name = "break_length"; 
fis2 = addMF(fis2,"break_length","linear",[-a1+2,-b1],'Name',"bshorter"); 
fis2 = addMF(fis2,"break_length","linear",[0,1],'Name',"bsame"); 
fis2 = addMF(fis2,"break_length","linear",[-a3+1.5,-b3],'Name',"blonger"); 

rule4 = "performance==a_little_tired => break_length = bshorter";
rule5 = "performance==tired => break_length = bsame";
rule6 = "performance==exhausted => break_length = blonger";
fis2 = addRule(fis2,rule4);
fis2 = addRule(fis2,rule5);
fis2 = addRule(fis2,rule6);

% usuniêcie regu³ dodanych automatycznie
fis2 = removeMF(fis2,"performance","mf1");
fis2 = removeMF(fis2,"performance","mf2");
fis2 = removeMF(fis2,"performance","mf3");
fis2 = removeMF(fis2,"break_length","mf1");
fis2 = removeMF(fis2,"break_length","mf2");
fis2 = removeMF(fis2,"break_length","mf3");
% Rysowanie funkcji przynale¿noœci
% plotmf(fis2,'input',1)
% Rysowanie wyjœcia 
figure
gensurf(fis2);
