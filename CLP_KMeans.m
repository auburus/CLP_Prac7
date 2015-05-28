function [Cent, Labels, Variances] = CLP_KMeans(Db, C)
    N = length(Db);
    Labels = zeros(N, 1);

    indexPerm = randperm(N);
    Cent = Db(:, indexPerm(1:C));
    LastCent = Cent;
    threshold = 0.1;

    distMin = 100000;

    for j = 1:C
        SavedCent{j} = Cent(:, j);

        % Initialize variances to a identity matrix
        Variances{j} = eye(length(Db(:, 1)));
    end

    for a = 1:100
        % Classify data into clusters
        for i = 1:N
            distMin = sqDist(Db(:, i), Cent(:, 1));
            Labels(i) = 1;

            for j = 1:C
                if sqDist(Db(:, i), Cent(:, j)) < distMin
                    distMin = sqDist(Db(:, i), Cent(:, j));
                    Labels(i) = j;
                end
            end
        end

        %%%%% Recalcule Cluster centroids %%%%%
        Cent = zeros(length(Db(:, 1)), C);
        itemsInClass = zeros(C, 1);

        for i = 1:N
            Cent(:, Labels(i)) += Db(:, i);
            itemsInClass(Labels(i)) += 1;
        end
     
        for j = 1:C
            Cent(:, j) = Cent(:, j) ./ itemsInClass(j);
            % Save Centroid position
            SavedCent{j} = [SavedCent{j}, Cent(:, j)];
        end

        %%%%% Recalculate Cluster Variances %%%%%
        for j = 1:C
            Variances{j} = zeros(length(Db(:, 1)));
        end

        for i = 1:N
            Variances{Labels(i)} += (Db(:, i) - Cent(:, Labels(i))) * (Db(:, i) - Cent(:, Labels(i)))';
        end

        for j = 1:C
            Variances{j} = Variances{j} ./ itemsInClass(j);
        end

        %%%%% Check if clusters centroids have been moved %%%%%
        haveBeenMoved = false;
        for j = 1:C
            if sqDist(LastCent(:, j), Cent(:, j)) > threshold
                haveBeenMoved = true;
            end
        end

        if !haveBeenMoved
            break;
        else
            LastCent = Cent;
        end 
    end
    
    printf("There has been %d iterations before algorithm converged\n", a);

    % Print data and centroids route
    figure
    format = getFormatFromLabels(Labels);
    for i = 1:length(Labels)
        plot(Db(1, i), Db(2, i), format{i}) % Database
        hold on
    end

    % Print Centroids
    for j = 1:C
        plot(SavedCent{j}(1, :), SavedCent{j}(2, :), '*-r')
        hold on
    end
end

function d = sqDist(X, Y)
    vec = X-Y;
    d = vec' * vec;
end

function format = getFormatFromLabels(Labels)
    Colors = {'+b', '+m', '+g', '+c', '+k', '+y'};
    format = {};

    for i = 1:length(Labels)
        format(i) = Colors{mod(Labels(i), length(Colors)) + 1};
    end
end



% Db = [[1,0]', [0,1]', [0, -1]', [-1, -1]'];
% [Cent, Labels] = CLP_KMeans(Db, 2)

