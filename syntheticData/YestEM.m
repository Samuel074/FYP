function [Y_act,Y_est,Y_fc,e_est,e_fc,e_FLM] = YestEM(T,n,q,p,noise,random)
% Outputs:
    % Y: Normalised returns
    % e: Normalised errors 

rng(random);
e = noise*randn(n);
k=q*(p+1); 

% Define the matrices A,B,Q
% A: weight transition model – mxm state transition matrix
% B: mxk control input matrix
% Q: kxk process noise covariance matrix
A=[zeros(q,k-q),zeros(q,q); eye(q*p),zeros(k-q,q)];
B=eye(k,q); 
Q=eye(q);

% u: vector of idiosyncratic component due to k factors/control vector
% V: vector of idiosyncratic risk for n risky assets/measurement noise vector
u = zeros(q,T-1);
v = zeros(n,T-1);

for i=1:T-2 
	u(:,i)=Q*randn(q,1);
	v(:,i)=e*randn(n,1); 
end 

% X_(t+1)=AX_t + Bu_t 
%   => X_t = AX_(t-1) + Bu_(t-1)
% Dynamic Observation Model: Y_t=CX_t + v_t
%   => Y_(t-1) = CX_(t-1) + v_(t-1)

X(:,1)=[u(:,1); zeros(k-q,1)]; 
Y = zeros(n,T-1); 
% Set a random covariance matrix C 
C = randn(n,k);

for t = 2:T
	X(:,t)=A*X(:,t-1)+B*u(:,t-1);
	Y(:,t-1)=C*X(:,t-1)+v(:,t-1); 
end 

Yhat = Y; Xhat = X(:,1:end-1);
% Optimisation to estimate FLM using EM Algorithm
C_est = CestEM(Yhat,Xhat,A,B,u,k,n);

E = e*e';
% Kalman Filtering to calculate estimated returns based on C_est
[Y_est, Y_fc] = KF(Y,E,A,B,Q,C_est,C,k,T);

Y_act = Y(:,end);
e_est = norm(Y_act-Y_est)/norm(Y_act); e_fc = norm(Y_act-Y_fc)/norm(Y_act);
Y_act = norm(Y_act); Y_est = norm(Y_est); Y_fc = norm(Y_fc);
e_FLM = norm(C-C_est)/norm(C);
end