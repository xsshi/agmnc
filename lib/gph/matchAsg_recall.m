function recall = matchAsg_recall(X, asgT)
% Compute the Recall Rate, the rate of correct assignments and ground truth.
%
% Input
%   X       -  original assignment matrix, n1 x n2
%   asgT    -  ground-truth assignment (can be [])
%
% Output
%   recall     -  recall rate of the assignments.
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-22-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 02-14-2012
%   modify  -  Xiangsheng Shi (xsshi@foxmail.com) 03-04-2024

% ground-truth
XT = ps(asgT, 'X', []);
if isempty(XT)
    recall = 0;
    return;
end

% non-zero correspondence
idx = find(XT);

% #correct correspondences found
co = length(find(XT(idx) == X(idx)));

% percentage of Recall Rate
recall = co / length(idx);



