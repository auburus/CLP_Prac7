function [Img] = CLP_ImgFromLabels(Cent, Labels, Width)
    
    if (mod(length(Labels), Width) ~= 0)
        error('Invalid width for this labels')
    end
    
    classes = unique(Labels);
    RowImg = zeros(3, length(Labels));

    NormalizedCent = Cent ./ 255;

    % Substitute each label for its centroid
    for j = classes
        RowImg(:, Labels == j) = repmat(NormalizedCent(:, j), 1, sum(Labels == j));
    end
    RowImg = RowImg';


    % Transform the matrix [N,3] to [N/Width, Width, 3]
    Img = zeros(length(Labels)/Width, Width, 3);
    for i = 1:length(Labels)/Width
        Img(i, :, :) = RowImg((Width*(i-1) + 1):Width*i , :);
    end

    % Show the image
    figure
    image(Img);
end

