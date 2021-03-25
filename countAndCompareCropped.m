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
    for j = max(i-round(maxLength),ends(max(1,repCount-1))):i - round(minLength)    
        potentialRep = testValues(j:i); 
        polyRep = polyModel.evalPoly(potentialRep); 
        xc = xcorr(potentialRep,polyRep,'normalized'); 
        [xcmax,xcmaxindex] = max(xc); 
        
%             plot(xc);
%             axis([0 length(xc) -1 1])
%             drawnow;
%     if i > max(i-round(maxLength),ends(max(1,repCount-1))) + 150 && i > 350
%      subplot(2,1,1)
%         if i > 200
%          plot(i-200:i,testValues(i-200:i)); hold on; plot(j:i,polyRep); hold off
%          axiss = gca; 
%          axiss.XAxis.Limits = [i-200 i];
%          axiss.YAxis.Limits = [min(testValues)-10 max(testValues)+10]; 
%         if rc < repCount 
%             x = [axiss.XAxis.Limits(1) axiss.XAxis.Limits(2) axiss.XAxis.Limits(2) axiss.XAxis.Limits(1)];
%             y = [axiss.YAxis.Limits(1),axiss.YAxis.Limits(1),axiss.YAxis.Limits(2),axiss.YAxis.Limits(2)];
%             patch(x,y,[.91, .95,.83]); hold on;
%             plot(i-150:i,testValues(i-200:i),'b'); hold on; plot(j:i,polyRep,'r'); hold off;         
%     %     end
%         end
%         drawnow
%         end
%     
%     xlabel('Numer próbki'); 
%     ylabel('Prêdkoœæ k¹towa'); 
%     title('Zliczanie powtórzeñ')
%     subplot(2,1,2) 
%     plot((-length(xc)/2+0.5):(length(xc)/2-0.5),xc); 
%     title('Korelacja wzajemna');
%     xlabel('Przesuniêcie'); ylabel('Korelacja'); 
%     axiss = gca ; 
%     axiss.XAxis.Limits = [-length(xc)/2+0.5 length(xc)/2-0.5]; 
%     drawnow
%     saveas(gcf,sprintf('Wykresy/GIF2/%d_%d.jpg',i,j));
%     end
%     
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
        if repCount == 2
            poly1 = AxisPolyModel(values(starts(2):ends(2),polyModel.axis),polyModel.axis,polyModel.degree,polyModel.range,polyModel.epsilon);
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
plot(testValues(starts(k):ends(k)))
hold on
plot(poly1.evalPoly(testValues(starts(k):ends(k))))
hold off 
xcor = xcorr(testValues(starts(k):ends(k)),poly1.evalPoly(testValues(starts(k):ends(k))),'normalized');
% plot(xcor);
xcorrs(k) = max(xcor); 
% title(sprintf('Powtórzenie %d',k))
end
%
figure
stairs(xcorrs)
end




end