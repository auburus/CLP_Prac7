function [] = prova(Db, Cent, C, width)
    for j=1:C
        distances(j, :) = CLP_getDistances(0, Db, Cent(:, j), []);
    end
    
    [MinDist, Labels] = min(distances);

    CLP_ImgFromLabels(Cent, Labels, width);
    
end
