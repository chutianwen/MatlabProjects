%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Q1.2    Finding interesting points
%%  Student:Tianwen Chu
%%  Date:   12/17/2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [locs, GaussianPyramid] = DoGdetector(im, sigma0, k, levels,th_contrast, th_r)
[GaussianPyramid] = createGaussianPyramid(im, sigma0, k, levels);
[DoGPyramid, DoG_levels] = createDoGPyramid(GaussianPyramid, levels);
PrincipalCurvature = computePrincipalCurvature(DoGPyramid);
locs = getLocalExtrema(DoGPyramid, DoG_levels, PrincipalCurvature,th_contrast, th_r);
end