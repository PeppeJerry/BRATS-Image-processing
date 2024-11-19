function z = data_process(x, Y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%
% Configurazioni %
%%%%%%%%%%%%%%%%%%

% Visualize %
L = 10;
slice = 64;

% Histogram Equalization %
HEqual_param.type = "EXP_DESC";    % PDF
HEqual_param.Lambda = 0.3;        % Lambda
HEqual_param.N = 256;              % Scale
HEqual_param.Gamma = 3;            % Gamma

% PCA %
T = 0.97;

% Gaussian Filter %
sigma = 0.6;

% Homomorphic Filter %
HFilter_param.type = "GAUSSIAN";    % Filter Type
HFilter_param.D0 = 1.5;             % Cutoff frequency
HFilter_param.gammaL = 5;           % Low frequenze 5
HFilter_param.gammaH = 13;          % High frequenze 13

% Discrete Wavelet Transform %
dwt_param.level = 10;               % Decomposition Level
dwt_param.wname = 'db8';            % Wavelet

% Log Transform %
Log_param.c = 100;
Log_param.N = 255;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%
% Preprocess Dati %
%%%%%%%%%%%%%%%%%%%
cd("Functions\Preprocess\");

% Min Max Normalization %
minMax = minmax(x);

% Histogram Equalization %
HE = HistogramEqualization(minMax, HEqual_param);

% PCA %
pca = PCA(HE,T);

% Gaussian Filter %
x_gauss = imgaussfilt3(pca, sigma);

% Visualizzazione %
figure(L);
subplot(1,4,1);
imshow(minMax(:,:,slice),[]);
title("minMax")

subplot(1,4,2);
imshow(HE(:,:,slice),[]);
title("Histogram Equalization")

subplot(1,4,3);
imshow(pca(:,:,slice),[]);
title("PCA")

subplot(1,4,4);
imshow(x_gauss(:,:,slice),[]);
title("Gaussian Filter")

dims = [size(x), 5];
z = zeros(dims);
z(:,:,:,1) = x_gauss;

% Pulizia delle variabili %
clear minMax HE pca x_gauss x x_gauss;
clear HEqual_param T sigma;

cd("..\..");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%
% Trasformazioni Dati %
%%%%%%%%%%%%%%%%%%%%%%%
cd("Functions\Transform");

% Inverted %
z(:,:,:,2) = Invert(z(:,:,:,1));

% Homomorphic Filter %
z(:,:,:, 3) = HomomorphicFilter(z(:,:,:,1), HFilter_param);

% Log Transform %
z(:,:,:, 4) = LogTransform(z(:,:,:,2), Log_param);

% Discrete Wavelet Transform %
z(:,:,:, 5) = DiscreteWaveletTransform(z(:,:,:,1), dwt_param);

figure(L+1);
subplot(2,3,1);
imshow(z(:,:,slice,1),[]);
title("X")

subplot(2,3,2);
imshow(z(:,:,slice,2), []);
title("Inverted")

subplot(2,3,3);
imshow(z(:,:,slice, 3),[]);
title("Homomorphic Filter")

subplot(2,3,4);
imshow(z(:,:,slice,4),[]);
title("Log Transform")


subplot(2,3,5);
imshow(z(:,:,slice,5),[]);
title("Discrete Wavelet Transform")

subplot(2,3,6);
imshow(Y(:,:,slice), []);
title("Tumour")
cd("../..");
end

function map = segmentation(x,Y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%
% Segmentazione %
%%%%%%%%%%%%%%%%%
cd("Functions\Segmentation\")

K.Kmeans = 3;
K.Otsu = 2;
K.GMM = 3;

L = 20;
slice = 64;

dims = [size(x),3];
map = zeros(dims);

[map(:,:,:,1)] = Kmeans(x, K.Kmeans);

[map(:,:,:,2), ~] = OtsuThreshold(x, K.Otsu);

[map(:,:,:,3)] = GMM(x, K.GMM);

figure(L+1);

subplot(1,4,1);
imshow(map(:,:,slice,1), []);
title("Kmeans");

subplot(1,4,2);
imshow(map(:,:,slice,2), []);
title("Otsu");

subplot(1,4,3);
imshow(map(:,:,slice,3), []);
title("GMM");

subplot(1,4,4);
imshow(Y(:,:,slice), []);
title("Tumour");

cd("..\..");
end



% Scelgo un numero casuale di sample tra i campioni disponibili
N = 484;
MaxSample = 10;
% getRandomSample = randperm(N, MaxSample);
getRandomSample = [371, 328, 308, 307, 277, 262, 205, 139, 92, 44];

for i = 1:MaxSample

    % Generazione del nome
    cd("Functions\Utility\");
    name = normalizeName(getRandomSample(i));
    cd("..\..\")
    folderx = "./Task01_BrainTumour/x/gz/"+name;
    folderY = "./Task01_BrainTumour/Y/gz/"+name;

    % Leggo il file .nii
    x = niftiread(folderx);
    Y = niftiread(folderY);

    % Caso FLAIR
    x = x(:,:,:,1);
    z = data_process(x, Y);

   for j = 1:5
       allowedTransformation = [2,3,4];
       if ~ismember(j,allowedTransformation)
           continue;
       end
       map = segmentation(z(:,:,:,j), Y);
       
       for k = 1:3
           cd("Functions\Utility\");
           name = ...
               getRandomSample(i)    + "_" +...
               transformationWith(j) + "_" +...
               segmentationWith(k)   + ".nii";
           cd("../../");

           output = "./Evaluation/Samples/"+name;
           niftiwrite(map(:,:,:,k), output);
       end

    end 

end
