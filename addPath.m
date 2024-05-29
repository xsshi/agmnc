function addPath
% Add folders of predefined functions into matlab searching paths.
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-20-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-07-2013
%   modify  -  Xiangsheng Shi (xsshi@foxmail.com) 01-07-2024

global footpath;
footpath = cd;

addpath(genpath([footpath '/src']));
addpath(genpath([footpath '/lib']));
addpath(genpath([footpath '/agmnc']));


% random seed generation
% RandStream.setDefaultStream(RandStream('mt19937ar', 'seed', sum(100 * clock)));
