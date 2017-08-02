I=imread('images/campus/sun_acmiuobndrlyknxn.jpg');
I_reversed=I(:,end:-1:1,:);
imshow(I_reversed);
wordmap = getVisualWords(I, filterBank, dictionary);