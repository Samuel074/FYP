function Y_est = YestLMI_real(Y,X,T,n,q,p)
% Output:
    % Y_est: Estimated returns based on optimisation

k=q*(p+1);

% Define the matrices A,B,Q
    % A: Transition matrix 
    % B: Control input matrix
    % Q: Process noise covariance matrix
A=[zeros(q,k-q),zeros(q,q); eye(q*p),zeros(k-q,q)];
B=eye(k,q); 
Q=eye(q);

Xhat = X(:,1:T-1); Yhat = Y(:,1:T-1);
% Optimisation to estimate the idiosyncratic component affecting factors
u = Uest(Xhat,A,B,k,q);
% Idiosyncratic component affecting returns
v = zeros(n,T-1); 

% Optimisation to estimate FLM using LMI algorithm
C_est = CestLMI(Yhat,Xhat,A,B,u,v,k,n,q,0,0);

% Process noise    
E = zeros(n);
% Kalman Filtering to calculate estimated returns based on C_est
Y_est = KF_real(Y,E,A,B,Q,C_est,k,T);
end