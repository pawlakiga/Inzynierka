function [starts,ends] = findReps(values, polyModel, minLength,maxLength)

repCount = 0 ; 
minXCmax = 0.8;
range = 5;
epsilon = [18,18,18];
for i = (range + 1) :1: length(values) 
    if i > 1000
        kk = 1;
    end
    if repCount == 0 
        if repStarts (values, i, range, epsilon)
            repCount = 1; 
            starts(repCount) = i; 
        end
    else
        if i >= (minLength + starts(repCount)) && i <= (maxLength + starts(repCount)) 
            potentialRep = values(starts(repCount):i,2); 
            polyRep = polyModel.evalPoly(potentialRep);
            xc = xcorr(potentialRep,polyRep,'normalized'); 
%             plot(xc);
%             axis([0 length(xc) -1 1])
%             drawnow;
            plot(potentialRep); hold on; plot(polyRep); hold off;
            axis([1 maxLength min(potentialRep)-20 max(potentialRep)+20])
            drawnow
            [xcmax, index] = max(xc); 
            if index == length(xc)/2+0.5 %&& xcmax >= minXCmax
               ends(repCount) = i ; 
               repCount = repCount + 1; 
               starts(repCount) = i+1; 
            end
        end
        if i > (maxLength + starts(repCount)) && length(ends) < length(starts) 
            for s = starts(repCount) : i - polyModel.sourceLength
                potentialRep = values(s:s+polyModel.sourceLength,2); 
                polyRep = polyModel.evalPoly(potentialRep);
                xc = xcorr(potentialRep,polyRep,'normalized'); 
    %             plot(xc);
    %             axis([0 length(xc) -1 1])
    %             drawnow;
                plot(potentialRep); hold on; plot(polyRep); hold off;
                axis([1 maxLength min(potentialRep)-20 max(potentialRep)+20])
                drawnow
                [xcmax, index] = max(xc); 
                if index == length(xc)/2+0.5 %&& xcmax >= minXCmax
                   ends(repCount) = i ; 
                   repCount = repCount + 1; 
                   starts(repCount) = i+1;     
                end
   
            end
        end
    end
end

k = 1 ; 
end