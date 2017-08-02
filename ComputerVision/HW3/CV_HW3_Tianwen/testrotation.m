im1=im2double(imread('pf_scan_scaled.jpg'));
im2=im2double(rgb2gray(imread('pf_pile.jpg')));
load parameters.mat;
[locs1, GaussianPyramid] = DoGdetector(im1, sigma0, k, levels,th_contrast, th_r);
[locs2, GaussianPyramid] = DoGdetector(im2, sigma0, k, levels,th_contrast, th_r);
load testPattern1;
%%  im1 direction of gradient, go opposite direction in direction_gradient to normalize
index_interesting_points=sub2ind(size(im1),locs1(1,:),locs1(2,:));
[Gmag,direction_gradient] = imgradient(im1);
% direction_gradient(find(direction_gradient<0))=direction_gradient(find(direction_gradient<0))+360;
angle_interesting_gradient = direction_gradient(index_interesting_points);
%%  im2 direction of gradient
index_interesting_points_2=sub2ind(size(im2),locs2(1,:),locs2(2,:));
[Gmag_2,direction_gradient_2] = imgradient(im2);
% direction_gradient_2(find(direction_gradient_2<0))=direction_gradient_2(find(direction_gradient_2<0))+360;
angle_interesting_gradient_2 = direction_gradient_2(index_interesting_points_2);

%%  compute rotational H1
% Scalef = @(s)([ s 0 0; 0 s 0; 0 0 1]);
Transf = @(tx,ty)([1 0 tx; 0 1 ty; 0 0 1]);
Rotf = @(t)([cos(t) -sin(t) 0; sin(t) cos(t) 0; 0 0 1]);
tx = locs1(2,:);
ty = locs1(1,:);
for i=1:length(angle_interesting_gradient)
H1{i} = Transf(tx(i),ty(i))*Rotf(-angle_interesting_gradient(i)*pi/180)*Transf(-tx(i),-ty(i));
end
%%  compute rotational H2
tx = locs2(2,:);
ty = locs2(1,:);
for i=1:length(angle_interesting_gradient_2)
H2{i} = Transf(tx(i),ty(i))*Rotf(-angle_interesting_gradient_2(i)*pi/180)*Transf(-tx(i),--ty(i));
end

%%  get locs and desc and matches
ratio=0.8;
[locs1,desc1]= getdesc_rotational(im1,locs1,H1,compareX,compareY);
[locs2,desc2]= getdesc_rotational(im2,locs2,H2,compareX,compareY);
[matches] = briefMatch_easyversion(desc1, desc2, ratio);
figure(2);
plotMatches(im1, im2, matches, locs1, locs2);

%% preprocess
points_left_pic=locs1(matches(:,1),2:-1:1)';        % into [x, y]  locs1
points_right_pic=locs2(matches(:,2),2:-1:1)';       % locs2
k_feature_all=(points_right_pic(2,:)-points_left_pic(2,:))./(points_right_pic(1,:)-points_left_pic(1,:));
distance=sqrt( (points_right_pic(2,:)-points_left_pic(2,:)).^2+(points_right_pic(1,:)-points_left_pic(1,:)).^2);
index_preprocess=unique([find(k_feature_all>0),find(distance<300)]);
% index_preprocess=find(k_feature_all>0);
matches(index_preprocess,:)=[];  % desk  
% matches=matches(find(distance>200),:);     % floor
figure(3);
plotMatches(im1, im2, matches, locs1, locs2);
[bestH2to1, bestError, inliers,num_correct]=notransacH2to1(matches, locs1, locs2);
%%  output result, I haven't changed the variables names, but if the H is right, it works!
im_book=im2double(imread('pf_scan_scaled.jpg'));
im_desk=im2double(imread('pf_pile.jpg'));
im_harry=im2double(imread('harrypotter.jpg'));
im_harry_enlarged=imresize(im_harry,size(im_book));
im_harry_enlarged_transform= warpH(im_harry_enlarged, bestH2to1, size(im_desk), 0);
index_content=find(im_harry_enlarged_transform~=0);
im_desk(index_content)=0;
im_melt=im_desk+im_harry_enlarged_transform;
figure(4);
imshow(im_melt);