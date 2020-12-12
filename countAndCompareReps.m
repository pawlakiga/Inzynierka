function [starts,ends] = countAndCompareReps(values, polyModel, minLength, maxLength, minxcmax)

repCount = 0 ; 
range = polyModel.range ; 
epsilon = polyModel.epsilon ; 
for i = (range + 1) :1: length(values) 
    if repCount == 0 
        if repStarts (values, i, polyModel.range, polyModel.epsilon)
            repCount = 1; 
            starts(repCount) = i; 
        end
    else
        if i >= (minLength + starts(repCount)) && i <= (maxLength + starts(repCount)) 
            potentialRep = values(starts(repCount):i, polyModel.axis); 
            polyRep = polyModel.evalPoly(potentialRep);
            xc = xcorr(potentialRep,polyRep,'normalized'); 
%             plot(xc);
%             axis([0 length(xc) -1 1])
%             drawnow;
            plot(potentialRep); hold on; plot(polyRep); hold off;
            axis([1 maxLength min(min(potentialRep),min(polyRep))-20 max(max(potentialRep),max(polyRep))+20])
            drawnow
            [xcmax, index] = max(xc); 
            if index <= (length(xc)/2+0.5)*1.01 && ... 
                        index >= (length(xc)/2+0.5)*0.99 %&& xcmax >= minxcmax
               ends(repCount) = i ; 
               xcorrs(repCount) = xcmax; 
               repCount = repCount + 1; 
               starts(repCount) = i+1; 
            end
        
        else
            if  i > (maxLength + starts(repCount)) && length(ends) < length(starts)
            for s = starts(repCount) : i - (ends(repCount-1)-starts(repCount-1))
                potentialRep = values(s:s+ends(repCount-1)-starts(repCount-1),polyModel.axis); 
                polyRep = polyModel.evalPoly(potentialRep);
                xc = xcorr(potentialRep,polyRep,'normalized'); 
    %             plot(xc);
    %             axis([0 length(xc) -1 1])
    %             drawnow;
                plot(potentialRep); hold on; plot(polyRep); hold off;
                axis([1 maxLength min(potentialRep)-20 max(potentialRep)+20])
                drawnow
                [xcmax, index] = max(xc); 
                if index <= (length(xc)/2+0.5)*1.01 && ... 
                        index >= (length(xc)/2+0.5)*0.99
                            %&& xcmax >= minXCmax
                    starts(repCount) = s; 
                   ends(repCount) = s+ends(repCount-1)-starts(repCount-1) ; 
                   repCount = repCount + 1; 
                   starts(repCount) = ends(repCount-1)+1;     
                end
            end
            end
        end
    end
end

k = 1 ; 
end