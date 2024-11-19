function Dice = DSC(x,Y)

    %%%%%%%%
    % Dice %
    %%%%%%%%

    Y = logical(Y);
    x = logical(x);

    intersection = sum(Y(:) & x(:));
    Dice = (2 * intersection) / (sum(Y(:)) + sum(x(:)));
end