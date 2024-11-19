% Report da Esaminare
report = 'report_1731701386.json';
output = 'report_1731701386.txt';

% Lettura del report e conversione in formato struct
fid = fopen(report, 'r');
rawData = fread(fid, inf, 'uint8');
strData = char(rawData');
fclose(fid);
data = jsondecode(strData);

% Creazione della mappa per gestire tutte le informazioni
metrics = containers.Map;

% Tecniche di trasformazione e segmentazioni usate
T = ["Inv", "HF", "Log"];
S = ["KMeans","Otsu","GMM"];

%%%%%%%%%%%%%%%%%%%%
% INIZIALIZZAZIONE %
%%%%%%%%%%%%%%%%%%%%

% Per tecniche di trasformazione
for i=1:max(size(T))
    metrics(T(i)) = [];
end


% Per tecniche di segmentazione
for i=1:max(size(S))
    metrics(S(i)) = [];
end

% Per coppia Trasformazione-Segmentazione
T_S = [];
for i=1:max(size(T))
    for j=1:max(size(S))
        tmp = T(i)+"_"+S(j);
        T_S = [T_S;tmp];
        metrics(tmp) = [];
    end
end

% Campioni esaminati
metrics("brains") = [];

for i = 1:size(data)
    sample = data(i);
    
    values = struct( ...
        'dice'      , sample.dice,                ...
        'nsd'       , sample.nsd                  ...
        );

    % Salvo i valori delle metriche per tecnica di TRASFORMAZIONE

    metrics(sample.transform) = [metrics(sample.transform); values];

    % Salvo i valori delle metriche per tecnica di SEGMENTAZIONE

    metrics(sample.segmentation) = [metrics(sample.segmentation); values];

    % Salvo i valori delle metriche per coppia di TRANSFORMAZIONE-SEGMENTAZIONE
    
    tmp = sample.transform+"_"+sample.segmentation;
    metrics(tmp) = [metrics(tmp); values];

    %%%%%%%%%%%%
    % CAMPIONE %
    %%%%%%%%%%%%

    % Viene analizzato il valore migliore per metrica (Dice e NSD)
    % per campione analizzato (Con le tecniche correlate)

    if ~ismember(str2num(sample.brain), metrics("brains"))
        % Nuovo campione
        new_entry = struct( ...
        'brain'     ,   sample.brain,             ...
        'transform_dice' , sample.transform,      ...
        'transform_nsd' , sample.transform,       ...
        'segmentation_dice', sample.segmentation, ...
        'segmentation_nsd', sample.segmentation,  ...
        'dice'      , sample.dice,                ...
        'nsd'       , sample.nsd                  ...
        );

        metrics("brains") = [metrics("brains"); str2num(sample.brain)];
        metrics(num2str(sample.brain)) = new_entry;
    else
        % Controllo se le metriche del "sample" sono migliori
        % rispetto a quelle precedentemente salvate in "metrics"
        brain = metrics(num2str(sample.brain));

        % Metrica Dice migliore
        if brain.dice < sample.dice
            brain.dice = sample.dice;
            brain.transform_dice = sample.transform;
            brain.segmentation_dice = sample.segmentation;
        end

        % Metrica NSD migliore
        if brain.nsd < sample.nsd
            brain.nsd = sample.nsd;
            brain.transform_nsd = sample.transform;
            brain.segmentation_nsd = sample.segmentation;
        end

        metrics(num2str(sample.brain)) = brain;
    end

end

% Stesura di un report riassuntivo
fid = fopen(output, 'w');
fprintf(fid, "Riassunto del report ['"+report+"'].\n\n");

% MEDIE
for i=1:max(size(T))
    fprintf(fid, "Trasformazione ['"+T(i)+"']\n\n");
    data = metrics(T(i));
    dice = [];
    nsd = [];
    for j=1:max(size(data))
        dice = [dice;data(j).dice];
        nsd = [nsd;data(j).nsd];
    end

    fprintf(fid, "Dice AVG ['"+num2str(mean(dice))+"']\n");
    fprintf(fid, "Dice MAX ['"+num2str(max(dice))+"']\n");
    fprintf(fid, "Dice MIN ['"+num2str(min(dice))+"']\n");
    fprintf(fid, "Dice STD ['"+num2str(std(dice))+"']\n\n");

    fprintf(fid, "NSD AVG ['"+num2str(mean(nsd))+"']\n");
    fprintf(fid, "NSD MAX ['"+num2str(max(nsd))+"']\n");
    fprintf(fid, "NSD MIN ['"+num2str(min(nsd))+"']\n");
    fprintf(fid, "NSD STD ['"+num2str(std(nsd))+"']\n\n\n");

end

fprintf(fid, "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n");

for i=1:max(size(S))
    fprintf(fid, "Segmentazione ['"+S(i)+"']\n\n");
    data = metrics(S(i));
    dice = [];
    nsd = [];
    for j=1:max(size(data))
        dice = [dice;data(j).dice];
        nsd = [nsd;data(j).nsd];
    end

    fprintf(fid, "Dice AVG ['"+num2str(mean(dice))+"']\n");
    fprintf(fid, "Dice MAX ['"+num2str(max(dice))+"']\n");
    fprintf(fid, "Dice MIN ['"+num2str(min(dice))+"']\n");
    fprintf(fid, "Dice STD ['"+num2str(std(dice))+"']\n\n");

    fprintf(fid, "NSD AVG ['"+num2str(mean(nsd))+"']\n");
    fprintf(fid, "NSD MAX ['"+num2str(max(nsd))+"']\n");
    fprintf(fid, "NSD MIN ['"+num2str(min(nsd))+"']\n");
    fprintf(fid, "NSD STD ['"+num2str(std(nsd))+"']\n\n\n");

end

fprintf(fid, "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n");

for i=1:max(size(T_S))
    fprintf(fid, "Coppia Transformazione-Segmentazione ['"+T_S(i)+"']\n\n");
    data = metrics(T_S(i));
    dice = [];
    nsd = [];
    for j=1:max(size(data))
        dice = [dice;data(j).dice];
        nsd = [nsd;data(j).nsd];
    end

    fprintf(fid, "Dice AVG ['"+num2str(mean(dice))+"']\n");
    fprintf(fid, "Dice MAX ['"+num2str(max(dice))+"']\n");
    fprintf(fid, "Dice MIN ['"+num2str(min(dice))+"']\n");
    fprintf(fid, "Dice STD ['"+num2str(std(dice))+"']\n\n");

    fprintf(fid, "NSD AVG ['"+num2str(mean(nsd))+"']\n");
    fprintf(fid, "NSD MAX ['"+num2str(max(nsd))+"']\n");
    fprintf(fid, "NSD MIN ['"+num2str(min(nsd))+"']\n");
    fprintf(fid, "NSD STD ['"+num2str(std(nsd))+"']\n\n\n");

end

fprintf(fid, "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n");

brains = metrics("brains");

for i=1:max(size(brains))
    fprintf(fid, "Migliori prestazioni per campione ['"+brains(i)+"']\n\n");
    data = metrics(num2str(brains(i)));
fprintf(fid, "Dice: "+data.dice+" | Transformazione: "+data.transform_dice+" | Segmentazione: "+data.segmentation_dice+"\n");
fprintf(fid, "NSD: " +data.nsd+ " | Transformazione: "+data.transform_nsd+ " | Segmentazione: "+data.segmentation_nsd+"\n\n");
end

fclose(fid);