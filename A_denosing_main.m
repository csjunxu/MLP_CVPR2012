
%--------------------------------------------------------------------------
clc;
clear;

addpath model;
setname          = 'Real_NoisyImage';
method           =  'MLP';
ref_folder       =  fullfile('C:\Users\csjunxu\Desktop\CVPR2017\1_Results\',setname);

den_folder       =  ['Results_',setname,'_',method];
if ~isdir(den_folder)
    mkdir(den_folder)
end

noise_levels     =  [25];
images           =  dir(fullfile(ref_folder,'*.png'));
format compact;

for i = 1 : numel(images)
    [~, name, exte]  =  fileparts(images(i).name);
    I =   im2double(imread( fullfile(ref_folder,images(i).name) ));
    [h,w,ch] = size(I);
    % color or gray image
    if ch==1
        IMin_y = I;
    else
        % change color space, work on illuminance only
        IMin_ycbcr = rgb2ycbcr(I);
        IMin_y = IMin_ycbcr(:, :, 1);
        IMin_cb = IMin_ycbcr(:, :, 2);
        IMin_cr = IMin_ycbcr(:, :, 3);
    end
    for j = 1 : numel(noise_levels)
        disp([i,j]);
        nSig               =    noise_levels(j);
        randn('seed',0);
        %         noise_img          =   I+ nSig*randn(size(I));
        %         noise_img = double(uint8(noise_img));
        model = {};
        % width of the Gaussian window for weighting output pixels
        model.weightsSig = 2;
        % the denoising stride. Smaller is better, but is computationally
        % more expensive.
        model.step = 3;
        
        IMout_y = fdenoiseNeural(IMin_y*255, nSig, model);
        if ch==1
            IMout = IMout_y/255;
        else
            IMout_ycbcr = zeros(size(I));
            IMout_ycbcr(:, :, 1) = IMout_y/255;
            IMout_ycbcr(:, :, 2) = IMin_cb;
            IMout_ycbcr(:, :, 3) = IMin_cr;
            IMout = ycbcr2rgb(IMout_ycbcr);
        end
        imwrite(IMout, ['C:\Users\csjunxu\Desktop\CVPR2017\1_Results\Real_' method '\' method '_Real_' num2str(noise_levels) '_' name '.png']);
        
        %         PSNR_value = csnr(uint8(I),uint8(im),0,0);
        % imwrite(im/255, fullfile(den_folder, [name, '_sigma=' num2str(nSig,'%02d'),'_',method,'_PSNR=',num2str(PSNR_value,'%2.2f'), exte] ));
        %         PSNR(i,j) = PSNR_value;
    end
end

% mean_value = mean(PSNR,1);

%save(['PSNR_',setname,'_',method],'noise_levels','PSNR','mean_value');


