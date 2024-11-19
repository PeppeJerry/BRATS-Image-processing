%folder = './x/';
%folder = './Y/';
folder = './NoY/';

output = folder + "gz/";

files = dir(fullfile(folder, '*.gz'));

for i = 1:length(files)
    File = fullfile(folder, files(i).name);
    gunzip(File, output);
end
disp('Tutti i file sono stati estratti con successo.');