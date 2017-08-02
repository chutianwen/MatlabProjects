%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Q1.1.3  Detecting Extrema
%%  Notes:  Using 26 surrounding points to get results
%%  Student:Tianwen Chu
%%  Date:   12/17/2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function locs = getLocalExtrema(DoGPyramid, DoG_levels, PrincipalCurvature,th_contrast, th_r)
[num_row,num_col]=size(DoGPyramid(:,:,1));
[col,row]=meshgrid(2:num_col-1,2:num_row-1);  
index_center=sub2ind([num_row,num_col],row,col);
index_center=reshape(index_center,1,(num_row-2)*(num_col-2));
locs=[];
%% process 
for lay=1:length(DoG_levels)
    index=[];       %   all the surrounding points
    for i=-1:1
        for j=-1:1
        temp=sub2ind([num_row,num_col],row+i,col+j);
        temp=reshape(temp,1,(num_row-2)*(num_col-2));
        index=[index;temp];
        end
    end
    % Three layers
    DoGPyramid_current=DoGPyramid(:,:,lay);
    Pixels_all=DoGPyramid_current(index);
    if (lay>1 & lay<length(DoG_levels))
    DoGPyramid_current_below=DoGPyramid(:,:,lay-1);
    DoGPyramid_current_above=DoGPyramid(:,:,lay+1);
    Pixels_all=[Pixels_all;DoGPyramid_current_below(index);DoGPyramid_current_above(index)];
    Pixels_all_max=max(Pixels_all);
    Pixels_all_min=min(Pixels_all);
    else if(lay==1)
            DoGPyramid_current_above=DoGPyramid(:,:,lay+1);
            Pixels_all=[Pixels_all;DoGPyramid_current_above(index)];
            Pixels_all_max=max(Pixels_all);
            Pixels_all_min=min(Pixels_all);
        else
            DoGPyramid_current_below=DoGPyramid(:,:,lay-1);
            Pixels_all=[Pixels_all;DoGPyramid_current_below(index)];
            Pixels_all_max=max(Pixels_all);
            Pixels_all_min=min(Pixels_all);
        end
    end
    % compare and get the extrema
    Pixels_center=DoGPyramid_current(index_center);
    PrincipalCurvature_current=PrincipalCurvature(:,:,lay);
    PrincipalCurvature_current=PrincipalCurvature_current(index_center);
    index_extrema=index_center(find( (Pixels_all_max==Pixels_center | Pixels_all_min== Pixels_center )& abs(Pixels_center)>th_contrast & PrincipalCurvature_current<th_r ));
    [x,y]=ind2sub([num_row,num_col],index_extrema);
    %% record the num of DOG_layer
    current_layer_num=zeros(1,length(index_extrema));
    current_layer_num(:)=DoG_levels(lay);
    temp=[x;y;current_layer_num]; 
    locs=[locs,temp];
end
end
    
   
    
