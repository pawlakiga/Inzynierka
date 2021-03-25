function [starts,ends,xcorrs] = countAndCompare(values, polyModel, minLength, maxLength, minxcmax)

% Funkcja do wykrywania i zliczania powtorzen w przbeiegu testowym 
% Argumenty:   
% values          macierz wartosci zmierzonych dla wszystkich osi 
% polyModel       obiekt zawierajacy model w postaci wielomianu
%                 oraz dane na temat jego i danych zrodlowych
% minLength       minimalna dozwolona dlugosc powtorzenia 
% maxLength       maksymalna dozwolona dlugosc powtorzenia 
% minxcmax        minimalna dozwolona wartosc maksymalna wektora korelacji wzajemnej 
% 
% Wartosci zwracane: 
% starts          wektor zawierajacy indeksy probek poczatkowych dla
%                 kolejnych powtorzen
% ends            wektor zawierajacy indeksy probek koncowych dla
%                 kolejnych powtorzen
% xcorrs          wektor zawierajacy maksima korelacji wzajemnych 
%                 powtorzenia pierwszego i kolejnych powtorzen

% liczba znalezionych powtorzen
repCount = 1 ; 

% wybranie wartosci dla odpowiedniej osi
testValues = values(:,polyModel.axis);

% najlepsza znaleziona wartosc maksimum korelacji wzajemnej dla danej
% probki i roznych rozwazanych dlugosci powtorzenia 
xcMax = 0; 

% najlepsza znaleziona wartosc maksimum korelacji wzajemnej dla roznych
% probek 
XCMAX = 0 ;

% ustawienie poczatkowe 
starts(1) = 1; 
ends(1) = 1 ;

% liczba kolejnych probek, dla ktorych maksimum korelacji danych i 
% wzorca spadalo
decrease = 0; 

% najmniejszy mozliwy indeks probki konczacej nastcpne powtorzenie
next = minLength ; 

% pctla zewnctrzna - po wartosciach wektora danych testowych 
% i - potencjalny koniec powtorzenia
for i = minLength+1 : length(values)
   if i > next
       % pctla wewnctrzna - rozwazane rozne dlugosci powtorzenia przy koncu
       % w konkretnym punkcie
       % j - potencjalny poczatek powtozenia - nie miec wartosci nizszej
       % niz koniec poprzedniego powtorzenia
        for j = max(i-maxLength,ends(max(1,repCount-1))):i - minLength   
            % wektor wartosci porownywanych do wzorca - kandydat na
            % powtorzenie
            potentialRep = testValues(j:i); 
            % wyznaczenie wartosci wyliczonych na podstawie modelu dla tych
            % samych punktow 
            polyRep = polyModel.evalPoly(potentialRep); 
            % obliczenie korelacji wzajemnej obu wektorow
            xc = xcorr(potentialRep,polyRep,'normalized'); 
            % wyznaczenie maksimum wektora korelacji i indeksu probki w
            % ktorej wartosc maksymalna jest osiagana
            [xcmax,xcmaxindex] = max(xc); 
            % Sprawdzenie czy wartosc maksymalna osiagana jest w srodku
            % wektora oraz czy spelnia wymagania co do dolnej granicy
            if xcmaxindex == length(xc)/2+0.5 && xcmax > minxcmax
                % Sprawdzenie czy znaleziona maksymalna wartosc jest wyzsza
                % niz poprzednia
                if xcmax > xcMax
                    % Zapisanie najlepszej znalezionej wartosci maksimum i
                    % potencjalnych poczatku i konca powtorzenia
                    xcMax = xcmax ; 
                    imax = i; 
                    jmax = j ; 
                end
            end
        end
        % Sprawdzenie czy najlepsza wartosc korelacji dla tej probki jest
        % wyzsza niz dotychczasowa
        if xcMax > XCMAX 
            XCMAX = xcMax; 
            IMAX = imax; 
            JMAX = jmax ; 
            decrease = 0 ; 
        else
            % Jesli zostalo osiagnicte maksimum i wartosci maleja
            if XCMAX ~= 0
                decrease = decrease + 1;
            end
        end
        % Jesli wartosci maksymalne korelacji maleja od ponad 10 probek
        if decrease > 10 
            % Zapisanie najlepszych granic powtorzenia do wektorow
            starts(repCount) = JMAX; 
            ends(repCount) = IMAX ; 
            % Inkrementacja licznika powtorzen
            repCount = repCount + 1; 
            decrease = 0; 
            IMAX = 0 ; JMAX = 0 ; XCMAX = 0 ; 
            % Ustawienie minimalnego indeksu probki branej pod uwagc jako
            % koniec kolejnego powtorzenia 
            next = i + minLength;
        end
        imax= 0 ; jmax= 0 ; xcMax = 0;
   end
end
%%
xcorrs = zeros(length(starts),1);
if length(starts) > 1
for k = 1 : length(starts)
plot(testValues(starts(k):ends(k)))
hold on
plot(polyRep1.evalPoly(testValues(starts(k):ends(k))))
hold off 
xcor = xcorr(testValues(starts(k):ends(k)),polyRep1.evalPoly(testValues(starts(k):ends(k))),'normalized');
% plot(xcor);
xcorrs(k) = max(xcor); 
% title(sprintf('Powtorzenie %d',k))
end
%
figure
stairs(xcorrs)
end

end