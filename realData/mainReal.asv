clear all;

% p: lag order
% N: time span
% n: number of assets / portfolio size
p = 1;
N = 20; %Note: for N>30 the algorithm takes over 15 minutes
T = [2:N+1];
n = 10;

% Yfull: nmax x Tmax return matrix
Yfull = readtable('data.xlsx','sheet',2,'Range','B4:CR340',...
    "VariableNamingRule","preserve"); 
Yfull = table2array(Yfull);
Yfull = Yfull';

% Xtemp: q x T factor matrix 
    % X: proper k x T factor matrix
Xtemp = readtable('data.xlsx','sheet',3,'Range','B4:G340',...
    "VariableNamingRule","preserve");
Xtemp = table2array(Xtemp);
Xtemp = Xtemp';
Xtemp = Xtemp(:,1:N);

q = size(Xtemp,1); % q is 6
k = q*(p+1);

I = [1:n]; % Just using the first 10 assets in Data
Y = Yfull([I],1:N); 

% Extract X factors
X = zeros(k,N);
X(1:q,:)=Xtemp;
for i = 1:p
    X(i*q+1:(i+1)*q,1:i) = repmat(Xtemp(:,1),1,i);
    X(i*q+1:(i+1)*q,i+1:end)=Xtemp(:,1:N-i);
end

% Estimate the portfolio returns
for i=1:N
    Y_est(:,i) = YestLMI_real(Y,X,T(i),n,q,p);
    Y_esti(:,i) = YestEM_real(Y,X,T(i),n,q,p);
end

for i = 1:N
    Y_act(i) = norm(Y(:,i));
    Y_n(i) = norm(Y_est(:,i));
    Yerr_n(i) = norm(Y(:,i)-Y_est(:,i))/norm(Y(:,i));
    Yi_n(i) = norm(Y_esti(:,i));
    Yerri_n(i) = norm(Y(:,i)-Y_esti(:,i))/norm(Y(:,i));
end

% Insert graphing here if needed i.e.
figure(); hold on;
plot(Y_act, 'linewidth', 2);
plot(Y_n, 'linewidth', 2);
plot(Yi_n, 'linewidth', 2);
legend('Y_{Actual}','Y_{LMI}','Y_{EM}');
plotting('Actual vs Estimated returns for Real data', 'Returns', 'Days');
axis([1 20 0 0.5]);
grid;
hold off;

figure();hold on;
plot(Yerr_n, 'linewidth', 2);
plot(Yerri_n, 'linewidth', 2);
legend('LMI', 'EM');
plotting('Return estimation errors for Real data', 'Error', 'Days');
axis([1 20 0 0.5]);
grid;
hold off;