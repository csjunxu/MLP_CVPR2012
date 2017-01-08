%--------------------------------------------------------------------------
clear;
GT_Original_image_dir = 'C:\Users\csjunxu\Desktop\CVPR2017\ourdata\clean\';
GT_fpath = fullfile(GT_Original_image_dir, '*.png');
TT_Original_image_dir = 'C:\Users\csjunxu\Desktop\CVPR2017\ourdata\noisy\';
TT_fpath = fullfile(TT_Original_image_dir, '*.png');
GT_im_dir  = dir(GT_fpath);
TT_im_dir  = dir(TT_fpath);
im_num = length(TT_im_dir);
addpath 'model';
method = 'MLP';
for nSig     =  [10 25]
    format compact;
    
    PSNR = [];
    SSIM = [];
    for i = 1 : im_num
        IM =   double(imread( fullfile(TT_Original_image_dir,TT_im_dir(i).name) ));
        IM_GT = double(imread(fullfile(GT_Original_image_dir, GT_im_dir(i).name)));
        S = regexp(TT_im_dir(i).name, '\.', 'split');
        IMname = S{1};
        [h,w,ch] = size(IM);
        %         randn('seed',0);
        %         noise_img          =   I+ nSig*randn(size(I));
        %         noise_img = double(uint8(noise_img));
        model = {};
        % width of the Gaussian window for weighting output pixels
        model.weightsSig = 2;
        % the denoising stride. Smaller is better, but is computationally
        % more expensive.
        model.step = 3;
        IMout = zeros(size(IM));
        for cc = 1:ch
            %% denoising
            IMoutcc = fdenoiseNeural(IM(:,:,cc), nSig, model);
            IMout(:,:,cc) = IMoutcc;
        end
        PSNR = [PSNR csnr( uint8(IMout), uint8(IM_GT), 0, 0 )];
        SSIM = [SSIM cal_ssim( uint8(IMout), uint8(IM_GT), 0, 0 )];
        fprintf('The final PSNR = %2.4f, SSIM = %2.4f. \n', PSNR(end), SSIM(end));
        imwrite(IMout, ['C:\Users\csjunxu\Desktop\CVPR2017\our_Results\' method '_' IMname '.png']);
    end
    mPSNR = mean(PSNR);
    mSSIM = mean(SSIM);
    save(['C:\Users\csjunxu\Desktop\CVPR2017\' method '_' num2str(nSig) '_' num2str(im_num) '.mat'],'nSig','PSNR','mPSNR','SSIM','mSSIM');
end