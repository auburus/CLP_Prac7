function [Cent, Labels, Variances] = CLP_KMeans(Db, C)
    % Threshold: Value of the square distance to check if a centroid has
    % moved or not
    threshold = 0.000001;


    N = length(Db);
    Labels = zeros(N, 1);
    
    % Initialize Centroids
    indexPerm = randperm(N);
    Cent = Db(:, indexPerm(1:C));
    LastCent = Cent;

    for j = 1:C
        SavedCent{j} = Cent(:, j);

        % Initialize variances to a identity matrix
        Variances{j} = eye(length(Db(:, 1)));
    end

    tic
    for a = 1:100
        fprintf("Iteration %d\n", a);

        %%%%% Classify data into clusters %%%%%
        for j = 1:C
            distances(j,:) = sum(bsxfun(@minus, Db, Cent(:, j)).^2);
        end
        [A, Labels] = min(distances);

        %%%%% Recalcule Cluster centroids %%%%%
        Cent = zeros(length(Db(:, 1)), C);
        itemsInClass = zeros(C, 1);

        for j = 1:C
            itemsInClass(j) = sum(Labels == j);
            if itemsInClass(j) ~= 0
                Cent(:, j) = sum(Db(:, Labels == j)')' ./ itemsInClass(j);
            end
            SavedCent{j} = [SavedCent{j}, Cent(:, j)];
        end

        %%%%% Recalculate Cluster Variances %%%%% (Don't do it for now)
        for j = 1:C
            Variances{j} = cov(Db(:, Labels == j)');
        end

        %%%%% Check if clusters centroids have been moved %%%%%
        haveBeenMoved = false;
        for j = 1:C
            if sqDist(LastCent(:, j), Cent(:, j)) > threshold
                haveBeenMoved = true;
            end
        end

        if ~haveBeenMoved
            break;
        else
            LastCent = Cent;
        end
    end

    fprintf('There has been %d iterations before algorithm converged in %d seconds\n', a, toc);

    % Print data and centroids route
    if (length(Db(:, 1)) == 2)
        figure

        Colors = {'+b', '+m', '+g', '+c', '+k', '+y'};
        for j = 1:C
            % Print points
            Aux = Db(:, Labels == j);
            plot(Aux(1, :), Aux(2, :), Colors{mod(j-1, length(Colors)) + 1});
            hold on

            % Print Centroids
            plot(SavedCent{j}(1, :), SavedCent{j}(2, :), '*-r')
            hold on
        end
    end
end

function d = sqDist(X, Y)
    vec = X-Y;
    d = vec' * vec;
end
