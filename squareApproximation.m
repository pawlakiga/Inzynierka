function [approxS,mins,ns,t2s,hs] = squareApproximation(xcorrs,figures)

approxS = zeros(length(xcorrs),1) ; 
               
% %aproksymacja funkcj¹ kwadratow¹ 
% J = @(t) h - n.*(t-t2).^2 ; 
t1 = 0 ;
t2min = round(length(xcorrs)/3); t2max = length(xcorrs)-1;

nmin = 0.000001; nmax = 0.001; nstep = 0.000001; 
nlength = length(nmin:nstep:nmax); 
t2length = length(t2min:t2max) ; 
callsS = nlength*t2length ; 
paramsS = zeros(callsS,2); ES = zeros(callsS,1); 
call = 0 ; 

for n = nmin : nstep : nmax  
    for t2 = t2min : t2max
        h = xcorrs(t2); 
        % aproksymacja funkcj¹ kwadratow¹ 
        J = @(t) h - n.*(t-t2).^2 ; 
        Fprim = ones(t2-1,1)*h;         
        approxS(t1+1:t2-1) = Fprim; 
        approxS(t2:end) = J(t2:length(xcorrs)); 
        
        call = call + 1 ; 
        paramsS(call,:) = [n,t2]; ES(call) = (approxS-xcorrs)'*(approxS-xcorrs);
        if figures == 1 
            stairs(xcorrs,'b'); hold on 
%             title(sprintf('t2 = %d, '))
            plot(approxS,'r'); hold off
            drawnow
        end      
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
% figure
% stairs(xcorrs,'b'); hold on 
% plot(approxS,'r'); hold off
% title(sprintf('Przybli¿enie funkcj¹ kwadratow¹ E = %g',mins))

end
