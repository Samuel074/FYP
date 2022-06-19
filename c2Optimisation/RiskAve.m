clear all;

load bluechipstockmoments;

n = length(AssetList);
H = 2*AssetCovar;
f = -AssetMean';
A = ones(1,n);
b = 1; 
lb = zeros(n,1);
ub = ones(n,1);

iterations = 100;
lambda = 0; %to be iterated
vReturn = zeros(iterations, 1);
vRisk = zeros(iterations, 1);
noMessage =  optimset('Display','off');

for i = 1:iterations
    [w, fval] = quadprog(lambda*H,f,[],[],A,b,lb,ub, '', noMessage);
    vReturn(i) = w'*AssetMean;
    vRisk(i) = w'*AssetCovar*w;
    
    lambda = i/15;
end

plot(vRisk*100, vReturn*100, 'linewidth', 2);
legend('Efficient Frontier Curve');
plotting('Risk Aversion','Mean of Returns (%)',...
    'Standard Deviation of Returns (%)');
grid;