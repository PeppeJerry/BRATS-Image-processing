function norm = minmax(x)
%nvz = x(x > 10); % Elimino gli zeri non rilevanti

nvz = x(:);

% Min e Max
min_x = min(nvz);
max_x = max(nvz);

% Normalizzazione
norm = (x - min_x) / (max_x - min_x);

% Zeri di background
norm(x <= 50) = 0;
end