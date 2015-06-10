function [] = prova(Db, Cent, C, width)
    % Dist function:
    %   0 - Euclidean distance
    %   1 - Mahalanobis (DEPRECATED)
    %   2 - Gaussian (ie, exp(mahalanobis) divided by sqrt(det(Cov)) )
    distType = 0;

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

    CLP_ImgFromLabels(Cent, Labels, width);
    
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
