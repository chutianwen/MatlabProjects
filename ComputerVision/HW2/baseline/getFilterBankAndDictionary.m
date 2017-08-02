%%  Q1.Creating Visual Words
function [filterBank, dictionary] = getFilterBankAndDictionary(toProcess)
tic;
[filterBank] = createFilterBank();
k=200;        % number of features
apha=100;     % number of selected filter_responses
filter_melt=[];
for i=1:length(toProcess)
    I{i}= imread(toProcess{i});
    [filterResponses] = extractFilterResponses(I{i}, filterBank);
    L=size(filterResponses,1);      %  number of pixels 
    filter_melt=[filter_melt;filterResponses(randperm(L,apha),:)];
%   filter_melt1((i-1)*apha+1:i*apha,:)=filterResponses(randperm(L,apha),:);
end
    [unused, dictionary] = kmeans(filter_melt, k, 'EmptyAction','drop');
toc;
end

