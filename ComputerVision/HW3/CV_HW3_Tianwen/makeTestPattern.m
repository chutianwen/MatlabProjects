%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Q2.1    Creating a Set of BRIEF Tests
%%  Notes:  Add 5 to get positive integar of row and col
%%  Student:Tianwen Chu
%%  Date:   12/17/2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [compareX, compareY] = makeTestPattern(patchWidth, nbits)
sigma=patchWidth/5;
limit_border=floor(patchWidth/2);
compareX = round(mvnrnd([0 0],[sigma,0;0,sigma], nbits));
compareX(compareX>limit_border)=limit_border;
compareX(compareX<-limit_border)=-limit_border;
compareY = round(mvnrnd([0 0],[sigma,0;0,sigma], nbits));
compareY(compareY>limit_border)=limit_border;
compareY(compareY<-limit_border)=-limit_border;
%%  normalize to positive index
compareX=compareX+limit_border+1;
compareY=compareY+limit_border+1;
compareX=sub2ind([patchWidth,patchWidth],compareX(:,1),compareX(:,2));
compareY=sub2ind([patchWidth,patchWidth],compareY(:,2),compareY(:,2));
save testPattern compareX compareY;
end