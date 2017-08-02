%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Q2.3    Brief
%%  Notes:  comment part is for adding a Gaussian procession in advance
%%  Student:Tianwen Chu
%%  Date:   12/17/2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [locs, desc] = brief(im)
load parameters.mat;
[locs, GaussianPyramid] = DoGdetector(im, sigma0, k, levels,th_contrast, th_r);
load testPattern1;
% h = fspecial('gaussian',9,2);
% im_filtered=imfilter(im,h);
[locs,desc] = computeBrief(im, locs, levels, compareX, compareY);
end