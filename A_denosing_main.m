
%--------------------------------------------------------------------------
clc;
clear;

addpath model;
setname          = 'Set68';
method           =  'MLP';
ref_folder       =  fullfile('D:\matlab1\DL_code\demo_denoising_v1.0_simplenn\data\Test',setname);

den_folder       =  ['Results_',setname,'_',method];
if ~isdir(den_folder)
    mkdir(den_folder)
end

noise_levels     =  [25];
images           =  dir(fullfile(ref_folder,'*.png'));
format compact;

for i = 1 : numel(images)
    [~, name, exte]  =  fileparts(images(i).name);
    I =   double(imread( fullfile(ref_folder,images(i).name) ));
    for j = 1 : numel(noise_levels)
        disp([i,j]);
        nSig               =    noise_levels(j);
        randn('seed',0);
        noise_img          =   I+ nSig*randn(size(I));
        noise_img = double(uint8(noise_img));
        model = {};
        % width of the Gaussian window for weighting output pixels
        model.weightsSig = 2;
        % the denoising stride. Smaller is better, but is computationally
        % more expensive.
        model.step = 3;
        
        im = fdenoiseNeural(noise_img, nSig, model);
        
        PSNR_value = csnr(uint8(I),uint8(im),0,0);
       % imwrite(im/255, fullfile(den_folder, [name, '_sigma=' num2str(nSig,'%02d'),'_',method,'_PSNR=',num2str(PSNR_value,'%2.2f'), exte] ));
        PSNR(i,j) = PSNR_value;
    end
end

mean_value = mean(PSNR,1);

%save(['PSNR_',setname,'_',method],'noise_levels','PSNR','mean_value');


