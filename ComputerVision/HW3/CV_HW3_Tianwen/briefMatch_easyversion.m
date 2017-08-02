%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Q2.4    Descriptor Matching
%%  Notes:  Mapping from left picture to right picture
%%          Can suitable to large scale of pictures
%%  Student:Tianwen Chu
%%  Date:   12/17/2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [matches] = briefMatch_easyversion(desc1, desc2, ratio)
%% output 1st min and corresponding index
[min_1st, I] = min(pdist2(desc1, desc2, 'hamming')');

%% initiate matches.
matches = [[1:length(min_1st)]',I'];

%% prepare for find min_2nd
hammingDistance = sort(pdist2(desc1, desc2, 'hamming'), 2);

%% output the indeces of valid ratio between min_1st and min_2nd
% than ratio.
ratio_compared = min_1st./hammingDistance(:, 2)';

indece = find(ratio_compared > ratio);

%% Assign empty to non-matched points.
matches(indece, :) = [];
    
end