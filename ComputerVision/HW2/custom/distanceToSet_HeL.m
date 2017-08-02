% Q3.2
% Compute the histogram similarity between training data and test data 
function [ histInter ] = distanceToSet_HeL( wordHist, histograms )
%    wordHist: K(4^(L+1)-1)/3 x 1 vector
%    histograms:  K(4^(L+1)-1)/3 x T matrix, T is the number of training
%    image
% using chi-square & Hellinger to compute the similarity
format long
%%
% Chi=bsxfun(@Chisquare,wordHist, histograms);
% % remove 'NaN' in the chi-square
% Chi(find(isnan(Chi)))=0;
% histInter=sum(Chi);
%%
H=bsxfun(@Hellinger,wordHist,histograms);
histInter=sqrt(sum(H))/sqrt(2);
end

% function [chi]=Chisquare(wordHist, histograms)
% 
% chi=(wordHist(:)-histograms(:)).^2./(wordHist(:)+histograms(:));
% end

function [H]=Hellinger(wordHist, histograms)
H=(sqrt(wordHist(:))-sqrt(histograms(:))).^2;
end