% Skrypt do budowy modelu zmeczenia na podstawie 

i = 1 ; 
minLength = 0.7 ; maxLength = 1.5; 

if i == 1 
    [mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E1','Iga') ;
else 
    if i == 2
        [mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E2','Iga') ;
    else 
        [mV,tV,mRN,tRN,d,cP,a] = valuesAndParamsBank('E3','Iga') ;
    end
end

[ac,xcorrs]= getAccuracy(mV,tV,mRN,tRN,d,cP,a,minLength,maxLength); 
%%

%%
xcorrsB = xcorrs ; 
xcorrs = xcorrs(1:193); 
%%
t1 = 0; 
t2 = round(length(xcorrs)/2); 
d = 0.1; 
e = xcorrs(t1+1); 
f = 1 ; 
g = 1 ; 
h = xcorrs(t2); 
tx2 = (d/(f*g))^(1/(g-1)); 
F = @(t) e + d.*(t-t1); 

% aproksymacja funkcj� z artyku�u
G = @(t) h-f*tx2^8+f*(t-t2-tx2)^8;


bmin = 1e-17; bmax = 2e-16; bstep = 1e-17; 
fmin = 1e-18; fmax = 2e-17; fstep = 1e-18; 
gmin = 1e-17; gmax = 2e-16; gstep = 1e-17; 
t2min = round(length(xcorrs)/2); t2max = length(xcorrs)-1;

blength = length(bmin:bstep:bmax) ; 
flength = length(fmin:fstep:fmax) ; 
glength = length(gmin:gstep:gmax) ; 
t2length = length(t2min:t2max) ; 
%%
calls = blength * flength * glength * t2length ; 

approx = zeros(length(xcorrs),1);
E = zeros(calls,1); 
params = zeros(calls,4); 
call = 0 ; 


for b = bmin : bstep : bmax 
    for f = fmin : fstep : fmax 
        for g = gmin : gstep : gmax
            for t2 = t2min : t2max 
                
                h = xcorrs(t2); 
                
                %F = @(t) e - d.*(t-t1); 
                G = @(t) h -(-f*tx2^8+f*(t-t2-tx2).^8); 
                
                Fprim = ones(t2-1,1)*h; 
                
%                 approx(t1+1:t2-1) = F(t1+1:t2-1); 
                
                approx(t1+1:t2-1) = Fprim; 
                approx(t2:end) = G(t2:length(xcorrs)); 
               
                call = call + 1 ; 
                params(call,1:end) = [b,f,g,t2]; 
                E(call) = (approx-xcorrs)'*(approx-xcorrs); 
                
%                  if call == 1 
%                     stairs(xcorrs,'b'); hold on 
%                     plot(approx,'r'); hold off
%                     drawnow
%                 end
                
%                 stairs(xcorrs,'b'); hold on 
%                 plot(approx,'r'); hold off
%                 title(sprintf('b = %.2f, f = %.2f, g = %.2f, t2 = %d, E = %.2f',b,e,f,t2,E(call)));
%                 drawnow
            end
        end 
    end 
end
%%
 approxP = zeros(length(xcorrs),1) ; 
               
% aproksymacja funkcj� wyk�adnicz� 
% H = @(t) h - k.*m.^(t-t2) ; 
% 
% %aproksymacja funkcj� kwadratow� 
% J = @(t) h - n.*(t-t2).^2 ; 

kmin = 0.01; kmax = 1; kstep = 0.01; 
mmin = 1.01; mmax = 2; mstep = 0.01; 

klength = length(kmin:kstep:kmax); mlength = length(mmin:mstep:mmax); 

callsP = klength*mlength*t2length ; 
paramsP = zeros(callsP,3); EP = zeros(callsP,1); 
call = 0 ; 
for k = kmin:kstep:kmax 
    for m = mmin : mstep : mmax 
        for t2 = t2min:t2max
        
         h = xcorrs(t2); 
        % aproksymacja funkcj� wyk�adnicz� 
        H = @(t) h + (t-t2)/(t1-t2+1)*k.*m.^(t-t2) ; 
        
        Fprim = ones(t2-1,1)*h; 
                              
        approxP(t1+1:t2-1) = Fprim; 
        approxP(t2:end) = H(t2:length(xcorrs)); 
        call = call + 1 ; 
        paramsP(call,:) = [k,m,t2]; EP(call) = (approxP-xcorrs)'*(approxP-xcorrs);
%         stairs(xcorrs,'b'); hold on 
%         plot(approxP,'r'); hold off
%         drawnow
%                
        end
    end
end

%% 
[minp,ip] = min(EP); 
kp = paramsP(ip,1); mp = paramsP(ip,2); t2p = paramsP(ip,3); 
hp = xcorrs(t2p); 

H = @(t) hp + (t-t2p)/(t1-t2p+1)*kp.*mp.^(t-t2p) ; 
        
Fprim = ones(t2p-1,1)*hp; 

approxP(t1+1:t2p-1) = Fprim; 
approxP(t2p:end) = H(t2p:length(xcorrs)); 
figure
stairs(xcorrs,'b'); hold on 
plot(approxP,'r'); hold off
title(sprintf('Przybli�enie funkcj� wyk�adnicz� E = %g',minp))
drawnow
%%
 approxS = zeros(length(xcorrs),1) ; 
               
% aproksymacja funkcj� wyk�adnicz� 
% H = @(t) h - k.*m.^(t-t2) ; 
% 
% %aproksymacja funkcj� kwadratow� 
% J = @(t) h - n.*(t-t2).^2 ; 

nmin = 0.000001; nmax = 0.00001; nstep = 0.000001; 
nlength = length(nmin:nstep:nmax); 


callsS = nlength*t2length ; 
paramsS = zeros(callsS,2); ES = zeros(callsS,1); 
call = 0 ; 

for n = nmin : nstep : nmax  
    for t2 = t2min : t2max
        h = xcorrs(t2); 
        % aproksymacja funkcj� wyk�adnicz� 
        J = @(t) h - n.*(t-t2).^2 ; 
        Fprim = ones(t2-1,1)*h;         
        approxS(t1+1:t2-1) = Fprim; 
        approxS(t2:end) = J(t2:length(xcorrs)); 
        
        call = call + 1 ; 
        paramsS(call,:) = [n,t2]; ES(call) = (approxS-xcorrs)'*(approxS-xcorrs);
%         stairs(xcorrs,'b'); hold on 
%         plot(approxS,'r'); hold off
%         drawnow
%                
    end
end

[mins,is] = min(ES);
ns = paramsS(is,1); t2s = paramsS(is,2); 
hs = xcorrs(t2s); 

J = @(t) hs - ns.*(t-t2s).^2 ; 
        
Fprim = ones(t2s-1,1)*hs; 

approxS(t1+1:t2s-1) = Fprim; 
approxS(t2s:end) = J(t2s:length(xcorrs)); 
%%
figure
stairs(xcorrs,'b'); hold on 
plot(approxS,'r'); hold off
title(sprintf('Przybli�enie funkcj� kwadratow� E = %g',mins))
drawnow
%%
[m,i] = min(E); 
b = params(i,1) ; f = params(i,3); g = params(i,3); t2 = params(i,4);
h = xcorrs(t2); 
G = @(t) h-(-f*tx2^8+f*(t-t2-tx2).^8); 
Fprim = ones(t2-1,1)*h;
approx(t1+1:t2-1) = F(t1+1:t2-1);                 
approx(t1+1:t2-1) = Fprim; 
approx(t2:end) = G(t2:length(xcorrs)); 
figure
plot(approx); hold on ; stairs(xcorrs); 
title(sprintf('Przybli�enie wielomianem 8 stopnia  E = %g',m))

%% 
figure
for i = 1 : 96 : 767912
b = params(i,1) ; f = params(i,3); g = params(i,3); t2 = params(i,4);
t2 = 94;
F = @(t) e - d.*(t-t1);
h = xcorrs(t2); 
G = @(t) h-(-f*tx2^8+f*(t-t2-tx2).^8); 

Fprim = ones(t2-1,1)*h;
approx(t1+1:t2-1) = F(t1+1:t2-1);                 
approx(t1+1:t2-1) = Fprim; 
approx(t2:end) = G(t2:length(xcorrs)); 
plot(approx); hold on ; stairs(xcorrs); hold off

end

