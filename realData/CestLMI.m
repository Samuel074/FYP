% Optimization algorithm using Schur complement to estimate C
% Customise bounds for r: x and u separate from v
    % v is assumed to be unknown (0)
function Cout = CestLMI(Y,X,A,B,u,v,k,n,q,br,bv) 
% Inputs:
	% Y: asset returns 
    % X: factors affecting returns
    % u: contol input
    % v: idiosyncratic component for returns
    % A, B: Transition matrices 
% Output:
	% Cout: n x k factor loading matrix 
% Parameters:
	% k: number of factors x (lag-order + 1) 
    % n: number of assets/portfolio size
	% q: number of factors 
    % br, bv: bounds for data and noise      

% variables to be stacked:
% y = Chat*A1*x0 + Chat*Dw*w + Dv*v
    % where Dw = A2*Bhat
    
% stack y,x0,w,v
[~,T] = size(X);
y = vcat(Y);
x0 = kron(ones(T,1),X(:,1));
u = vcat(u);
v = vcat(v);

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

% stack Dv
Dv = eye(T*n);

% stacking in the form:
% y = Ct*X0*r

% data matrix: factors, idiosyncratic inputs and component
r = [x0; u; v];
% data bounds: change multiplier to adjust accuracy/certainty
rub = zeros(size(r)); rlb = zeros(size(r));
id = size([x0;u],1);

rub(1:id)=r(1:id)+br*abs(r(1:id)); rlb(1:id)=r(1:id)-br*abs(r(1:id));
rub(id+1:end)=bv; rlb(id+1:end)=-bv;

% transition matrices
X0 = [A1            , Dw            , zeros(T*k,T*n);
      zeros(T*n,T*k), zeros(T*n,T*q), Dv           ];

%%%%% SDP BEGIN %%%%%
cvx_begin sdp quiet 
cvx_precision default
variable g2 nonnegative; %gamma^2
variable C(n,k); %FLM
variable R(T*(k+q+n),T*(k+q+n)) diagonal;

% C-tilda
Chat = kron(eye(T),C);
Ct = [Chat, eye(T*n)];

% Schur complement
L = [y'*y-g2+rlb'*R*rub       , -y'*Ct*X0-0.5*(rub+rlb)'*R, zeros(1,T*n)  ;
    -X0'*Ct'*y-0.5*R*(rub+rlb), R                         , X0'*Ct'       ;
    zeros(T*n,1)              , Ct*X0                     , -eye(T*n,T*n)];

minimize(g2)    
subject to
    R <= 0; 
    L <= 0;
    
cvx_end 

Cout=C; 
end 