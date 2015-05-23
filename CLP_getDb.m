function [Db, C] = CLP_getDb(N)
    Centers = [[1, 1]', [1, -1]', [-1, -1]', [-1, 1]'];
    C = length(Centers);
    
    class = randperm(C)(1);
    sigma = 0.5;

    Db = normrnd(Centers(:, class), sigma);
    for i = 1:N
        class = randperm(C)(1);
        Db = [Db, normrnd(Centers(:, class), sigma)];
    end
end
