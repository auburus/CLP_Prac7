function [Db, width] = CLP_dbFromImg(name)
    Db = [];

    if exist(name, 'file')
        [X, map] = imread(name);
        [height, width, depth] = size(X);

        if ~isempty(map)
            % Case for images with an information map. 
            % At the time of writting this, it hasn't been
            % used in any image.

            Im = ind2rgb(X, map);
        else
            % So, image have it's RGB values in the depth
            % An image 512 x 512 returns an X of [512, 512, 3]
            % so, we transform this image to our DB, [3, 512x512]
            
            for i = 1:3
                A = X(:, :, i)';
                Db(i, :) = A(:);
            end
        end
    end
end
