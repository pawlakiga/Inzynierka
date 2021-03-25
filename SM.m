approxS = zeros(length(xcorrs),1) ; 
               
% aproksymacja funkcj¹ wyk³adnicz¹ 
% H = @(t) h - k.*m.^(t-t2) ; 
% 
% %aproksymacja funkcj¹ kwadratow¹ 
% J = @(t) h - n.*(t-t2).^2 ; 

nmin = 0.000001; nmax = 0.00001; nstep = 0.000001; 
nlength = length(nmin:nstep:nmax); 


callsS = nlength*t2length ; 
paramsS = zeros(callsS,2); ES = zeros(callsS,1); 
call = 0 ; 

for n = nmin : nstep : mmax  
    for t2 = t2min : t2max
        h = xcorrs(t2); 
        % aproksymacja funkcj¹ wyk³adnicz¹ 
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
