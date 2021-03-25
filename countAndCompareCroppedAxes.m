function [starts,ends,xcorrs] = countAndCompareCroppedAxes(values, polyModel, minLength, maxLength, minxcmax)

%
repCount = 1 ; 
testValues = values;
xcMax = zeros(1,3); 
xcmax = zeros(1,3); 
xcmaxindex = zeros(1,3);
XCMAX = zeros(1,3) ; 

decrease = 0; 
s = 0 ; 

starts = zeros(1000,1); 
ends = zeros(1000,1); 
starts(1) = 1; 
ends(1) = 1 ; 
% if figures == 1 
%    figure
% end
for i = round(minLength)+1 : length(values)
    if i < s 
        continue 
    end
    for j = max(i-round(maxLength),ends(max(1,repCount-1))):i - round(minLength)    
        
        potentialRep = testValues(j:i,:); 
         polyRep = polyModel.evalPoly(potentialRep); 
        for ax = 1 : 3
            xc = xcorr(potentialRep(:,ax),polyRep(:,ax)); 
             [xcmax(ax),xcmaxindex(ax)] = max(xc); 
%             if ~(abs(xcmaxindex(ax) - length(xc)/2+0.5) < 0.01*length(xc) && xcmax(ax) > minxcmax)
%                 break
%             else 
%             if abs(xcmaxindex(ax) - length(xc)/2 + 0.5) < 0.01*length(xc) && xcmax(ax) > minxcmax
%                 %% 
%                 if ax == 3 && sum(xcmax) > sum(xcMax)
%                     xcMax = xcmax ; 
%                     imax = i; 
%                     jmax = j ; 
%                 end
%             end

    
        end
        
        if abs(xcmaxindex(1) - length(xc)/2+0.5) < 0.05*length(xc) && xcmax(1) > minxcmax(1) && ...
            abs(xcmaxindex(2) - length(xc)/2+0.5) < 0.01*length(xc) && xcmax(2) > minxcmax(2) && ...
            abs(xcmaxindex(3) - length(xc)/2+0.5) < 0.01*length(xc) && xcmax(3) > minxcmax(3)
            if sum(xcmax) > sum(xcMax) 
%             if xcmax(1) > xcMax(1) && xcmax(2) > xcMax (2) && xcmax(3) > xcMax(3)
                xcMax = xcmax ; 
                imax = i; 
                jmax = j ; 
            end
        end
%         plot(j:i,potentialRep);
%         a = gca ; 
%         a.XAxis.Limits = [j i]; 
%         a.YAxis.Limits = [-200 200];
%         hold on; plot(j:i,polyRep);
%         hold off 
%         drawnow
    end
   
    
%     if xcMax(1) > XCMAX(1) && xcMax(2) > XCMAX(2)  && xcMax(3) > XCMAX(3)
    if sum(xcMax) > sum(XCMAX) 
        XCMAX = xcMax; 
        IMAX = imax; 
        JMAX = jmax ; 
        decrease = 0 ; 
    else
        if XCMAX ~= 0
        decrease = decrease + 1;
        end
    end
    if decrease > 10 
        starts(repCount) = JMAX; 
        ends(repCount) = IMAX ; 
        if repCount == 2
            poly1 = PolyModel(values(starts(2):ends(2),:),polyModel.degrees,polyModel.range,polyModel.epsilon);
%             plot(poly1.evalPoly(values(starts(2):ends(2),:)));
        end
%         plot(values(JMAX:IMAX,:));
%         hold on 
        repCount = repCount + 1; 
        decrease = 0; 
        IMAX = 0 ; JMAX = 0 ; XCMAX = zeros(1,3) ; 
        s = i + minLength;
        
    end
    imax= 0 ; jmax= 0 ; xcMax = zeros(1,3);
end

starts = starts(1:repCount-1); ends = ends(1:repCount-1); 
%%
xcorrs = zeros(length(starts),3);
if length(starts) > 1
for k = 1 : length(starts)
%     figure
% plot(testValues(starts(k):ends(k),:))
% hold on
% plot(poly1.evalPoly(testValues(starts(k):ends(k))))
% hold off 
polyvals = poly1.evalPoly(testValues(starts(k):ends(k),:));
for ax = 1 : 3
    xcor = xcorr(testValues(starts(k):ends(k),ax),polyvals(:,ax),'normalized');
    xcorrs(k,ax) = max(xcor); 
end
% plot(xcor);
% title(sprintf('Powtórzenie %d',k))
end
%
% figure
% stairs(xcorrs)
% legend('X','Y','Z')
end




end