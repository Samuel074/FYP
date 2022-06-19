% Vertically concatenate (n x m) matrix in
% into an (nm x 1) matrix
function out = vcat(in)
    [~,m] = size(in);
    temp = [];
    for i = 1:m
        temp = vertcat(temp,in(:,i));
    end
    out = temp;
end