%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Q1.1.1  The DoG Pyramid
%%  Student:Tianwen Chu
%%  Date:   12/17/2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [DoGPyramid, DoG_levels] = createDoGPyramid(GaussianPyramid, levels)
for i=1:length(levels)-1
    DoGPyramid(:,:,i)=GaussianPyramid(:,:,i+1)-GaussianPyramid(:,:,i);
    DoG_levels(i)=levels(i+1);
end