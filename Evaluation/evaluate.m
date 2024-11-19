% Prendo i file già segmentati precedentemente dal main.py
% Che sono stati processati dal processed/process.m

reports = "reports/";

folder = "./Samples/processed/";
files = dir(folder);
files = files(~[files.isdir] & endsWith({files.name}, '.nii'));

timestamp = num2str(round(posixtime(datetime('now')))); % Timestamp in secondi
report = ['report_' timestamp '.json'];
fid = fopen(reports + report, 'w');
fprintf(fid, '[]');
fclose(fid);

for i = 1:size(files)
    % Prendo il nome %
    name = files(i).name;

    % Genero i percorsi dei file interessati %
    filex = folder + name;
    info = strsplit(name, '_');
    tmp = str2num(info{1});
    cd("../Functions/Utility");
    filey = "../Task01_BrainTumour/Y/gz/"+normalizeName(tmp);
    cd("../../Evaluation/");

    % Genero le informazioni necessarie per le statistiche finali %
    tmp = strsplit(info{end},'.');
    info{end} = tmp{1};

    % Recupero i file .nii segmentati per il confronto %
    x = niftiread(filex);
    x = uint8(x);
    Y = niftiread(filey);
    Y(Y ~= 0) = 1; % Necessario per normalizzare i valori di Y

    %subplot(1,2,1);
    %imshow(x(:,:,64), []);
    %title("x");

    %subplot(1,2,2);
    %imshow(Y(:,:,64), []);
    %title("Y");

    dice = DSC(x,Y);
    nsd = NSD(x,Y,5);

    % Aggiornamento del file JSON

    new_entry = struct( ...
        'brain'     ,   info{1}, ...
        'transform' ,   info{2}, ...
        'segmentation', info{3}, ...
        'dice'      , dice,      ...
        'nsd'       , nsd        ...
        );

    % Leggi il contenuto attuale del file JSON e aggiorna i dati
    data = jsondecode(fileread(reports+report));
    data = [data; new_entry];

    % File aggiornato
    fid = fopen(reports+report, 'w');
    fprintf(fid, '%s', jsonencode(data, 'PrettyPrint', true));
    fclose(fid);

end