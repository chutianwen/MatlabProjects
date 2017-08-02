function [locs,desc]= getdesc_rotational(im,locs,H,compareX,compareY)
[height,width]=size(im);        % height:row, width: col
[compareX_row,compareX_col]=ind2sub([9,9],compareX);
[compareY_row,compareY_col]=ind2sub([9,9],compareY);
compareX=[compareX_row-5,compareX_col-5];
compareY=[compareY_row-5,compareY_col-5];

%% get absolute [row,col]
points_interest=locs';
m=length(points_interest(:,1));     %   number of valid interesting points
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
index_points_X_row_line=reshape(index_points_X_row',1,256*size(index_points_X_row,1));
index_points_X_col_line=reshape(index_points_X_col',1,256*size(index_points_X_row,1));
X_homogeneous=[index_points_X_col_line;index_points_X_row_line];
X_homogeneous(3,:)=1;
i=1;
while(i<=m)     % num of interesting points 
    for j=1:256
    X_transformed(:,(i-1)*256+j)=  H{i}*X_homogeneous(:,(i-1)*256+j);
    end
i=i+1;
end

%%  output Y group
index_compareY_row=zeros(1,256);
index_compareY_col=zeros(1,256);
compareY=compareY';
index_compareY_row=compareY(1,:);
index_compareY_col=compareY(2,:);
index_compareY_row=repmat(index_compareY_row,m,1);
index_compareY_col=repmat(index_compareY_col,m,1);
index_points_Y_row=index_compareY_row+index_center_row;
index_points_Y_col=index_compareY_col+index_center_col;
index_points_Y_row_line=reshape(index_points_Y_row',1,256*size(index_points_Y_row,1));
index_points_Y_col_line=reshape(index_points_Y_col',1,256*size(index_points_Y_row,1));
Y_homogeneous=[index_points_Y_col_line;index_points_Y_row_line];
Y_homogeneous(3,:)=1;
i=1;
while(i<=m)     % num of interesting points 
    for j=1:256
    Y_transformed(:,(i-1)*256+j)=  H{i}*Y_homogeneous(:,(i-1)*256+j);
    end
i=i+1;
end
X_homogeneous_row=round(reshape(X_transformed(2,:),256,m)');
X_homogeneous_col=round(reshape(X_transformed(1,:),256,m)');
Y_homogeneous_row=round(reshape(Y_transformed(2,:),256,m)');
Y_homogeneous_col=round(reshape(Y_transformed(1,:),256,m)');

%%  wipe out the outside points and corresponding index in locs
%%  X group
outside_row_min_x=min(X_homogeneous_row,[],2);    % find part<1
outside_row_max_x=max(X_homogeneous_row,[],2);    % find part>height
outside_col_min_x=min(X_homogeneous_col,[],2);    % find part<1
outside_col_max_x=max(X_homogeneous_col,[],2);    % find part>width
index_outside_x=find(outside_row_min_x<1 | outside_row_max_x>height | outside_col_min_x<1 | outside_col_max_x>width );
%%  Y group
outside_row_min_y=min(Y_homogeneous_row,[],2);    % find part<1
outside_row_max_y=max(Y_homogeneous_row,[],2);    % find part>height
outside_col_min_y=min(Y_homogeneous_col,[],2);    % find part<1
outside_col_max_y=max(Y_homogeneous_col,[],2);    % find part>width
index_outside_y=find(outside_row_min_y<1 | outside_row_max_y>height | outside_col_min_y<1 | outside_col_max_y>width );
%%  combine the unvalid index
index_outside=unique([index_outside_x;index_outside_y]);
X_homogeneous_row(index_outside,:)=[];
X_homogeneous_col(index_outside,:)=[];
Y_homogeneous_row(index_outside,:)=[];
Y_homogeneous_col(index_outside,:)=[];
index_X_group=sub2ind(size(im),X_homogeneous_row,X_homogeneous_col);
index_Y_group=sub2ind(size(im),Y_homogeneous_row,Y_homogeneous_col);
length_points=size(index_X_group,1);
desc=zeros(length_points,256);
points_difference=im(index_Y_group)-im(index_X_group);
desc(find(points_difference>0))=1;
locs=locs';
locs(index_outside,:)=[];
end