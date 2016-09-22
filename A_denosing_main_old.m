
%--------------------------------------------------------------------------
clc;
clear;
%%% addpath
addpath('..\RandNoise')
load RandNoise.mat;
addpath(genpath('./.'));

method           =  '06';
ref_folder       =  '..\Ref_Gray';
den_folder       =  method;

if ~isdir(den_folder)
    mkdir(den_folder)
end

noise_levels     =  [10, 25, 35, 50, 75];
images           =  dir(fullfile(ref_folder,'*.bmp'));
format compact;
for i = 3 : numel(images)
    
    [~, name, exte]  =  fileparts(images(i).name);
    I =   double(imread( fullfile(ref_folder,images(i).name) ));
    
    for j = 1 : numel(noise_levels)
        disp([i,j]);
        nSig             =    noise_levels(j);
        
        noise_img          =   I+ nSig*RandNoise{i,j};
        
        model = {};
        % width of the Gaussian window for weighting output pixels
        model.weightsSig = 2;
        % the denoising stride. Smaller is better, but is computationally
        % more expensive.
        model.step = 3;
        
        im = fdenoiseNeural(noise_img, nSig, model);
        
        imwrite(im/255, fullfile(den_folder, [name, num2str(j), method,exte] ));
        
        
    end
end




