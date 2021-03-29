function [starts,ends,xcorrs] = countAndCompareCroppedAxes(values, polyModel, minLength, maxLength, minxcmax)

% Function finds time periods where an exercise repetition was being done 
% Arguments :
% values        matrix of gyro values obtained during a test measurement 
% polyModel     PolyModel object conatining polynomials representing
%               example repetitions
% minLength     minimum length of a repetition
% maxLength     maximum length of a repetition 
% minxcmax      vector of 3 values with the lower threshold for
%               xcorrelation of the model and actual values above which
%               these values are treated as a potential repetition
%
% Return values :
% starts        vector of indexes of the moments where repetitions start
% ends          vector of indexes of the moments where repetitions end 
% xcorrs        maximum values of xcorrelations of a model based on the
%               second repetition and the next ones 
repCount = 1 ; 
testValues = values;
xcMax = zeros(1,3); 
xcmax = zeros(1,3); 
xcmaxindex = zeros(1,3);
minxcmaxs = zeros(3,1); 
XCMAX = zeros(1,3) ; 
decrease = 0; 
% minimum next possible rep end index - when a rep is found s is set to 
% i + minLength
s = 0 ; 

starts = zeros(1000,1); 
ends = zeros(1000,1); 
starts(1) = 1; 
ends(1) = 1 ; 
% if figures == 1 
%    figure
% end

% i - potential rep end
for i = round(minLength)+1 : length(values)
    %  for reps shorter than minLength
    if i < s 
        continue 
    end
    % j - potential rep starts 
    for j = max(i-round(maxLength),ends(max(1,repCount-1))):i - round(minLength)    
         potentialRep = testValues(j:i,:); 
         polyRep = polyModel.evalPoly(potentialRep); 
         % difference between maximum xcorr index and the middle of xcorr
         % vector 
         shifts = zeros(1,3); 
         % maximum values of autocorrelation for each axis in model
         maxautoxc = zeros(1,3); 
        for ax = 1 : 3
            % calculate xcorr and autocorrelation for each axis
            xc = xcorr(potentialRep(:,ax),polyRep(:,ax));
            autoxc = xcorr(polyRep(:,ax),polyRep(:,ax)); 
            maxautoxc(ax) = max(autoxc); 
            [xcmax(ax),xcmaxindex(ax)] = max(xc); 
            % calculate shifts
            shifts(ax) = xcmaxindex(ax) - length(xc)/2 - 0.5 ; 
            minxcmaxs(ax) = minxcmax(ax) * max(autoxc);
            
        end
%         plot(j:i,potentialRep);
%         a = gca ; 
%         a.XAxis.Limits = [j i];
%         a.YAxis.Limits = [-200 200];
%         hold on; plot(j:i,polyRep);
%         hold off 
%         drawnow
        % if mean shift weighted by maximum value of xcorrelation is within
        % limits 
        if abs(mean(shifts .* [xcmax(1)/max(xcmax); xcmax(2)/max(xcmax); xcmax(3)/max(xcmax)]')) < 0.1 * length(xc)
% if abs(shifts(1)) < 0.05 * length(xc) && abs(shifts(2)) < 0.05 * length(xc) && abs(shifts(3))<  0.05 *  length(xc)
%         if abs(mean(shifts.* [maxautoxc(1)/max(maxautoxc);maxautoxc(2)/max(maxautoxc); maxautoxc(3)/max(maxautoxc)]) ) < 0.1 * length(xc)
%             if xcmax(1) > minxcmaxs(1) && ...
%                xcmax(2) > minxcmaxs(2) && ... 
%                xcmax(3) > minxcmaxs(3) && ... 
%                sum(xcmax) > sum(xcMax)
            % if xcorr maximum values are above the lower threshold and
            % better then the current best
            if sum(xcmax) > sum(minxcmaxs) && sum(xcmax) > sum(xcMax) 
                xcMax = xcmax ; 
                imax = i; 
                jmax = j ; 
            end
        else 
            % if shifts are not within limits - jump forward to the lowest
            % shift 
            shifts2 = shifts ; 
            shifts2(shifts2 < 0) = 1000;  
            s = i + min(shifts2) * 0.8; 
            continue 
        end
    end
   
   % if the best found xcorrs for various rep lengths are better 
   % than the current best for a various rep end indexes
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
    % if the xcorrs were getting worse for the last ten end indexes
    if decrease > 10 
        % rep was found - indexes with the last best xcorrs
        starts(repCount) = JMAX; 
        ends(repCount) = IMAX ; 
        % create polyModel for second rep to later compare to other reps
        if repCount == 2
            poly1 = PolyModel(values(starts(2):ends(2),:),polyModel.degrees,polyModel.range,polyModel.epsilon);
        end
        repCount = repCount + 1; 
        decrease = 0; 
        IMAX = 0 ; JMAX = 0 ; XCMAX = zeros(1,3) ; 
        % "jump" to the lowest possible next rep end
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