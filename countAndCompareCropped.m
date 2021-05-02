function [starts,ends,xcorrs] = countAndCompareCropped(values, polyModel, minLength, maxLength, minxcmax)

%
repCount = 1 ; 
testValues = values(:,polyModel.axis);
xcMax = 0; 
XCMAX = 0 ; 
starts(1) = 1; 
ends(1) = 1 ; 
decrease = 0; 
s = 0 ; 
rc = 1; 
% figure
for i = round(minLength)+1 : length(values)
    if i < s 
        continue 
    end
    % different rep lengths
    for j = max(i-round(maxLength),ends(max(1,repCount-1))):i - round(minLength)    
        potentialRep = testValues(j:i); 
        polyRep = polyModel.evalPoly(potentialRep); 
        xc = xcorr(potentialRep,polyRep,'normalized'); 
        [xcmax,xcmaxindex] = max(xc); 
        
%         plot(potentialRep); hold on; plot(polyRep);hold off 
%         a = gca ; 
%         a.XAxis.Limits = [j i]; 
%         a.YAxis.Limits = [-200 200];
%         drawnow
        if xcmaxindex == length(xc)/2+0.5 && xcmax > minxcmax
            if xcmax > xcMax 
                xcMax = xcmax ; 
                imax = i; 
                jmax = j ; 
            end
        end
    end
   
    
    if xcMax > XCMAX 
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
        if repCount == 1
            poly1 = AxisPolyModel(values(starts(repCount):ends(repCount),polyModel.axis),polyModel.axis,polyModel.degree,polyModel.range,polyModel.epsilon);
        end
        repCount = repCount + 1; 
        decrease = 0; 
        IMAX = 0 ; JMAX = 0 ; XCMAX = 0 ; 
        s = i + minLength;
    end
    imax= 0 ; jmax= 0 ; xcMax = 0;
    
    rc = repCount ; 
    
end
%%
xcorrs = zeros(length(starts),1);
if length(starts) > 1
for k = 1 : length(starts)
% plot(testValues(starts(k):ends(k)))
% hold on
% plot(poly1.evalPoly(testValues(starts(k):ends(k))))
% hold off 
xcor = xcorr(testValues(starts(k):ends(k)),poly1.evalPoly(testValues(starts(k):ends(k))),'normalized');
% plot(xcor);
xcorrs(k) = max(xcor); 
% title(sprintf('Powtórzenie %d',k))
end
%
% figure
% stairs(xcorrs)
end




end