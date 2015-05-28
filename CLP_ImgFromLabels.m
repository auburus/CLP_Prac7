function [Img] = CLP_ImgFromLabels(Cent, Labels, Width)
    
    if (mod(length(Labels), Width) ~= 0)
        error('Invalid width for this labels')
    end
    
    Img = zeros(length(Labels)/Width, Width, 3);
    
    y = 1;
    x = 1;
    for i = 1:length(Labels)
        Img(y, x, : ) = Cent(:, Labels(i))./255;
        
        x = x+1;
        if (mod(x, Width+1) == 0)
            x = 1;
            y = y + 1;
        end
        
        
    end
    image(Img);
end

