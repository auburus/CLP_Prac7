function [Cent, Labels, Variances] = CLP_KMeans(Db, C)
    N = length(Db);
    Labels = zeros(N, 1);

    indexPerm = randperm(N);
    Cent = Db(:, indexPerm(1:C));
    LastCent = Cent;
    threshold = 0.00001;

    distMin = 100000;

    for j = 1:C
        SavedCent{j} = Cent(:, j);

        % Initialize variances to a identity matrix
        Variances{j} = eye(length(Db(:, 1)));
    end

    for a = 1:100
        %%%%% Classify data into clusters %%%%%
        tic
        for i = 1:N
            [A, B] = min( sum(bsxfun(@minus, Db(:, i), Cent).^2));
            Labels(i) = B;
        end
        ClassifyInClusters = toc

        %%%%% Recalcule Cluster centroids %%%%%
        %tic
        Cent = zeros(length(Db(:, 1)), C);
        itemsInClass = zeros(C, 1);

        for j = 1:C
            itemsInClass(j) = sum(Labels == j);
            if itemsInClass(j) ~= 0
                Cent(:, j) = sum(Db(:, Labels == j)')' ./ itemsInClass(j);
            end
            SavedCent{j} = [SavedCent{j}, Cent(:, j)];
        end
     
        %RecalculateClusterCentroids = toc

        %%%%% Recalculate Cluster Variances %%%%% (Don't do it for now)
        tic
        if(true)
            %%%% Optimized version %%%%% (about 50% faster)
            %for j = 1:C
            %    if itemsInClass(j) ~= 0
            %        Variances{j} = zeros(length(Db(:, 1)));
            %        Aux = bsxfun(@minus, Db(:, Labels == j), Cent(:, j));
            %        for i = 1:itemsInClass(j)
            %            Variances{j} = Variances{j} + Aux(:, i) * Aux(:, i)';
            %        end

            %        Variances{j} = Variances{j} ./ itemsInClass(j);
            %    end
            %end
            
            %%%%% Normal version %%%%%
            %for i = 1:N
            %    Variances{Labels(i)} = Variances{Labels(i)} + (Db(:, i) - Cent(:, Labels(i))) * (Db(:, i) - Cent(:, Labels(i)))';
            %end

            %for j = 1:C
            %    if itemsInClass(j) ~= 0
            %        Variances{j} = Variances{j} ./ itemsInClass(j);
            %    end
            %end
        end
        RecalculateClusterVariances = toc

        %%%%% Check if clusters centroids have been moved %%%%%
        %tic
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
        %TimeInCheckCentroidesMoved = toc
        %return
    end
%     tic   
    fprintf('There has been %d iterations before algorithm converged\n', a);
    return
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
%     PlotAll = toc
end

function d = sqDist(X, Y)
    vec = X-Y;
    d = vec' * vec;
end

function format = getFormatFromLabels(Labels)
    Colors = {'+b', '+m', '+g', '+c', '+k', '+y'};
    format = {};

    for i = 1:length(Labels)
        format{i} = Colors{mod(Labels(i), length(Colors)) + 1};
    end
end



% Db = [[1,0]', [0,1]', [0, -1]', [-1, -1]'];
% [Cent, Labels] = CLP_KMeans(Db, 2)

