clear

%% phase-randomized
%img = imread('lena512.png','png');
img = imread('Cameraman256.png','png');
%img = imread('lenna.png','png');
figure
imshow(img);
img = double(img);

surrblk = phaseran(img,1);

figure
imshow(uint8(surrblk));

%% whitened image
mimg = bsxfun(@minus,img,mean(img)); %remove mean
fimg = fft(fft(mimg,[],2),[],3); %fourier transform of the images
spectr = sqrt(mean(abs(fimg).^2)); %Mean spectrum
wimg = ifft(ifft(bsxfun(@times,fimg,1./spectr),[],2),[],3); %whitened img
figure
imshow(2.55*wimg+1);
