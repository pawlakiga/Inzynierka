% Aproksymacja zmêczenia  

mkdir('Korelacje'); 
clear 

bestParams = zeros(3,4); bestParamsP = zeros(3,3); bestParamsS = zeros(3,2); 
bestE = ones(3,1)*10e6; bestEP = ones(3,1)*10e6; bestES = ones(3,1)*10e6; 
t1 = 0 ; d = 0.1 ; 
for i  = 1 : 3 
    
    % Za³adowanie danych 
    if i == 1 
        [mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E1','Iga') ;
    else 
        if i == 2
            [mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E2','Iga') ;
        else 
            [mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E3','Iga') ;
        end
    end

    % Budowa modelu, wyliczanie powtórzeñ, wartoœci max korelacji
    % wzajemnych 
    
    [ac,xcorrs]= getAccuracy(mV,tV,mRN,tRN,d,cP,a,0.7,1.3); 
    saveVector(xcorrs,sprintf('Korelacje/E%d.txt',i));
    
%     if i == 1 
%         xcorrs = xcorrs(1:193); 
%     end
%     
%     % Funkcja - wed³ug krzywej Lorenza, wielomian 8 stopnia
%     bmin = 1e-18; bmax = 2e-16; bstep = 1e-18; 
%     fmin = 1e-18; fmax = 2e-17; fstep = 1e-18; 
%     gmin = 1e-18; gmax = 2e-16; gstep = 1e-18; 
%     t2min = round(length(xcorrs)/2); t2max = length(xcorrs)-1;
% 
%     blength = length(bmin:bstep:bmax) ; 
%     flength = length(fmin:fstep:fmax) ; 
%     glength = length(gmin:gstep:gmax) ; 
%     t2length = length(t2min:t2max) ;  
% 
%     approx = zeros(length(xcorrs),1);
%     
%     for b = bmin : bstep : bmax 
%         for f = fmin : fstep : fmax 
%             for g = gmin : gstep : gmax
%                 for t2 = t2min : t2max 
% 
%                     h = xcorrs(t2); 
%                     tx2 = (d/(f*g))^(1/(g-1)); 
% 
%                     %F = @(t) e - d.*(t-t1); 
%                     G = @(t) h -(-f*tx2^8+f*(t-t2-tx2).^8); 
% 
%                     Fprim = ones(t2-1,1)*h; 
% 
%     %                 approx(t1+1:t2-1) = F(t1+1:t2-1); 
% 
%                     approx(t1+1:t2-1) = Fprim; 
%                     approx(t2:end) = G(t2:length(xcorrs)); 
% 
%                     params = [b,f,g,t2]; 
%                     E = (approx-xcorrs)'*(approx-xcorrs); 
%                     
%                     if E < bestE(i) 
%                         bestE(i) = E ;
%                         bestParams(i,:) = params ; 
%                     end
%                     
%     %                  if call == 1 
%     %                     stairs(xcorrs,'b'); hold on 
%     %                     plot(approx,'r'); hold off
%     %                     drawnow
%     %                 end
% 
%     %                 stairs(xcorrs,'b'); hold on 
%     %                 plot(approx,'r'); hold off
%     %                 title(sprintf('b = %.2f, f = %.2f, g = %.2f, t2 = %d, E = %.2f',b,e,f,t2,E(call)));
%     %                 drawnow
%                 end
%             end 
%         end 
%     end
% 
%     
%     %aproksymacja funkcj¹ wyk³adnicz¹ 
%     approxP = zeros(length(xcorrs),1) ; 
% 
%     kmin = 0.001; kmax = 1; kstep = 0.001; 
%     mmin = 1.001; mmax = 3; mstep = 0.001; 
%     
% 
%     for k = kmin:kstep:kmax 
%         for m = mmin : mstep : mmax 
%             for t2 = t2min:t2max
%                 h = xcorrs(t2); 
% 
%                 H = @(t) h + (t-t2)/(t1-t2+1)*k.*m.^(t-t2) ; 
%                 Fprim = ones(t2-1,1)*h; 
% 
%                 approxP(t1+1:t2-1) = Fprim; 
%                 approxP(t2:end) = H(t2:length(xcorrs)); 
%                 EP = (approxP-xcorrs)'*(approxP-xcorrs);
%                 
%                 if EP < bestEP(i)
%                     bestEP(i) = EP ; 
%                     bestParamsP(i,:) = [k,m,t2]; 
%                 end
%     %         stairs(xcorrs,'b'); hold on 
%     %         plot(approxP,'r'); hold off
%     %         drawnow
%     %                
%             end
%         end
%     end
% 
%     % aproksymacja funkcj¹ kwadratow¹
%     approxS = zeros(length(xcorrs),1) ; 
% 
%     nmin = 0.000001; nmax = 0.0001; nstep = 0.000001; 
%     nlength = length(nmin:nstep:nmax); 
% 
% 
%     for n = nmin : nstep : nmax  
%         for t2 = t2min : t2max
%             h = xcorrs(t2); 
%             % aproksymacja funkcj¹ kwadratow¹ 
%             J = @(t) h - n.*(t-t2).^2 ; 
%             Fprim = ones(t2-1,1)*h;         
%             approxS(t1+1:t2-1) = Fprim; 
%             approxS(t2:end) = J(t2:length(xcorrs));  
%             paramsS = [n,t2]; ES = (approxS-xcorrs)'*(approxS-xcorrs);
%             
%             if ES < bestES(i) 
%                 bestES(i) = ES ; 
%                 bestParamsS(i,:) = paramsS; 
%             end
%     %         stairs(xcorrs,'b'); hold on 
%     %         plot(approxS,'r'); hold off
%     %         drawnow
%     %                
%         end
%     end
       
end
%%
for i = 1 : 3
    if i == 1 
        filename = 'Korelacje/E1.txt'; 
    else 
        if i == 2
            filename = 'Korelacje/E2.txt'; 
        else 
            filename = 'Korelacje/E3.txt'; 
        end
    end
   
    xcorrs = readVector(filename); 
    if i == 1 
        xcorrs = xcorrs(1:193); 
    end

    approx = zeros(length(xcorrs),1);
    approxP = zeros(length(xcorrs),1);
    approxS = zeros(length(xcorrs),1);

m = bestE(i); 
b = bestParams(i,1) ; f = bestParams(i,3); g = bestParams(i,3); t2 = bestParams(i,4);
h = xcorrs(t2); 
G = @(t) h-(-f*tx2^8+f*(t-t2-tx2).^8); 
Fprim = ones(t2-1,1)*h;                
approx(t1+1:t2-1) = Fprim; 
approx(t2:end) = G(t2:length(xcorrs)); 
figure
plot(approx); hold on ; stairs(xcorrs); 
title(sprintf('Przybli¿enie wielomianem 8 stopnia  E = %g',m))
    
minp = bestEP(i); 
kp = bestParamsP(i,1); mp = bestParamsP(i,2); t2p = bestParamsP(i,3); 
hp = xcorrs(t2p); 
H = @(t) hp + (t-t2p)/(t1-t2p+1)*kp.*mp.^(t-t2p) ;         
Fprim = ones(t2p-1,1)*hp; 
approxP(t1+1:t2p-1) = Fprim; 
approxP(t2p:end) = H(t2p:length(xcorrs)); 
figure
stairs(xcorrs,'b'); hold on 
plot(approxP,'r'); hold off
title(sprintf('Przybli¿enie funkcj¹ wyk³adnicz¹ E = %g',minp))

mins = bestES(i); 
ns = bestParamsS(i,1); t2s = bestParamsS(i,2); 
hs = xcorrs(t2s); 
J = @(t) hs - ns.*(t-t2s).^2 ; 
Fprim = ones(t2s-1,1)*hs; 
approxS(t1+1:t2s-1) = Fprim; 
approxS(t2s:length(xcorrs)) = J(t2s:length(xcorrs)); 
figure
stairs(xcorrs,'b'); hold on 
plot(approxS,'r'); hold off
title(sprintf('Przybli¿enie funkcj¹ kwadratow¹ E = %g',mins))
drawnow
end
