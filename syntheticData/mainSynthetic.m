clear all;

% n: number of assets / portfolio size
% q: number of factors
% p: lag order
% N: time span (if T varying)
% noise: noise
n = 10; % n = 1:50;
q = 3; % q = 1:8;
p = 1; % p = 1:10;

% Number of iterations based on parameter being tested
    % Note: for N>30 the first usually takes over 15 minutes
N = 10;

% T = 20; 
T = 2:N+1;

% Idiosyncratic component for KF
noise = 0.3; % noise = 0.01:0.05:2;

random = 'default';

k = q*(p+1);

% Bound accuracy (0 for maximum accuracy)
br = 0; % br = 0:0.1:1.5;
bv = 0; % bv = 0:0.1:1.5;
% Nbound = 16;

% Estimate normalised returns and errors
for i=1:N
    % Algorithm 1: LMI Algorithm
    [Y_act(i),Y_est(i),Y_fc(i),e_est(i),e_fc(i),e_FLM(i)] = ...
        YestLMI(T(i),n,q,p,noise,random,br,bv);
    
    % Algorithm 2: Error Minimisation Algorithm
    [Y_acti(i),Y_esti(i),Y_fci(i),e_esti(i),e_fci(i),e_FLMi(i)] = ...
        YestEM(T(i),n,q,p,noise,random);
end

% % For looping bounds
% tic
% for i=1:N
%     for j = 1:Nbound
%     [Y_act(i,j),Y_est(i,j),Y_fc(i,j),e_est(i,j),e_fc(i,j),e_FLM(i,j)] = ...
%         YestLMI(T,n,q,p,noise,random,br(j),bv(j));
%     end
% end
% toc

% Insert graphing here if needed i.e.
figure(); hold on;
plot(Y_act, 'linewidth', 2);
plot(Y_est, 'linewidth', 2);
legend('Y_{Actual}','Y_{Estimate}');
plotting('Actual vs Estimated returns for LMI Algorithm', 'Returns', 'Days');
grid;
hold off;

figure(); hold on;
plot(Y_acti, 'linewidth', 2);
plot(Y_esti, 'linewidth', 2);
legend('Y_{Actual}','Y_{Estimate}');
plotting('Actual vs Estimated returns for EM Algorithm', 'Returns', 'Days');
grid;
hold off;

figure();
subplot(1,2,1); hold on;
plot(e_est, 'linewidth', 2);
plot(e_esti, 'linewidth', 2);
legend('LMI', 'EM');
plotting('Return estimation errors', 'Error', 'Days');
grid;
hold off;
subplot(1,2,2); hold on;
plot(e_FLM, 'linewidth', 2);
plot(e_FLMi, 'linewidth', 2);
legend('LMI', 'EM');
plotting('FLM estimation errors', 'Error', 'Days');
grid;
hold off;