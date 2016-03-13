% Create a filter mask based HSV values 
% ------------------------------
% Copyright (c), 2016, Linus Kohl <linus.kohl@mytum.de>
% All rights reserved.
% ------------------------------

function [filter_mask] = GenFilterMask(rgbImage, hsvFilter)
    % convert image to hsv
    hsvImage = rgb2hsv(rgbImage);
    hI = hsvImage(:,:,1);
    sI = hsvImage(:,:,2);
    vI = hsvImage(:,:,3);
    % minimal size of areas
    minAreaSize = 50;
    
    %[hueCounts, hueBinValues] = imhist(hImage); 
    %maxHueBinValue = find(hueCounts > 0, 1, 'last'); 
    %maxCountHue = max(hueCounts); 
    %[saturationCounts, saturationBinValues] = imhist(sImage); 
    %maxSaturationBinValue = find(saturationCounts > 0, 1, 'last'); 
    %maxCountSaturation = max(saturationCounts); 
    %[valueCounts, valueBinValues] = imhist(vImage); 
    %maxValueBinValue = find(valueCounts > 0, 1, 'last'); 
    %maxCountValue = max(valueCounts); 
    %maxCount = max([maxCountHue,  maxCountSaturation, maxCountValue]); 
    %maxGrayLevel = max([maxHueBinValue, maxSaturationBinValue, maxValueBinValue]); 
    
    x = hsvFilter;
    % hMin, hMax have to be in range 1-100
    % converting the values from 0-360

    
    hMin = (1/360)*double(hsvFilter(2));
    hMax = (1/360)*double(hsvFilter(3));
    % create the filter
    hueMask =        (hI >= hMin) & (hI <= hMax);
    saturationMask = (sI >= double(hsvFilter(4))) & (sI <= double(hsvFilter(5)));
    valueMask =      (vI >= double(hsvFilter(6))) & (vI <= double(hsvFilter(7)));
    % combine filters
    filter_mask = uint8(hueMask & saturationMask & valueMask);
    % delete small areas
    % http://uk.mathworks.com/help/images/ref/bwareaopen.html
    filter_mask = uint8(bwareaopen(filter_mask, minAreaSize));
    % morphological connect areas
    se = strel('disk', 3);
    filter_mask = imclose(filter_mask, se);
    % convert to 8-bit unsigned integer
    filter_mask = uint8(imfill(filter_mask, 'holes'));
    filter_mask = cast(filter_mask, 'like', rgbImage); 
return;