%% Q2.3 Create the function distanceToSet
function [ histInter ] = distanceToSet( wordHist, histograms )
distance_min = bsxfun(@min,wordHist,histograms);
histInter = sum(distance_min);
end
