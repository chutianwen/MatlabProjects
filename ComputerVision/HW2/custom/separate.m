function [H_base,layerNum,H_all]=separate(H_base,layerNum,H_all)
for i=1: 4^(layerNum-2)
    H_base{i}=cell_new{4*i-3}+cell_new{4*i-2}+cell_new{4*i-1}+cell_new{4*i};
end
H_base_processed=cell2mat(H_base);
H_all=[H_all,H_base_processed];
layerNum=layerNum-1;
[H_base,H_all,layerNum]=separate(H_base,layerNum,H_all);
end
end
