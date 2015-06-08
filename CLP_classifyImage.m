function [] = CLP_classifyImage(filename, C)
    [Db, width] = CLP_dbFromImg(filename);

    [Cent, Labels, Variances] = CLP_KMeans(Db, C);

    CLP_ImgFromLabels(Cent, Labels, width);
end
