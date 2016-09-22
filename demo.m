%   Author: Harold Christopher Burger
%   Date:   March 19, 2012.
addpath model
clear all;

% load an image
im_clean = double(imread('Lena512.png'));
im_clean = ones(256,256);
% add noise
rand('seed', 0);
randn('seed', 0);
im_noisy = im_clean + 0*randn(size(im_clean));

% define some parameters for denoising
model = {};
% width of the Gaussian window for weighting output pixels
model.weightsSig = 2;
% the denoising stride. Smaller is better, but is computationally 
% more expensive.
model.step = 1;

% denoise
fprintf('Starting to denoise...\n');
tstart = tic;
im_denoised = fdenoiseNeural(im_noisy, 10, model);
telapsed = toc(tstart);
fprintf('Done! Loading the weights and denoising took %.1f seconds\n',telapsed);

% get PSNR values
psnr_noisy = getPSNR(im_noisy, im_clean, 255);
psnr_denoised = getPSNR(im_denoised, im_clean, 255);
fprintf('PSNRs: noisy: %.2fdB, denoised: %.2fdB\n',psnr_noisy,psnr_denoised);

% display the result
subplot(131); imagesc(im_clean); s = gca;           title('clean'); axis image
subplot(132); imagesc(im_noisy, get(s, 'CLim'));    title('noisy'); axis image
subplot(133); imagesc(im_denoised, get(s, 'CLim')); title('denoised'); axis image
colormap(gray);

imwrite(im_denoised/255,'MLP.png')

