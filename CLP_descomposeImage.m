function [Y] = CLP_descomposeImage(name)
    if exist(name, 'file')
        [X, map] = imread(name);

        [height, width, depth] = size(X)
        for j=1:depth
            for k = 1:depth
                if k == j
                    Y(:, :, k) = X(:, :, k);
                else
                    Y(:, :, k) = 0;
                end
            end
            % Show the image
            figure
            image(Y);
        end

    end
end
