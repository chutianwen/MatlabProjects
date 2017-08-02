%   Q2.1    creat a histogram which has a k*1 array
function [h] = getImageFeatures(wordMap, dictionarySize)

num_feature=1:dictionarySize;            % construct xcenters parameters
[h]=hist(wordMap(:),num_feature);
[h]=h./sum(h);                         % normalize h
    
end