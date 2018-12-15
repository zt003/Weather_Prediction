function D=invcovmat(X)
%INVCOVMAT Estimation of the inverse covariance matrix. 
%   D = INVCOVMAT(X) estimates the covariance matrix C from data matrix X
%   and returns it inverse in matrix D. Each column in matrix X is con-
%   sidered a realization of a random vector. The covariance matrix C is
%   estimated by averaging all outer products of each column in X with
%   itself. Output D is then obtained from D = INV(C).




X=X-repmat(mean(X,2),1,size(X,2));

N=size(X,2);

C=zeros(size(X,1));

% compute the column correlations for each vector
for n=1:N
    % add to the correlation matrix
    C=C+X(:,n)*X(:,n).';    
end

% normalize the matrix and invert it
D=inv((1/N)*C);
