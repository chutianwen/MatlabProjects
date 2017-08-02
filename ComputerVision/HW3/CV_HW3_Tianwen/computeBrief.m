%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Q2.2    Compute the BRIEF Descriptor
%%  Student:Tianwen Chu
%%  Date:   12/17/2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [locs,desc] = computeBrief(im, locs, levels, compareX, compareY)
%%  output the deviation
[height,width]=size(im);        % height:row, width: col
[compareX_row,compareX_col]=ind2sub([9,9],compareX);
[compareY_row,compareY_col]=ind2sub([9,9],compareY);
compareX=[compareX_row-5,compareX_col-5];
compareY=[compareY_row-5,compareY_col-5];
%% wipe out the unvalid interesting points
points_interest=locs';      %   m*3
index_row_unvalid=find(points_interest(:,1)<5 | points_interest(:,1)>height-4);
index_col_unvalid=find(points_interest(:,2)<5 | points_interest(:,2)>width-4);
points_interest([index_row_unvalid;index_col_unvalid],:)=[];
m=length(points_interest(:,1));     %   number of valid interesting points
desc=zeros(m,256);
%%  outputs absolute coordinates interesting points 
index_center_row=repmat(points_interest(:,1),1,256);
index_center_col=repmat(points_interest(:,2),1,256);
%   output X group
index_compareX_row=zeros(1,256);
index_compareX_col=zeros(1,256);
compareX=compareX';
index_compareX_row=compareX(1,:);
index_compareX_col=compareX(2,:);
index_compareX_row=repmat(index_compareX_row,m,1);
index_compareX_col=repmat(index_compareX_col,m,1);
index_points_X_row=index_compareX_row+index_center_row;
index_points_X_col=index_compareX_col+index_center_col;
index_points_X_linear=sub2ind(size(im),index_points_X_row,index_points_X_col);
points_X=im(index_points_X_linear);
%   output Y group
index_compareY_row=zeros(1,256);
index_compareY_col=zeros(1,256);
compareY=compareY';
index_compareY_row=compareY(1,:);
index_compareY_col=compareY(2,:);
index_compareY_row=repmat(index_compareY_row,m,1);
index_compareY_col=repmat(index_compareY_col,m,1);
index_points_Y_row=index_compareY_row+index_center_row;
index_points_Y_col=index_compareY_col+index_center_col;
index_points_Y_linear=sub2ind(size(im),index_points_Y_row,index_points_Y_col);
points_Y=im(index_points_Y_linear);
%%  output desc
result=points_Y-points_X;
desc(find(result>0))=1;
locs=points_interest;
end
