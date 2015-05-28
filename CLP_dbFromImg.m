function [Db] = CLP_dbFromImg(name)
    Db = [];
    if exist(name, 'file')
        [X, map] = imread(name);

        if ~isempty(map)
            % Unable to test this case, because I 
            % haven't found an image which enters here
            Im = ind2rgb(X, map);
            printf('Is not empty :D');
        else
            % So, image have it's RGB values in the columns
            % An image 512 x 512 returns an X of [512, 1536]
            % so, we transform this image to our DB
            size(X)
            
            for i = 1:3
                A = X(:, :, i)';
                Db(i, :) = A(:);
            end
            size(Db)
        end
    end
end
