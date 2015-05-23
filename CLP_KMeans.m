function [Cent, Labels] = CLP_KMeans(Db, C)
    N = length(Db);
    Labels = zeros(N, 1);

    indexPerm = randperm(N);
    Cent = Db(:, indexPerm(1:C));

    distMin = 100000;

    for j = 1:C
        SavedCent{j} = Cent(:, j);
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

        % Recalcule Cluster centroids
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

    end

    % Print data and centroids route
    figure
    plot(Db(1, :), Db(2, :), '+b') % Database
    hold on

    % Centroids
    for j = 1:C
        plot(SavedCent{j}(1, :), SavedCent{j}(2, :), '*-r')
        hold on
    end
end

function d = sqDist(X, Y)
    vec = X-Y;
    d = vec' * vec;
end

% Db = [[1,0]', [0,1]', [0, -1]', [-1, -1]'];
% [Cent, Labels] = CLP_KMeans(Db, 2)

