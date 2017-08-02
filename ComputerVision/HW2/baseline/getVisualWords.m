%%   Q2.1 creat a histogram 
function wordmap = getVisualWords(I, filterBank, dictionary)
%     I=I(:,end:-1:1,:);  % for reversing
    wordmap=I(:,:,1);       % creat an equivalent size wordmap
    filterResponses = extractFilterResponses(I, filterBank);                % each pixels
    matrix_distance=pdist2(filterResponses,dictionary,'seuclidean');
    [unused index_feature]=min(matrix_distance');                           % right   
    wordmap(:)=index_feature;
    imshow(wordmap);
    colormap('default');
end