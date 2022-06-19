% Calculates estimated and forecasted return via KF
function [Y, Yfc] = KF(Y,E,A,B,Q,C_est,C,k,T)
    % Initialisation of variables
    X_p(:,1)=zeros(k,1); % Predicted state estimate
    X_c(:,1)=zeros(k,1); % Corrected state estimate
    Sig(:,:,1)=eye(k);
    
    X_p_C(:,1)=zeros(k,1); % Predicted state estimate
    X_c_C(:,1)=zeros(k,1); % Corrected state estimate
    Sig_C(:,:,1)=eye(k);

    for t=2:T
        % Kalman Gain estimation
        L = Sig(:,:,t-1)*C_est'*inv(C_est*Sig(:,:,t-1)*C_est'+E);
        Sig(:,:,t)=A*Sig(:,:,t-1)*A'+B*Q*B'-A*L*C_est*Sig(:,:,t-1)*A';

        % Estimation of X_p state 
        X_p(:,t)=A*L*(Y(:,t-1)-C_est*X_p(:,t-1))+A*X_p(:,t-1); 
        % Estimation of X_c
        X_c(:,t-1)=X_p(:,t-1)+L*(Y(:,t-1)-C_est*X_p(:,t-1)); 
        
        % Prediction using C_actual
        L_C = Sig_C(:,:,t-1)*C'*inv(C*Sig_C(:,:,t-1)*C'+E);
        Sig_C(:,:,t)=A*Sig_C(:,:,t-1)*A'+B*Q*B'-A*L_C*C*Sig_C(:,:,t-1)*A';
        X_p_C(:,t)=A*L_C*(Y(:,t-1)-C*X_p_C(:,t-1))+A*X_p_C(:,t-1); 
        X_c_C(:,t-1)=X_p_C(:,t-1)+L_C*(Y(:,t-1)-C*X_p_C(:,t-1)); 
        
        % If reached current time    
        if t == T
            Y = C_est*X_c(:,t-1);
            Yfc = C*X_c_C(:,t-1);
        end
    end
end

