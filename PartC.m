clear
close all

%img = imread('lena512.png','png');
%img = imread('Cameraman256.png','png');
%img = double( rgb2gray(imread('map.jpg','jpg')))/255;
img = double( rgb2gray(imread('words.jpg','jpg')))/255;
% img = phaseran(img,1);

% figure
% imshow(img);
img = double(img);

sigma = 1;
epsilon = 0.1;

gradient_label=[0, 0; 1, 0; 0, 1; 2, 0; 1, 1;0, 2];
img = img./255; %normalize

filterOut = zeros(6,size(img,1),size(img,2));

x = -5*sigma:5*sigma;
xSquared = x.^2;
DtGfilters = cell(6,2);

G_kernel0 = exp(-xSquared./(2*sigma^2));
G_kernel_high{1} = (1/(sqrt(2)*sigma)).*G_kernel0;
G_kernel_high{2} = -x.*(1/(sqrt(2)*sigma^3)).*G_kernel0;
G_kernel_high{3} = (xSquared-sigma^2).*(1/(sqrt(2)*sigma^5)).*G_kernel0;
    
for i=1:size(gradient_label,1)
    DtGfilters{i,2} = G_kernel_high{gradient_label(i,1)+1};
    DtGfilters{i,1} = G_kernel_high{gradient_label(i,2)+1};
end

for i=1:size(gradient_label,1)
    J = imfilter(img,DtGfilters{i,1},'replicate', 'same','conv');
    J = imfilter(J,DtGfilters{i,2}','replicate', 'same','conv');
    filterOut(i,:,:) = J*(sigma^(sum(gradient_label(i,:))));
end

lambda=(squeeze(filterOut(4,:,:))+squeeze(filterOut(6,:,:)));
mu=sqrt(((squeeze(filterOut(4,:,:))-squeeze(filterOut(6,:,:))).^2)+4*squeeze(filterOut(5,:,:)).^2);

% Initialize classifiers array
classifier = zeros(size(filterOut,2),size(filterOut,3),7);

% Compute classifiers
classifier(:,:,1) = epsilon*squeeze(filterOut(1,:,:));
classifier(:,:,2) = 2*sqrt(squeeze(filterOut(2,:,:)).^2+squeeze(filterOut(3,:,:)).^2);
classifier(:,:,3) = lambda;
classifier(:,:,4) = -lambda;
classifier(:,:,5) = 2^(-1/2)*(mu+lambda);
classifier(:,:,6) = 2^(-1/2)*(mu-lambda);
classifier(:,:,7) = mu;

% classification result
[~,bifs] = max(classifier,[],3);

load('BIFColorMap','mycmap')
set(figure(), 'Name','BIF','Units', 'pixels', 'visible', 'on');
imshow(ind2rgb(bifs,colormap(mycmap)));