%%  Q2.5 Quantitative Evaluation
load traintest.mat imTss csTss mapping;
for i = 1:length(imTss)
    guess{i} = guessImage(strcat('images/', imTss{i}));
end

for i = 1:length(mapping)
    facts(find(strcmp(guess, mapping{i}))) = i;
end
cc= confusionmat(csTss', facts);
correct_percentage = trace(cc) / sum(cc(:));
save accuracy_result_Hel. cc correct_percentage;