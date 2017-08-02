function [filterBank] = createFilterBank()
% Xinlei Chen
% CV Fall 2013 - Provided Code
% Code to get a reasonable filter bank

%3 scales
scales = 1:3;

%Some arbitrary bandwidths
gaussianSigmas = [1, 2, 4];
logSigmas = [1, 2, 4, 8];
apha=[0.1,0.2,0.3];
dGaussianSigmas = [2, 4];

    
filterBank = cell(length(scales) * (length(gaussianSigmas) + length(logSigmas) + length(apha) + length(dGaussianSigmas)), 1);

ind = 1;
for scale=scales
    scaleMultiply = sqrt(2)^scale;
    %Gaussians
    for s=gaussianSigmas
        filterBank{ind} = getGaussianFilter(s*scaleMultiply);
        ind = ind + 1;
    end
    %LoG
    for s=logSigmas
        filterBank{ind} = getLOGFilter(s*scaleMultiply);
        ind = ind + 1;
    end
    %laplacian
    for s=apha;
        filterBank{ind} = getLaplacianFilter(s*scaleMultiply);
        ind = ind + 1;
    end
    %d/dx, d/dy Gaussians
    for s=dGaussianSigmas
        filterBank{ind} = filterDerivativeX(getGaussianFilter(s*scaleMultiply));
        ind = ind + 1;
        filterBank{ind} = filterDerivativeY(getGaussianFilter(s*scaleMultiply));
        ind = ind + 1;
    end
end

end

function h = getGaussianFilter(sigma)
    h = fspecial('gaussian',ceil(sigma*3*2+1),sigma);
end

function h = getLOGFilter(sigma)
    h = fspecial('log',ceil(sigma*3*2+1),sigma);
end
%% laplacian filters
function h = getLaplacianFilter(alpha)
    h = fspecial('laplacian', alpha);
end

%%
function hD = filterDerivativeX(h)
    ddx = [-1, 0, 1];
    hD = imfilter(h, ddx); 
end

function hD = filterDerivativeY(h)
    ddy = [-1, 0, 1]';
    hD = imfilter(h, ddy);
end

