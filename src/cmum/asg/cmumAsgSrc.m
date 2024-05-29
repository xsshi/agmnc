function wsSrc = cmumAsgSrc(tag, pFs, nIns, varargin)
% Generate CMU Motion source for assignment problem.
%
% Input
%   tag      -  'house' | 'hotel'
%   pFs      -  frame index, 1 x 2
%   nIns     -  #inliers, 1 x 2, [1~30, 1~30]
%   varargin
%     save option
%
% Output
%   wsSrc
%     prex   -  prex
%     asgT   -  ground truth assignment
%     Pts    -  graph node set, 1 x mG (cell), 2 x ni
%     ords   -  order, 1 x mG (cell), 1 x ni
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 08-11-2011
%   modify   -  Feng Zhou (zhfe99@gmail.com), 03-03-2013
%   modify  -  Xiangsheng Shi (xsshi@foxmail.com) 03-10-2024

% save option
prex = cellStr(tag, pFs, nIns);
[svL, path] = psSv(varargin, ... %psSv.m Parse the save option and generate the output path.
                   'prex', prex, ...
                   'subx', 'src', ...
                   'fold', 'cmum/asg');

% load
if svL == 2 && exist(path, 'file')
    wsSrc = matFld(path, 'wsSrc');
    prInOut('cmumAsgSrc', 'old, %s', prex);
    return;
end
prIn('cmumAsgSrc', 'new, %s', prex);

% ground-truth label
CMUM = cmumHuman;

% marker position
Pts = CMUM.(tag).XTs(pFs); % Pts{1} is CMUM.house.XTs{1}  Pts{2}is CMUM.house.XTs{100} % pFs=[1 100]

% dimension
mG = 2;
n0 = size(Pts{1}, 2); % 2 is the vertex num
ns = nIns;

% per graph
ords = cellss(1, mG);

% randomly pick 18 inlier nodes
ord = randperm(n0); % random permutation of n0 where is the 1-30 perm
 % select the frist 30(-outliers 10) of ord. or first 1 (nlns(iG) is 1 or 100)
M = randi([1,n0 - nIns(1)]);
% M  =  5;
% store the inliers and the outliers
ords{1} = [ord(1 : nIns(1)), ord(nIns(1) + 1 : nIns(1) + M)];
ords{2} = [ord(1 : nIns(1)), ord(nIns(1) + M + 1 : n0)];
ord1 = ords{1};
ord2 = ords{2};
Pts{1} = Pts{1}(:, ord1);
Pts{2} = Pts{2}(:, ord2);


% ground-truth assignment
XT = eye(n0);
asgT.alg = 'truth';
asgT.X = XT(ords{1}, ords{2}); %permutation of 

% store
wsSrc.prex = prex;
wsSrc.Pts = Pts;
wsSrc.asgT = asgT;
wsSrc.ords = ords;
wsSrc.tag = tag;
wsSrc.pFs = pFs;
wsSrc.nIns = nIns;

% save
if svL > 0
    save(path, 'wsSrc');
end

prOut;
