function x = Invert(x)
max_x = max(x(:));
x = -x + max_x;
end