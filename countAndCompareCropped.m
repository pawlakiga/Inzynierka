function [starts,ends] = countAndCompareCropped(values, polyModel, minLength, maxLength, minxcmax)

%
repCount = 1 ; 
range = polyModel.range ; 
epsilon = polyModel.epsilon ; 
testValues = values(:,polyModel.axis);
xcMax = 0; 
XCMAX = 0 ; 
starts(1) = 1; 
ends(1) = 1 ; 
decrease = 0; 
s = 0 ; 

for i = round(minLength)+1 : length(values)
    if i < s 
        continue 
    end
    for j = max(i-round(maxLength),ends(max(1,repCount-1))):i - round(minLength)    
        potentialRep = testValues(j:i); 
        polyRep = polyModel.evalPoly(potentialRep); 
        xc = xcorr(potentialRep,polyRep,'normalized'); 
        [xcmax,xcmaxindex] = max(xc); 
        
%             plot(xc);
%             axis([0 length(xc) -1 1])
%             drawnow;
%             plot(potentialRep); hold on; plot(polyRep); hold off;
%             axis([1 maxLength min(min(potentialRep),min(polyRep))-20 max(max(potentialRep),max(polyRep))+20])
%             drawnow
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
        if repCount == 2
            poly1 = AxisPolyModel(values(starts(2):ends(2),polyModel.axis),polyModel.axis,polyModel.degree,polyModel.range,polyModel.epsilon);
        end
        repCount = repCount + 1; 
        decrease = 0; 
        IMAX = 0 ; JMAX = 0 ; XCMAX = 0 ; 
        s = i + minLength;
    end
    imax= 0 ; jmax= 0 ; xcMax = 0;
end
%%
for k = 1 : length(starts)

plot(testValues(starts(k):ends(k)))
hold on
plot(poly1.evalPoly(testValues(starts(k):ends(k))))
hold off 
xcor = xcorr(testValues(starts(k):ends(k)),poly1.evalPoly(testValues(starts(k):ends(k))),'normalized');
plot(xcor);
xcorrs(k) = max(xcor); 
title(sprintf('Powtórzenie %d',k))
end
%%
figure
stairs(xcorrs)
end