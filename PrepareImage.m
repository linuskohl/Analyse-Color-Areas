% ------------------------------
% Copyright (c), 2016, Linus Kohl <linus.kohl@mytum.de>
% All rights reserved.
% ------------------------------

function [rgbImage] = PrepareImage(imageFile)
    % ColorMap values are rescaled into the range [0,1]
    [rgbImage, colorMap] = imread(imageFile); 
    [rows, columns, depth] = size(rgbImage); 
    if strcmpi(class(rgbImage), 'uint8')
      is8bit = true;
    else
      is8bit = false;
    end
    if depth == 1
      % if not an indexed image
      if isempty(colorMap)
        rgbImage = cat(3, rgbImage, rgbImage, rgbImage);
      else
        % convert indexed image to RGB image
        rgbImage = ind2rgb(rgbImage, colorMap);
        if is8bit == true
          % multiply by 255 then convert to 8bit RGB
          rgbImage = uint8(255 * rgbImage);
        end
      end
    end 
    return;
end