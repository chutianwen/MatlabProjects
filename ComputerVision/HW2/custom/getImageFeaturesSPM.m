%   Q2.2 Creat Histogram
%   This program is merely for creating three-layer pyramid
%   Another improved progress which can realize arbitrary layerNum, but
%   there are some bugs for me to solve.

function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)
%% separate into 4^(layerNum-1) fragments
num_edge_one=2^(layerNum-1)-1;                 % number of classify-1
W_finest=floor(size(wordMap,2)/(num_edge_one+1));
H_finest=floor(size(wordMap,1)/(num_edge_one+1));
Layer_finest=mat2cell(wordMap,[repmat(H_finest,1,num_edge_one),size(wordMap,1)-num_edge_one*H_finest],[repmat(W_finest,1,num_edge_one),size(wordMap,2)-num_edge_one*W_finest]);   % finest

%% construct a 4*4 cell input which is dictionarySize:200
b=zeros(num_edge_one+1);
b(:)=dictionarySize;
b=mat2cell(b,repmat(1,1,(num_edge_one+1)),repmat(1,1,(num_edge_one+1)));
cell_finest= cellfun(@getImageFeatures, Layer_finest, b, 'UniformOutput', false);

%% reconstruct a row=2 cell matrix
number_all=4^(layerNum-1);
jmax=(2^(layerNum-1))/4;
imax=2^(layerNum-2);

%% new cell matrix cell_new
for j=1:jmax
    for i=1:imax
        cell_new(1:2,4*i-3+(j-1)*(4*layerNum):4*i+(j-1)*(4*layerNum))=cell_finest(2*i-1:2*i,4*j-3:4*j);
    end
end

%% construct finest layer
h3=cell2mat(cell_finest);   
h3_matrix=reshape(h3',1,3200)/(2*16);   % the finest layer

%% construct second layer
for j=1:4
    h2{j}=(cell_new{1,2*j-1}+cell_new{1,2*j}+cell_new{2,2*j-1}+cell_new{2,2*j})/4;
end
% h2 is a cell array, the position of 3th and 2th need to be inversed
h2=[h2(1),h2(3),h2(2),h2(4)];           
h2_matrix=cell2mat(h2)/(4*4);           % the second layer

%% construct the basest layer
h1{1}= h2{1}+h2{2}+h2{3}+h2{4};
h1_matrix=cell2mat(h1)/(4*4);           % the basest layer.

%% construct the final big histogram
h=[h3_matrix , h2_matrix, h1_matrix]';
end