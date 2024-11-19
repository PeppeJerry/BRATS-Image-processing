function NSD = NSD(x,Y,tau)

    %%%%%%%
    % NSD %
    %%%%%%%

    Y = logical(Y);
    x = logical(x);
    
    % Estrazione dei bordi
    SA = bwperim(Y);
    SB = bwperim(x);

    % Intorno
    cube = ones(tau, tau, tau);
    T = strel('arbitrary', cube);

    % Prendo un intorno di T dai bordi
    SA_T = imdilate(SA, T);
    SB_T = imdilate(SB, T);
    
    % Calcolo delle intersezioni
    intersectionA = SA & SB_T;
    intersectionB = SB & SA_T;
    
    NSD = (sum(intersectionA(:)) + sum(intersectionB(:))) / (sum(SA(:)) + sum(SB(:)));
end