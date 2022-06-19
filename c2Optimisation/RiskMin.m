clear all;

% 1 - load the data
% 2 - set useful variables (A, lb, ub)
% 3 - more initialisation
% 4 - create loop, iterating b while saving values
    % quadprog(H,f,A,b,Aeq,beq,lb,ub)
% 5 - plot curve

%Step 1
load bluechipstockmoments;

%Step 2
n = length(AssetList);
H = 2*AssetCovar;
f = zeros(n,1);
A = -AssetMean';
lb = zeros(n,1);
ub = ones(n,1);

%Step 3
vWeightComp = 1/n*ones(n,1);
returnPar = abs(AssetMean'*vWeightComp); %reference mean for b
%alternatively, returnPar = mean(AssetMean);

iterations = 1000;
b = 0; %to be iterated
vReturn = zeros(iterations, 1);
vRisk = zeros(iterations, 1);
vRisk2 = zeros(iterations, 1);
noMessage =  optimset('Display','off');

%step 4
for i = 1:iterations
    [w, fval] = quadprog(H,f,A,b,A,b,lb,ub, '', noMessage);
    vReturn(i) = w'*AssetMean;
    vRisk(i) = w'*AssetCovar*w;
    %vRisk(i) = risk; %alternative way since f = 0    
    b = -returnPar*i/(0.5*iterations);
end

%step 5
plot(vRisk*100, vReturn*100, 'linewidth', 2);
legend('Efficient Frontier Curve');
plotting('Risk Minimisation','Mean of Returns (%)',...
    'Standard Deviation of Returns (%)');
grid;