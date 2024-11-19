function [output] = HomomorphicFilter(X, param)
  
    % 1. Passo logaritmico (+1 per evitare gli 0 nell'immagine)
    x_log = log1p(X);
    % 2. Trasformata di Fourier
    x_fft = fftn(x_log);
    % 3. Creazione del filtro passa-alto gaussiano 3D
    [sx, sy, sz] = size(X);
    x = -floor(sx/2) : floor((sx-1)/2);
    y = -floor(sy/2) : floor((sy-1)/2);
    z = -floor(sz/2) : floor((sz-1)/2);
    [X, Y, Z] = ndgrid(x,y,z);
    
    % Distanza dai centri
    param.D = sqrt(X.^2 + Y.^2 + Z.^2);

    % Filtro (Comunemente gaussiano passa-alto)
    H = filter(param);

    % 4. Applicazione del filtro in frequenza
    Y_fft = x_fft .* fftshift(H);

    % 5. Trasformata inversa di Fourier
    Y_ = ifftn(Y_fft);

    % 6. Esponenziale inverso per tornare allo spazio immagine
    output = exp(real(Y_)) - 1;
end


function H = filter(param)
D = param.D;
D0 = param.D0;
switch param.type
    case "GAUSSIAN"
        gammaH = param.gammaH;
        gammaL = param.gammaL;
        H = (gammaH - gammaL) * (1 - exp(-(D.^2) / (2*D0^2))) + gammaL;
    case "IDEAL"
        H = double(D > D0);
end

end