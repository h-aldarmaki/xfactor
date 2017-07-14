function [] = train_xmf(data_file1, data_file2, model1_file, model2_file, dim, lambda, w_m, alpha)

text1_train = load(data_file1);
text2_train = load(data_file2);
text1_train = spconvert(text1_train);
text2_train = spconvert(text2_train);


[~,~,A] = xmf(text1_train, text2_train, dim, lambda, w_m, alpha, model1_file, model2_file);
P=A;
save(model2_file, 'P', 'dim', 'lambda', 'w_m', 'alpha');
exit;
end
