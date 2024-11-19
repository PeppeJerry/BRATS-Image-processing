function [x] = DiscreteWaveletTransform(x, dwt_param)

% Decomposizione dell'immagine | (x)
C = wavedec3(x, dwt_param.level, dwt_param.wname);

% Aumentiamo l'importanza delle decomposizioni a bassa frequenza
% Evidenziamo l'anomalia
n = length(C.dec);

% Ricostruzione dell'immagine x con decomposizioni alterate | (z)
x = waverec3(C);

end