function map = GMM(x, N)
dims = size(x);
x = reshape(x, [], 1);
gmmModel = fitgmdist(x, N);
map = cluster(gmmModel, x);
map = reshape(map, dims);
end