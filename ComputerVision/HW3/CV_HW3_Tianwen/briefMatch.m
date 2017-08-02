%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Q2.4    Descriptor Matching
%%  Notes:  Mapping from right picture to left picture
%%          Cannot suitable to large scale of pictures due to repmat 
%%  Student:Tianwen Chu
%%  Date:   12/17/2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [matches] = briefMatch(desc1, desc2, ratio)
num_row_1=length(desc1(:,1));       % m rows
num_row_2=length(desc2(:,1));       % n rows
%% creat a (m*n)*256 big computing matrix
% Hamming_distance=zeros(m,n);
desc2_big=reshape(desc2',1,num_row_2*256);
desc2_big=repmat(desc2_big,num_row_1,1);
desc1_big=repmat(desc1,1,num_row_2);
desc_difference=desc2_big-desc1_big;
desc_difference_cell=mat2cell(desc_difference,ones(1,num_row_1),repmat(256,1,num_row_2));
%%  compute the distance and output result matrix
Distance_result= cellfun(@Hamming_distance, desc_difference_cell, 'UniformOutput', false);
Distance_result=cell2mat(Distance_result);
[first_min, first_min_index]=min(Distance_result); 
%%  get the second max
col_min=1:num_row_2;
index_min=sub2ind([num_row_1,num_row_2],first_min_index,col_min);
Distance_result(index_min)=1;
[second_min, second_min_index]=min(Distance_result);
Result_ratio=first_min./second_min;
index_out=find(Result_ratio>ratio);
points_test_chose=(1:num_row_2)';
points_test_chose(index_out)=[];
first_min_index(index_out)=[];
matches=[first_min_index',points_test_chose];
end



