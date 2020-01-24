function [x_p, y_p] = extract_pareto(x, y, bins)

[x_sorted, ind] = sort(x, 1);
y_sorted = y(ind);
x_range = linspace(min(x), max(x), bins);


Y = discretize(x_sorted(:,1), bins-1);
y_p = [];
x_p = [];
for i = 1:(length(x_range)-1)
    x_min = x_range(i);
    x_max = x_range(i+1);
    ind = find((x_sorted>x_min)&(x_sorted<x_max));
    if ~isempty(ind)
        y_p = [y_p; max(y_sorted(ind))];
        x_p = [x_p; x_sorted(find(y_sorted == y_p(end)))];
    end
   
end



end