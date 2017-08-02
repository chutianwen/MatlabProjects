%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Q2.5    Output number of correct mapping points
%%  Student:Tianwen Chu
%%  Date:   12/17/2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic;
% Read in two images.
I_RGB = imread('model_chickenbroth.jpg');
I_gray = im2double(rgb2gray(I_RGB));

% Define inline function to create an
% affine scaling matrix:
Scalef = @(s)([ s 0 0; 0 s 0; 0 0 1]);
% Same for translation
Transf = @(tx,ty)([1 0 tx; 0 1 ty; 0 0 1]);
% Same for rotation
Rotf = @(t)([cos(t) -sin(t) 0; sin(t) cos(t) 0; 0 0 1]);

% Output
out_size = [floor(size(I_gray,1)) floor(size(I_gray,2))];

% Pick a point around which to center
cx = size(I_gray,2)/2;
cy = size(I_gray,1)/2;

% Set fill value to black.
fill_value = 0;
j=1;
for i = 0

    % Center around cx,cy, rotate it a bit.
    H = Transf(out_size(2)/2,out_size(1)/2)*Scalef(1)*Rotf(-i*pi/180)*Transf(-cx,-cy);

    % Rotate the image.
    I_gray_warp = warpH(I_gray, H, out_size, fill_value);

    % Set the ratio to 0.8
    ratio = 0.8;

    % Calculate the location and descriptor of interested points.
    [locs1, desc1] = brief(I_gray);
    [locs2, desc2] = brief(I_gray_warp);

    % Find the matches.
    [matches] = briefMatchfrom1to2(desc1, desc2, ratio);

    % Plot the Match points.
    plotMatches(I_gray, I_gray_warp, matches, locs1, locs2);

%% output two groups of mapping points
points_left_pic=locs1(matches(:,1),2:-1:1);        % into [x, y] 
points_left_pic(:,3)=1;
points_left_pic=points_left_pic';
points_left_pic_tran=H*points_left_pic;
points_left_pic_tran(1:2,:)=points_left_pic_tran(1:2,:)./[points_left_pic_tran(3,:);points_left_pic_tran(3,:)];
points_left_pic_tran(1:2,:)=round(points_left_pic_tran(1:2,:));
points_right_pic=locs2(matches(:,2),2:-1:1);  
points_right_pic(:,3)=1;
points_right_pic=points_right_pic';

%% compute num of right mapping points
points_difference=points_left_pic_tran-points_right_pic;
number_right(j)=numel(find(points_difference(1,:)==0 & points_difference(2,:)==0 ));
j=j+1;
end
toc;