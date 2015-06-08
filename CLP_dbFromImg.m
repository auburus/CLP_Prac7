function [Db, width] = CLP_dbFromImg(name)
    Db = [];
    if exist(name, 'file')
        [X, map] = imread(name);
        [height, width, depth] = size(X);
        if ~isempty(map)
            % Unable to test this case, because I 
            % haven't found an image which enters here
            Im = ind2rgb(X, map);
            printf('Is not empty :D');
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
