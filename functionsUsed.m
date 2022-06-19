% plotting - plots and resizes font with one function
function plotting(t,y,x)
title(t);
ylabel(y);
xlabel(x);

ax = gca;
ax.FontSize = 20;
ax.FontName = "Times New Roman";
end

% vcat - vertically concatenate an n x k matrix into an nk x 1
%   i.e. in : [1 4 7;
%              2 5 8;
%              3 6 9]
%        out: [1;2;3;4;5;6;7;8;9]
function out = vcat(in)
    [~,k] = size(in);
    temp = [];
    for i = 1:k
        temp = vertcat(temp,in(:,i));
    end
    out = temp;
end