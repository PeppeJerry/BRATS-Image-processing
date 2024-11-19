function [map, Otsu_T] = OtsuThreshold(x, N)

dims = size(x);
x = reshape(x, [], 1);

Otsu_T = multithresh(x,N);

map = imquantize(x, Otsu_T);

map = reshape(map, dims);

end
