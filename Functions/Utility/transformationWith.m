function name = transformationWith(num)
        switch num
            case 1
                % Caso X %
                name = "X";
            case 2
                % Caso Inverted %
                name = "Inv";
            case 3
                % Caso Homomorphic Filter %
                name = "HF";
            case 4
                % Caso Log Transform %
                name = "Log";
            case 5
                % Caso DWT %
                name = "DWT";
            otherwise
                disp('Errore');
                name = "ERROR";
        end
end