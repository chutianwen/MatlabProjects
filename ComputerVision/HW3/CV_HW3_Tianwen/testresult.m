%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  ALL script for testing and getting results
%%  Student:Tianwen Chu
%%  Date:   12/17/2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Q1  Output DoG
tic;
format long;
%% initial inputs 
% im1=im2double(rgb2gray(imread('model_chickenbroth.jpg')));
% im2=im2double(rgb2gray(imread('chickenbroth_01.jpg')));
im1=im2double(imread('pf_scan_scaled.jpg'));
im2=im2double(rgb2gray(imread('pf_stand.jpg')));
sigma0=1;
k=sqrt(2);
th_contrast=0.03;
th_r=12;
levels=[-1,0,1,2,3,4];
ratio=0.8;
    
% save parameters sigma0 k levels th_contrast th_r;
%% Q1.2 get extremas
[locs1, GaussianPyramid] = DoGdetector(im1, sigma0, k, levels,th_contrast, th_r);
[locs2, GaussianPyramid] = DoGdetector(im2, sigma0, k, levels,th_contrast, th_r);
% imshow(im2);
% hold on;
% plot(locs2(2,:), locs2(1,:), 'o', 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'g', 'MarkerSize', 5);

%% Q2.3 change to 256bit expression
[locs1, desc1] = brief(im1);
[locs2, desc2] = brief(im2);

%% Q2.4 get matching points index
% [matches] = briefMatch(desc1, desc2, ratio);
% [matches] = briefMatchfrom1to2(desc1, desc2, ratio);
[matches] = briefMatch_easyversion(desc1, desc2, ratio);
%% plot matching result
plotMatches(im1, im2, matches, locs1, locs2);
%%  Q3.1 get the bestH for desk case
% preprocess
points_left_pic=locs1(matches(:,1),2:-1:1)';        % into [x, y]  locs1
points_right_pic=locs2(matches(:,2),2:-1:1)';       % locs2
k_feature_all=(points_right_pic(2,:)-points_left_pic(2,:))./(points_right_pic(1,:)-points_left_pic(1,:));
matches=matches(find(k_feature_all>0 & k_feature_all<1.1),:);   % desk  
figure(2);
plotMatches(im1, im2, matches, locs1, locs2);
[bestH2to1, bestError, inliers,num_correct]=ransacH2to1(matches, locs1, locs2);
%%  Floor case
% points_left_pic=locs1(matches(:,1),2:-1:1)';        % into [x, y]  locs1
% points_right_pic=locs2(matches(:,2),2:-1:1)';       % locs2
% distance=sqrt( (points_right_pic(2,:)-points_left_pic(2,:)).^2+(points_right_pic(1,:)-points_left_pic(1,:)).^2);
% % matches=matches(find(k_feature_all>0 & k_feature_all<1.5),:);   % desk  
% matches=matches(find(distance>400),:);     % floor
% figure(2);
% plotMatches(im1, im2, matches, locs1, locs2);
% [bestH2to1, bestError, inliers,num_correct]=ransacH2to1(matches, locs1, locs2);

%%  Q3.2 melting  
im_book=im2double(imread('pf_scan_scaled.jpg'));
im_desk=im2double(imread('pf_stand.jpg'));
im_harry=im2double(imread('harrypotter.jpg'));
im_harry_enlarged=imresize(im_harry,size(im_book));
im_harry_enlarged_transform= warpH(im_harry_enlarged, bestH2to1, size(im_desk), 0);
index_content=find(im_harry_enlarged_transform~=0);
im_desk(index_content)=0;
im_melt=im_desk+im_harry_enlarged_transform;
figure(3);
imshow(im_melt);

%%  show the inliners
figure(4);
plotMatches(im1, im2, matches(find(inliers==1),:), locs1, locs2);

% save locs_result locs levels;
% h = fspecial('gaussian',9,2);
% im_filtered=imfilter(im,h);
% % [compareX, compareY] = makeTestPattern(patchWidth, nbits);
% load testPattern.mat;
% [locs,desc] = computeBrief(im, locs, levels, compareX, compareY);
% plot(locs(2,:),locs(1,:),'h');

% [GaussianPyramid] = createGaussianPyramid(im, sigma0, k, levels);
% [DoGPyramid, DoG_levels] = createDoGPyramid(GaussianPyramid, levels);
% imshow(DoGPyramid(:,:));
% PrincipalCurvature = computePrincipalCurvature(DoGPyramid);
% locs = getLocalExtrema(DoGPyramid, DoG_levels, PrincipalCurvature,th_contrast, th_r);
toc;