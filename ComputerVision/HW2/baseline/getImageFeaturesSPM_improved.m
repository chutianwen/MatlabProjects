function [h] = getImageFeaturesSPM_improved(layerNum, wordMap, dictionarySize)
%% separate into 4^(layerNum-1) fragments

num_types=2^(layerNum-1)-1;        % number of classify-1
W_finest=floor(size(wordMap,2)/(num_types+1));
H_finest=floor(size(wordMap,1)/(num_types+1));
Layer_finest=mat2cell(wordMap,[repmat(H_finest,1,num_types),size(wordMap,1)-num_types*H_finest],[repmat(W_finest,1,num_types),size(wordMap,2)-num_types*W_finest]);   % finest

%% construct a 4*4 cell input which is dictionarySize:200
b=zeros(num_types+1);
b(:)=dictionarySize;
b=mat2cell(b,repmat(1,1,(num_types+1)),repmat(1,1,(num_types+1)));
cell_finest= cellfun(@getImageFeatures, Layer_finest, b, 'UniformOutput', false);
%% reconstruct a row=2 cell matrix
number_all=4^(layerNum-1);
jmax=(2^(layerNum-1))/4;
imax=2^(layerNum-2);
% new cell matrix cell_new
for j=1:jmax
    for i=1:imax
        cell_new(1:2,4*i-3+(j-1)*(4*layerNum):4*i+(j-1)*(4*layerNum))=cell_finest(2*i-1:2*i,4*j-3:4*j);
    end
end
%% construct zero big H for preparation
% H_all=zeros(1,dictionarySize*(4^(layerNum+1)-1)/3);
H_all=reshape((cell2mat(cell_finest))',1,dictionarySize*number_all);
% H_all=H_all/            % make it normalized and weighted
num_all_layer=(4^(layerNum+1)-1)/3);
for i=1:4*2^(layerNum-1)
    cell_row{i}=cell_new{1,i}+cell_new{2,i};
end
for j=1:2*2^(layerNum-1)
    cell_row_col{j}=cell_row{2*j-1}+cell_row{2*j};   % this one is second last layer transformed to one row cell array
end
H_all=[H_all,cell2mat(cell_row_col)];
layerNum=layerNum-1;                                 % start Layer 
%% construct different layer
H_base=cell_row_col;
while(layerNum>0)
    [H_base,layerNum,H_all]=separate(H_base,layerNum,H_all)
end
h=H_all;
end

%% construct a function 
% function [H_base,layerNum,H_all]=separate(H_base,layerNum,H_all)
%     for i=1: 4^(layerNum-2)
%         H_base{i}=cell_new{4*i-3}+cell_new{4*i-2}+cell_new{4*i-1}+cell_new{4*i};
%     end
%     H_base_processed=cell2mat(H_base);
%     H_all=[H_all,H_base_processed];
%     layerNum=layerNum-1;
%     [H_base,H_all,layerNum]=separate(H_base,layerNum,H_all);
% end
% end




