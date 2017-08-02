%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Q3.1    Ransac
%%  Student:Tianwen Chu
%%  Date:   12/17/2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [bestH2to1, bestError, inliers,num_correct]=ransacH2to1(matches, locs1, locs2)
inliers=zeros(1,size(matches,1));
%%  produce homography coordinates
points_left_pic=locs1(matches(:,1),2:-1:1)';        % into [x, y]  locs1
points_right_pic=locs2(matches(:,2),2:-1:1)';       % locs2

%%  initiate the parameters
i=1;
num_iteration=1000;
p=0.99;
max_number=0;
while(i<num_iteration)
    num_mode=3;num_mode_r=3;
    while ( (num_mode==3 | num_mode==6) | ( num_mode_r==3 | num_mode_r==6) )
    %%  randperm 4 points
    index_rand_four_points=randperm(size(points_left_pic,2),4);
    points_left_four=points_left_pic(:,index_rand_four_points);
    points_right_four=points_right_pic(:,index_rand_four_points);

    %%  whether three points colinear 
    k_1_234=(points_left_four(2,2:4)-points_left_four(2,1))./(points_left_four(1,2:4)-points_left_four(1,1));
    k_2_34=(points_left_four(2,3:4)-points_left_four(2,2))./(points_left_four(1,3:4)-points_left_four(1,2));
    k_3_4=(points_left_four(2,4)-points_left_four(2,3))./(points_left_four(1,4)-points_left_four(1,3));
    k_all=[k_1_234,k_2_34,k_3_4];
    %   right points also not colinear
    k_1_234_r=(points_right_four(2,2:4)-points_right_four(2,1))./(points_right_four(1,2:4)-points_right_four(1,1));
    k_2_34_r=(points_right_four(2,3:4)-points_right_four(2,2))./(points_right_four(1,3:4)-points_right_four(1,2));
    k_3_4_r=(points_right_four(2,4)-points_right_four(2,3))./(points_right_four(1,4)-points_right_four(1,3));
    k_all_r=[k_1_234_r,k_2_34_r,k_3_4_r];
    [useless, num_mode]=mode(k_all);
    [useless, num_mode_r]=mode(k_all_r);
    check_nan=isnan(k_all);
    check_nan_2=isnan(k_all_r);
    if ( length(find(check_nan==1))~=0 | length(find(check_nan_2==1))~=0 )
        num_mode=3;num_mode_r=3;
    end
    end
    
%%  get the  H
    [H,A] = computeH_norm( points_left_four,points_right_four);

%%  calculate the right matching numbers
    points_left_pic(3,:)=1;
    points_right_pic(3,:)=1;
    points_left_pic_transform=H*points_left_pic;
    points_left_pic_transform(1:2,:)=round(points_left_pic_transform(1:2,:)./[points_left_pic_transform(3,:);points_left_pic_transform(3,:)]);

%%  calculate the distance
    points_difference=points_left_pic_transform-points_right_pic;
    index_correct_mapping=find(points_difference(1,:)==0 & points_difference(2,:)==0);
    num_correct(i)=length(index_correct_mapping);
    
%%  iterate the number of loops
    if num_correct(i)>max_number
        num_iteration= log(1-p)/log(1-(num_correct(i)/size(matches, 1))^4);
        bestH2to1=H;
        max_number= num_correct(i);
        index_correct_mapping_result=index_correct_mapping;
        bestError=sum(sqrt( (points_left_pic_transform(1,:)-points_right_pic(1,:)).^2+(points_left_pic_transform(2,:)-points_right_pic(2,:)).^2 ));
    end
    points_right_pic(3,:)=[];
    points_left_pic(3,:)=[];
    i=i+1; 
end
inliers(index_correct_mapping_result)=1;

end