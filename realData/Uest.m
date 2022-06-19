% Optimization algorithm to estimate U
function Uout = Uest(X,A,B,k,q) 
% Inputs:
    % X: factors affecting returns
    % A, B: Transition matrices 
% Output:
	% Uout: n x k factor loading matrix 

% variables to be stacked:
% x = A1*x0 + B1*uout
    
% stack y,x0,w,v
[~,T] = size(X);
x0 = kron(ones(T,1),X(:,1));
x = vcat(X);

% stack A0 and A1
A0 = zeros(T*k,k);
A1 = zeros(T*k,T*k);
for i = 1:T
    st = k*(i-1)+1;
    ed = k*(i-1)+k;
    A0(st:ed,1:k) = A^(i-1);
    A1(st:ed,st:ed) = A^i;
end

% stack B1
Bhat = kron(eye(T),B);
A2 = zeros(T*k,T*k);
for i = 1:T
    st = k*(i-1)+1; 
    ed = k*i; 
    A2(st:end,st:ed) = A0(1:T*k-st+1,:);
end
B1 = A2*Bhat;

% x = A1*x0 + B1*u
%%%%% SDP BEGIN %%%%%
cvx_begin sdp quiet 
cvx_precision default
variable u_unstacked(q,T);

u = vcat(u_unstacked);

minimize(norm( x - A1*x0 - B1*u ))    
    
cvx_end 

Uout = u_unstacked; 
end 