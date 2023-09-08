function showQ(Q, name, flag)
    if nargin < 3, flag = false; end
    if flag
        imagesc(log10(abs(Q(2:end, 2:end) + 1e-4)))
    else
        imagesc(Q(2:end, 2:end))
    end
    c = colorbar;
    ylabel(c, 'log_1_0 k')
    caxis([-4 5.25])
    title(name)
    ticklabels = ["M" "M*" "M1" "M1*" "M2*" "M2**" "M**" "M1**" "M3**"];
    ticks = 1:numel(ticklabels);
    set(gca, 'XTick', ticks, 'XTickLabel', ticklabels)
    set(gca, 'YTick', ticks, 'YTickLabel', ticklabels)
end