function x = PCA(x, T)
[m, n, p] = size(x);
x = reshape(x, m*n, p);
[coeff, score, latent] = pca(x);

CEX = latent / sum(latent);
CEX = cumsum(CEX);
Component = find(CEX >= T, 1);
score = score(:, 1:Component);
coeff = coeff(:, 1:Component);
x = score * coeff';
x = reshape(x,m,n,p);
end