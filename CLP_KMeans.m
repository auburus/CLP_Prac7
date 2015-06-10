function [Cent, Labels, Variances] = CLP_KMeans(Db, C)
    % Threshold: Value of the square distance to check if a centroid has
    % moved or not
    threshold = 1;

    % Dist function:
    %   0 - Euclidean distance
    %   1 - Mahalanobis (DEPRECATED)
    %   2 - Gaussian (ie, exp(mahalanobis) divided by sqrt(det(Cov)) )
    distType = 0;

    % Plot points
    plotPoints = 1;


    %%%%%%%%%%%%%%%%%%%%%%%%
    Labels = zeros(length(Db), 1);
    
    % Initialize Centroids
    Aux = unique(Db', 'rows')';
    indexPerm = randperm(length(Aux));
    Cent = Aux(:, indexPerm(1:C));
    % Cent = Aux(:, 1:C);

    % Initialize variances
    % Variances = cell(C);

    % Initialize mean distance
    meanDist = [];

    for j = 1:C
        % SavedCent is created to plot the Centroides route around the plot
        SavedCent{j} = Cent(:, j);

       % Initialize variances to a identity matrix
        Variances{j} = eye(length(Db(:, 1)));
    end
    LastCent = Cent;
    LastVariances = Variances;

    tic
    for a = 1:100
        fprintf('Iteration %d\n', a);

        %%%%% Classify data into clusters %%%%%
        for j = 1:C
            switch distType
                case 0 % Euclidean
                    distances(j, :) = euclidean(Db, Cent(:, j));
                case 1 % Mahalanobis
                    distances(j, :) = mahalanobis(Db, Cent(:, j), Variances{j});
                case 2 % Gaussian
                    distances(j, :) = gaussian(Db, Cent(:, j), Variances{j});
            end
        end
        switch distType
            case 0
                [MinDist, Labels] = min(distances);
            case 1
                [MinDist, Labels] = max(distances);
            case 2
                [MinDist, Labels] = max(distances);
        end
        meanDist = [meanDist, mean(MinDist)];

        %%%%% Recalculate Cluster centroids %%%%%
        Cent = zeros(length(Db(:, 1)), C);
        itemsInClass = zeros(C, 1);

        for j = 1:C
            itemsInClass(j) = sum(Labels == j);
            if itemsInClass(j) > 0
                Cent(:, j) = mean(Db(:, Labels == j)')';
            end
            SavedCent{j} = [SavedCent{j}, Cent(:, j)];
        end

        %%%%% Recalculate Cluster Variances %%%%% 
        for j = 1:C
            if itemsInClass(j) > 0
                Variances{j} = cov(Db(:, Labels == j)');
                if cond(Variances{j} > 1e15)
                    Variances{j} = LastVariances{j};
                end
            end
        end

        %%%%% Check if clusters centroids have been moved or variances have varied (pun intended)%%%%%
        haveBeenMoved = false;
        for j = 1:C
            if euclidean(LastCent(:, j), Cent(:, j)) > threshold
                haveBeenMoved = true;
                break;
            end
            
            Aux = Variances{j} - LastVariances{j};
            if trace(sqrt(Aux'*Aux)) > threshold
                haveBeenMoved = true;
                break;
            end
        end

        if ~haveBeenMoved
            break;
        else
            LastCent = Cent;
            LastVariances = Variances;
        end
    end

    fprintf('There have been %d iterations before algorithm converged in %f seconds\n', a, toc);

    % Print data and centroids route
    if (plotPoints && length(Db(:, 1)) == 2)
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
    elseif (plotPoints && length(Db(:, 1)) == 3)
        figure
         
        Colors = {'+b', '+m', '+g', '+c', '+k', '+y'};

        for j = 1:C
            Aux = Db(:, Labels == j);
            plot3(Aux(1, :), Aux(2, :), Aux(3, :), Colors{mod(j-1, length(Colors)) +1});
            hold on

            % Print Centroids
            plot3(SavedCent{j}(1, :), SavedCent{j}(2, :), SavedCent{j}(3, :), '*-r')
            hold on
        end
    end

    % Plot meandist graph
    figure
    plot(1:length(meanDist), meanDist, 'b');

end

% Returns a row vector with the euclidean distance between data points
% and the centroid.
% Vectors in data and centroid MUST be a column vector
function d = euclidean(Data, Centroid)
    d = sqrt(sum(bsxfun(@minus, Data, Centroid).^2));
end

% Returns a row vector with the mahalanobis distance between data points
% and the centroid.
% Vectors in data and centroid MUST be a column vector
function d = mahalanobis(Data, Centroid, Cov)
    Aux = num2cell(bsxfun(@minus, Data, Centroid), 1);
    InvCov = inv(Cov);

    d = cellfun(@(Vec) Vec' * InvCov * Vec, Aux);
end

function d = gaussian(Data, Centroid, Cov)
    aux = sqrt(det(Cov));

    d = exp((-0.5) * mahalanobis(Data, Centroid, Cov));
    d = d ./ aux;
end
