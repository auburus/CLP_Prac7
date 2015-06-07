function [Cent, Labels, Variances] = CLP_KMeans(Db, C)
    % Threshold: Value of the square distance to check if a centroid has
    % moved or not
    threshold = 0.0001;

    % Cost function:
    %   0 - Euclidean distance
    %   1 - Mahalanobis
    costFunction = 0;

    N = length(Db);
    Labels = zeros(N, 1);
    
    % Initialize Centroids
    indexPerm = randperm(N);
    Cent = Db(:, indexPerm(1:C));
    LastCent = Cent;

    for j = 1:C
        % SavedCent is created to plot the Centroides route around the plot
        SavedCent{j} = Cent(:, j);

        % Initialize variances to a identity matrix
        Variances{j} = eye(length(Db(:, 1)));
    end

    tic
    for a = 1:100
        fprintf("Iteration %d\n", a);

        %%%%% Classify data into clusters %%%%%
        for j = 1:C
            switch costFunction
                case 0 % Euclidean
                    distances(j, :) = euclidean(Db, Cent(:, j));
                case 1 % Mahalanobis
                    distances(j, :) = mahalanobis(Db, Cent(:, j), Variances{j});
            end
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
            if euclidean(LastCent(:, j), Cent(:, j)) > threshold
                haveBeenMoved = true;
            end
        end

        if ~haveBeenMoved
            break;
        else
            LastCent = Cent;
        end
    end

    fprintf('There has been %d iterations before algorithm converged in %f seconds\n', a, toc);

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

% Returns a row vector with the euclidean distance between data points
% and the centroid.
% Vectors in data and centroid MUST be a column vector
function d = euclidean(Data, Centroid)
    d = sum(bsxfun(@minus, Data, Centroid).^2);
end

% Returns a row vector with the mahalanobis distance between data points
% and the centroid.
% Vectors in data and centroid MUST be a column vector
function d = mahalanobis(Data, Centroid, Cov)
    Aux = num2cell(bsxfun(@minus, Data, Centroid), 1);
    InvCov = inv(Cov);
    d = cellfun(@(Vec) Vec' * InvCov * Vec, Aux);
end

