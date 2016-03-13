% Convert image to HSV color space, create and apply the filter mask, and
% analyse the blobs
% ------------------------------
% Copyright (c), 2016, Linus Kohl <linus.kohl@mytum.de>
% All rights reserved.
% based on the "SimpleColorDetection.m function"
% by Image Analyst
% 20 Jan 2010 (Updated 19 Aug 2010) 
% ------------------------------
function [nBlobs, percArea, maskedRGBImage] = AnalyzeImage(rgbImage, hsvFilter)
    % convert image to hsv color space and spit to channels
    hsvImage = rgb2hsv(rgbImage);
    hI = hsvImage(:,:,1);
    sI = hsvImage(:,:,2);
    vI = hsvImage(:,:,3);
    
    % generate the filter mask
    filter_mask = GenFilterMask(rgbImage, hsvFilter);

    %apply filter mask
    maskedImageR = filter_mask .* rgbImage(:,:,1);
    maskedImageG = filter_mask .* rgbImage(:,:,2);
    maskedImageB = filter_mask .* rgbImage(:,:,3);
    maskedRGBImage = cat(3, maskedImageR, maskedImageG, maskedImageB);

    %calculate percentage of area
    percArea = 0;
    [x,y,z] = size(rgbImage);
    %total number of pixels of the image
    nPixels = x*y;
    [meanHSV, areas, nBlobs] = MeasureBlobs(filter_mask, hI, sI, vI);

    if nBlobs > 0
        for idxBlobs = 1 : nBlobs
            percArea = percArea + areas(idxBlobs);
        end
        percArea = (percArea/nPixels)*100;
    end
return;