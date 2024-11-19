function x = LogTransform(x, param)
x = param.c * log2(1 + param.N * double(x));
end