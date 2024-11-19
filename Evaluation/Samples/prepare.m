function name = normalizeName(num)
    if num < 100
        if num < 10
            num = "00"+num;
        else
            num = "0"+num;
        end
    end
    name="BRATS_"+num+".nii";
end

% Prendo i file .nii già segmentati
files = dir("./");
files = files(~[files.isdir] & endsWith({files.name}, '.nii'));

for i = 1:size(files)

    % Prendo il nome %
    name = files(i).name;
    y = strsplit(name, '_');
    y = normalizeName(str2num(y{1}));
    Y = niftiread("../../Task01_BrainTumour/Y/gz/"+y);
    x = niftiread(name);

    % Prendo il valore degli angoli della matrice 3D (8 pixel) %
    vortex = [
        x(1, 1, 1),
        x(1, 1, end),
        x(1, end, 1),
        x(1, end, end),
        x(end, 1, 1),
        x(end, 1, end),
        x(end, end, 1),
        x(end, end, end),
    ];

    % Il valore più comune tra gli angoli è identificato come background %
    background = mode(vortex);

    % Genero la maschera di background
    background_mask = (x == background);
    num_classes = max(x(:));

    % Inizializzo un vettore di pixel adiacenti tra classi %
    boundary_counts = zeros(1, num_classes);

    % Filtro 3D di convoluzione per trovare i vicini
    neighborhood_filter = ones(3, 3, 3);  

    % Escludiamo il pixel centrale
    neighborhood_filter(2, 2, 2) = 0;

    % Trova i pixel confinanti per ogni classe
    for class = 1:num_classes
        % Salta il caso della classe di background
        if class == background
            continue;
        end
    
        % Maschera per la classe corrente
        class_mask = (x == class);
    
        % Trova i pixel confinanti tra la classe e il background
        % facendo la convoluzione della maschera del background
        % con il filtro dei vicini e moltiplicandola per la maschera della classe
        boundary_with_bg = convn(double(background_mask), neighborhood_filter, 'same') .* class_mask;
    
        % Conta i pixel confinanti
        boundary_counts(class) = sum(boundary_with_bg(:) > 0);
    end
    
    % Determino la classe brain
    [~, brain] = max(boundary_counts);

    % Determino la classe del tumore
    tumour = [1,2,3];
    tumour(ismember(tumour, [brain, background])) = [];

    % Il tumore assume valore 1, mentre i rimanenti 0
    z = zeros(size(x));
    z(x == tumour) = 1;

    subplot(1,3,1);
    imshow(x(:,:,64), []);
    title("x");
    subplot(1,3,2);
    imshow(Y(:,:,64), []);
    title("Y");
    subplot(1,3,3);
    imshow(z(:,:,64), []);
    title("z");

    % Salvo il file dei processati e lo elimino da /Samples %
    niftiwrite(z,"./processed/"+name);
    delete(name);

end