clear all;

load bluechipstockmoments;

n = length(AssetList);

mktRisk = mean(mean(AssetCovar)); %risk of equally weighted portfolio
vWeight = zeros(n,1);

iterations = 10;
vReturn = zeros(iterations, 1);
vRisk = zeros(iterations, 1);

for i = 1:iterations
    %using MATHWORKS proposed constants
    riskMax = 0.0015+mktRisk*2.5*i/iterations;
    e = ones(n,1);
    
    cvx_begin sdp quiet
    cvx_precision default
    variable vWeight(n)
    
    maximize(AssetMean'*vWeight);
    
    subject to
    e'*vWeight == 1;
    for j = 1:n
        vWeight(j) >= 0;
    end
    [riskMax, vWeight';vWeight, inv(AssetCovar)] >= 0; %Schur complement
    cvx_end
    
    vRisk(i) = vWeight'*AssetCovar*vWeight;
    vReturn(i) = vWeight'*AssetMean;
    e = (eig([riskMax,vWeight';vWeight,inv(AssetCovar)]));
end

plot(vRisk*100, vReturn*100, 'linewidth', 2);
legend('Efficient Frontier Curve');
plotting('Return Maximisation','Mean of Returns (%)',...
    'Standard Deviation of Returns (%)');
grid;