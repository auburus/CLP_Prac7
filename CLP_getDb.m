function [Db, C] = CLP_getDb(N)
    Centers = [[1, 1]', [1, -1]', [-1, -1]', [-1, 1]'];
    C = length(Centers);
    
    sigma = 0.5;
    
    Db = zeros(length(Centers(:,1)), N);
    
    for i = 1:N
        aux = randperm(C);
        Db(:, i) = normrnd(Centers(:, aux(1)), sigma);
    end
end
