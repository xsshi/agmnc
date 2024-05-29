function acc = matchAsg_acc(X, asgT)
% Compute the Accuracy, the rate of correct assignments and selected assignments.
%
% Input
%   X       -  original assignment matrix, n1 x n2
%   asgT    -  ground-truth assignment (can be [])
%
% Output
%   acc     -  Accuracy of the matching
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-22-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 02-14-2012
%   recreate  -  Xiangsheng Shi (xsshi@foxmail.com) 03-04-2024

% ground-truth
XT = ps(asgT, 'X', []);
if isempty(XT)
    acc = 0;
    return;
end

% non-zero correspondence
idx = find(XT);

% #correct correspondences found
co = length(find(XT(idx) == X(idx)));

% percentage of Accuracy
idx2 = find(X);
if isempty(idx2)
    acc = 0;
else
    acc = co / length(idx2);
end


