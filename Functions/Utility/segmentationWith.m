function name = segmentationWith(num)
        switch num
            case 1
                % Caso K-means %
                name = "KMeans";
            case 2
                % Caso Otsu %
                name = "Otsu";
            case 3
                % Caso Gaussian Mixture Model %
                name = "GMM";
            case 4
                % Caso Watershed %
                name = "WShed";
            case 5
                % Caso Tumour %
                name = "Tumour";
            otherwise
                disp('Errore');
                name = "ERROR";
        end
end