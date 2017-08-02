%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Q1.1.2  Edge Suppression
%%  Student:Tianwen Chu
%%  Date:   12/17/2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function PrincipalCurvature = computePrincipalCurvature(DoGPyramid)
PrincipalCurvature=zeros(size(DoGPyramid));
L=size(DoGPyramid);
for i=1:L(3)
    [Dx,Dy]=gradient(DoGPyramid(:,:,i));
    Dxx=gradient(Dx);
    [Dyx,Dyy]=gradient(Dy);
    Tr=Dxx+Dyy;
    Det=Dxx.*Dyy-Dyx.*Dyx;
    PrincipalCurvature(:,:,i)=Tr.^2./Det;
end

    