% Measure the mean intensity and area of each blob in each color band.
% ------------------------------
% Copyright (c), 2016, Linus Kohl <linus.kohl@mytum.de>
% All rights reserved.
% based on the "SimpleColorDetection.m function"
% by Image Analyst
% 20 Jan 2010 (Updated 19 Aug 2010) 
% ------------------------------

function [meanHSV, sizes, nBlobs] = MeasureBlobs(maskImage, hImg, sImg, vImg)
    % assign labels to connected areas
    % http://uk.mathworks.com/help/images/ref/bwlabel.html
	[labelMatrix, nBlobs] = bwlabel(maskImage, 8);
    % no blobs
    if nBlobs == 0
		meanHSV = [0 0 0];
		sizes = 0;
		return;
    end
    
    % get mean of all the intensity values in the areas
    % http://uk.mathworks.com/help/images/ref/regionprops.html
	blobStatsH = regionprops(labelMatrix, hImg, 'area', 'MeanIntensity');
	blobStatsS = regionprops(labelMatrix, sImg, 'area', 'MeanIntensity');
	blobStatsV = regionprops(labelMatrix, vImg, 'area', 'MeanIntensity');   

	meanHSV = zeros(nBlobs, 3);
	meanHSV(:,1) = [blobStatsH.MeanIntensity]';
	meanHSV(:,2) = [blobStatsS.MeanIntensity]';
	meanHSV(:,3) = [blobStatsV.MeanIntensity]';
    
    % number of pixels in the area
	sizes = [blobStatsH.Area]';

	return;