% Calculate number of connected color areas and percentage of the color in 
% the image
% ------------------------------
% Copyright (c), 2016, Linus Kohl <linus.kohl@mytum.de>
% All rights reserved.
% ------------------------------

% directory of the images to analyse
imageDir='./examples/';
colordata = cellstr(['red   '; 'orange'; 'yellow'; 'green '; ...
                     'blue  ';'violet'; 'white '; 'black ']);
filters = {
    %idx  hmin hmax smin smax vmin vmax
    [1.0    0    30 0.00 1.00 0.2  1.00]; %red
    [2.0   31    46 0.00 1.00 0.2  1.00]; %orange
    [3.0   47    75 0.00 1.00 0.2  1.00]; %yellow
    [4.0   75   170 0.10 1.00 0.2  1.00]; %green
    [5.0  171   280 0.10 1.00 0.2  1.00]; %blue
    [6.0  281   360 0.10 1.00 0.2  1.00]; %violet
    [7.0    0   360 0.00 0.10 0.9  1.00]; %white
    [8.0    0   340 0.00 1.00 0.0  0.15]; %black
};

files = dir(strcat(imageDir,'/*.jpg'));
[ni] = length(files);
[nf,m] = size(filters);
% loop over all images in directory
for K = 1 : ni
  name = files(K).name;
  file = char(strcat(imageDir, name));
  [outpathstr,outname,ext] = fileparts(file);
  file_out = char(strcat('./analysed/', outname));
  analytics_file = char(strcat(file_out,'_analytics.txt'));
  % open analytics file
  analytics_file_id = fopen(analytics_file,'wt');
  fprintf(analytics_file_id,'Color: \t\t#areas\t\tperc. \n\n');
  try
    % loop over all filters
    for Z = 1 : nf
        % correct RGB image 
        image = PrepareImage(file);
        filter = filters{Z};
        % analyse the image with the current filter
        [nrBlobs, percArea, imgMasked] = AnalyzeImage(image, filter);
        % write results to file
        fprintf(analytics_file_id, '%s:\t\t%d\t\t%f\n', char(colordata(filter(1))), nrBlobs, percArea);
        % save masked image
        imwrite(imgMasked, char(strcat(file_out, '_',colordata(filter(1)),'_masked.jpg')));
        clearvars image;
    end
  catch err
      disp(err.message);
  end
  fclose(analytics_file_id);
end