% Optimization algorithm using Error Minimisation to estimate C
function Cout = CestEM(Y,X,A,B,u,k,n) 
% Inputs:
	% Y: n x T matrix: asset returns 
    % X: m x T matrix: dynamic factors 
    % A, B: Transition matrices  
% Output:
	% Cout: n x m matrix: factor loading matrix 

% variables to be stacked:
% y = Chat*A1*x0 + Chat*Dw*w + Dv*v
    % where Dw = A2*Bhat
    
% stack y,x0,w,v
[~,T] = size(X);
y = vcat(Y);
x0 = kron(ones(T,1),X(:,1));
u = vcat(u);

% stack A0 and A1
A0 = zeros(T*k,k);
A1 = zeros(T*k,T*k);
for i = 1:T
    st = k*(i-1)+1;
    ed = k*(i-1)+k;
    A0(st:ed,1:k) = A^(i-1);
    A1(st:ed,st:ed) = A^(i-1);
end

% stack Dw
Bhat = kron(eye(T),B);
A2 = zeros(T*k,T*k);
for i = 1:T-1
    st = k*i+1; 
    ed = k*i; 
    A2(st:end,st-k:ed) = A0(1:T*k-st+1,:);
end
Dw = A2*Bhat;

%%%%% SDP BEGIN %%%%%
cvx_begin sdp quiet 
cvx_precision best

variable C(n,k); %FLM
Chat = kron(eye(T),C);

minimize( norm( y - Chat*A1*x0 - Chat*Dw*u ))

cvx_end 

Cout=C; 