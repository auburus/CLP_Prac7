function [Img] = CLP_ImgFromLabels(Cent, Labels, Width)
    
    if (mod(length(Labels), Width) ~= 0)
        error('Invalid width for this labels')
    end
    
    classes = unique(Labels);
    RowImg = zeros(3, length(Labels));

    NormalizedCent = Cent ./ 255;

    % substitute each Label for it's centroid
    for j = classes
        RowImg(:, Labels == j) = repmat(NormalizedCent(:, j), 1, sum(Labels == j));
    end
    RowImg = RowImg';
    Img = zeros(length(Labels)/Width, Width, 3);
    
    % Transform the matrix Nx3 to N/Width, Width 3
    for i = 1:length(Labels)/Width
        Img(i, :, :) = RowImg((Width*(i-1) + 1):Width*i , :);
    end
    image(Img);
end

