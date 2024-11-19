function x = HistogramEqualization(x, param)

dims = size(x);         % Dimensioni originali
x = reshape(x, [], 1);  % 3D > 1D

if isfield(param, 'type') && param.type ~= "DEFAULT"
    cdf = cdf_HE(param);
    x = histeq(x, cdf);
else
    x = histeq(x);
end

x = reshape(x, dims);   % 1D > 3D
end


function cdf = cdf_HE(param)

% Valore di Default di N
if ~isfield(param, 'N')
    param.N = 256;
end

switch param.type
    case 'LINEAR_DESC'
        cdf = linspace(1, 0, param.N);

    case 'EXP_DESC'
        if ~isfield(param, 'Lambda')
            param.Lambda = 0.05;
        end
        cdf = exp(-param.Lambda * (0:param.N-1));

    case 'POWER_LAW'
        if ~isfield(param, 'Gamma')
            param.Gamma = 2;
        end
        cdf = (param.N - (0:param.N-1)).^param.Gamma;


    case 'DEFAULT_N'
        cdf = ones(param.N, 1);
    otherwise
        cdf = ones(256, 1);
end
cdf = cdf / sum(cdf);
%cdf = cumsum(cdf);
end