function [map,C] = Kmeans(x, K)
dims = size(x);
x = reshape(x, [], 1);
[map, C] = kmeans(x, K);
map = reshape(map, dims);
end
