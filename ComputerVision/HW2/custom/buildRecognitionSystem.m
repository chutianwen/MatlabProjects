%   Q2.4
%   produce the 'vision.mat'
%   load the files and texton dictionary

load traintest.mat;
load dictionary.mat filterBank dictionary;

%% create the classTrs
impath_train = strcat('wordmaps/',strrep(imTrs(:),'.jpg','.mat'));    %   paths of imTrs
classTrs=csTrs';
L = length(impath_train);
featureTrs=[];
for i=1:L
    load(impath_train{i});
    histogram = getImageFeaturesSPM( 3, wordMap, size(dictionary,1) );
    featureTrs=[featureTrs,histogram];
end
save vision.mat filterBank dictionary featureTrs classTrs;