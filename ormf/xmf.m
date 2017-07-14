function [P, Q, A] = xmf(X, Y, dim, lambda, w_m, alpha_1, model1_file, model2_file)

try
t_begin = cputime;
%%% 1. initialization
[n_words1, n_docs1] = size(X);
[n_words2, n_docs2] = size(Y);

fprintf('[ormf()]: lang 1 n_words=%d n_docs=%d n_tokens=%d\n', n_words1, n_docs1, nnz(X));
fprintf('[ormf()]: lang 2 n_words=%d n_docs=%d n_tokens=%d\n', n_words2, n_docs2, nnz(Y));
fprintf('[ormf()]: dim=%d lambda=%f w_m=%f alpha=%f\n', dim, lambda, w_m, alpha_1);

load(model1_file);
if exist('P', 'var')==0
        P=A;
end

alpha=alpha_1;

% build index for X
i4d1 = cell(2,n_docs1);
for j = 1:n_docs1
    [i4d1{1,j}, ~, i4d1{2,j}] = find(X(:,j));
end

% build index for Y
i4d2 = cell(2,n_docs2);
for j = 1:n_docs2
    [i4d2{1,j}, ~, i4d2{2,j}] = find(Y(:,j));
end

X_t = X';
Y_t = Y';
i4w1 = cell(2,n_words1);
for i = 1:n_words1
    [i4w1{1,i}, ~, i4w1{2,i}] = find(X_t(:,i));
end

i4w2 = cell(2,n_words2);
for i = 1:n_words2
    [i4w2{1,i}, ~, i4w2{2,i}] = find(Y_t(:,i));
end


A = randn(dim, n_words2);
Q = zeros(dim, n_docs1);

clear X X_t;
clear Y Y_t;

pptw = P*P'*w_m;

fprintf('calculating Q...\n');
    
parfor j = 1:n_docs1
        pv = P(:,i4d1{1,j});
	Q(:,j) = (pptw + pv*pv'*(1-w_m) + lambda*eye(dim))  \  (pv*i4d1{2,j});
end

qqtw = Q*Q'*w_m;
parfor i = 1:n_words2
        qv = Q(:,i4w2{1,i});
        A(:,i) = (qqtw + qv*qv'*(1-w_m) + lambda*eye(dim))  \  (qv*i4w2{2,i});
end

if alpha_1 ~= 0
        A = A - alpha_1 * (A*A'- diag(mean(diag(A*A'))*ones(dim,1)))*A;
end

catch ME
	rethrow(ME)
end
t_end = cputime;
fprintf('[ormf()]: used %f seconds\n', t_end-t_begin);

end

