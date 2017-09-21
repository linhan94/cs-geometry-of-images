clear
close all

img = imread('lena512.png','png');
%img = imread('Cameraman256.png','png');
figure
imshow(img);

%% zero order
img = double(img);

gradient_label=[0, 0; 1, 0; 0, 1; 2, 0; 1, 1;0, 2];
img = img./255; %normalize

filterOut = zeros(6,size(img,1),size(img,2));
sigma = 5;

x = -5*sigma:5*sigma;
xSquared = x.^2;
DtGfilters = cell(6,2);

G_kernel0 = exp(-xSquared./(2*sigma^2));
G_kernel_high{1} = (1/(sqrt(2)*sigma)).*G_kernel0;
G_kernel_high{2} = -x.*(1/(sqrt(2)*sigma^3)).*G_kernel0;
G_kernel_high{3} = (xSquared-sigma^2).*(1/(sqrt(2)*sigma^5)).*G_kernel0;
orders=[0, 0; 1, 0; 0, 1; 2, 0; 1, 1;0, 2];
    
for i=1:size(orders,1)
    DtGfilters{i,2} = G_kernel_high{orders(i,1)+1};
    DtGfilters{i,1} = G_kernel_high{orders(i,2)+1};
end

for i=1:size(gradient_label,1)
    J = imfilter(img,DtGfilters{i,1},'replicate', 'same','conv');
    J = imfilter(J,DtGfilters{i,2}','replicate', 'same','conv');
    filterOut(i,:,:) = J*(sigma^(sum(gradient_label(i,:))));
end

figure
imshow(reshape(filterOut(1,:,:),length(img),length(img)));
title('0 order')
figure
imshow(reshape(filterOut(2,:,:),length(img),length(img)));
title('dy')
figure
imshow(reshape(filterOut(3,:,:),length(img),length(img)));
title('dx');
figure
imshow(reshape(filterOut(4,:,:),length(img),length(img)));
title('dyy');
figure
imshow(reshape(filterOut(5,:,:),length(img),length(img)));
title('dxy');
figure
imshow(reshape(filterOut(6,:,:),length(img),length(img)));
title('dxx');

% figure
% subplot(2,3,1);
% imshow(reshape(filterOut(1,:,:),length(img),length(img)).*2.55./2);
% title('0 order')
% subplot(2,3,2);
% imshow(reshape(filterOut(2,:,:),length(img),length(img)).*2.55./2);
% title('dx')
% subplot(2,3,3);
% imshow(reshape(filterOut(3,:,:),length(img),length(img)).*2.55./2);
% title('dy');
% subplot(2,3,4);
% imshow(reshape(filterOut(4,:,:),length(img),length(img)).*2.55./2);
% title('dxx');
% subplot(2,3,5);
% imshow(reshape(filterOut(5,:,:),length(img),length(img)).*2.55./2);
% title('dxy');
% subplot(2,3,6);
% imshow(reshape(filterOut(6,:,:),length(img),length(img)).*2.55./2);
% title('dyy');