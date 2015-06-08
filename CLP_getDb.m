function [Db, C] = CLP_getDb(N)
    Centers = [[1, 1]', [1, -1]', [-1, -1]', [-1, 1]'];
    C = length(Centers);
    sigma = [0.5 0.75 0.4 0.3];
    % sigma = [0.5 0.5 0.5 0.5];

    % Elements of each class
    Labels = randi(C, N, 1);


    % Create database
    Db = [];
    for j = 1:C
        Db = [Db, normrnd(repmat(Centers(:, j), 1, sum(Labels == j)), sigma(j))];
    end
    
    %randomize elements inside database
    perm = randperm(N);
    Db = Db(:, perm);
end
