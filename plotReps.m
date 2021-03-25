function []  = plotReps(allModelValues,starts,ends,exercise,name)

l = strings(1,length(ends));
for ax = 1 : 3
    f  = figure
for i = 1 : length(ends) 
    plot(allModelValues(starts(i):ends(i),ax));
    hold on
    l(i) = sprintf('Rep. %d',i); 
end
legend(l)
title(sprintf('Znalezione powtórzenia modelowe %s - oœ %d',exercise,ax))
hold off 
saveas(f,sprintf('Wykresy/ManyAxes/%s_%s_-Os_%d',exercise,name,ax))
end

end
