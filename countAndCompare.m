function [] = countAndCompare(values, polyModel, minxcmax)

ax = getMostSensitiveAxis(values); 
testValues = values(:,ax); 
repCount = 0 ;
polyRep  = polyModel.evalPoly(testValues(1:polyModel.sourceLength))
for i = 1 + polyModel.sourceLength : length(values) 
    potentialRep = testValues(i-polyModel.sourceLength+1:i); 
    xc = xcorr(potentialRep, polyRep, 'normalized') ; 
%     plot(xc)
%     axis([0 length(xc)-1 -1 1])
    plot(potentialRep); 
    hold on
    plot(polyRep); 
    hold off
    drawnow
    [xcmax, ixcmax] = max(xc); 
    if (ixcmax) == length(xc)/2+0.5
        repCount = repCount + 1; 
    end
    
end


end