%% This function is aimng at finding brief descriptor hamming distance.
%% Author: Linfeng Cai
%% Date: 2013.12.14

function [matches] = briefMatchclf(desc1, desc2, ratio)
    
    % Find the smallest hamming distance and indeces.
    [minimal, I] = min(pdist2(desc1, desc2, 'hamming')');
    
    % Initialise matches.
    matches = [[1:length(minimal)]' I'];
    
    % Find second smallest hamming distance by sorting.
    hammingDistance = sort(pdist2(desc1, desc2, 'hamming'), 2);
    
    % Find the indeces of ratio between minimal to second minial larger
    % than ratio.
    calculated_ratio = minimal./hammingDistance(:, 2)';
    
    indeces = find(calculated_ratio > ratio);
    
    % Assign empty to non-matched points.
    matches(indeces, :) = [];
    
end