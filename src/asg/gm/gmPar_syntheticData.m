function [pars, algs] = gmPar_syntheticData(tag)
% Obtain parameters for graph matching algorithm.
%
% Input
%   tag     -  type of pair, 1 | 2 
%                1 : ga, sm, smac, ipfp1, ipfp2, rrwm, fgmU, Agm, AgmNC
%                2 : ga, sm, smac, ipfp1, ipfp2, rrwm, fgmU, fgmD, Agm,
%                AgmNC
%
% Output
%   pars    -  parameters for each algorithm, 1 x nAlg (cell), 1 x nPari (cell)
%   algs    -  algorithm name, 1 x nAlg (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-06-2013
%   modify  -  Xiangsheng Shi (xsshi@foxmail.com) 03-15-2024

[pars, algs] = cellss(1, 100);  % Produce numerous cell matrices.，pars and algs are both 1*100 cell matrices.

% graph matching with symmetric edge feature
if tag == 1
    nAlg = 0;

    % GA
    nAlg = nAlg + 1;
    parIni = st('alg', 'unif', 'nor', 'none');
    parPosC = st('alg', 'grad', 'b0', .5, 'bMax', 10);
    % parPosC = st('alg', 'grad', 'b0', max(ns), 'bMax', 200); % better
    parPosD = st('alg', 'hun');
    pars{nAlg} = {parIni, parPosC, parPosD};
    algs{nAlg} = 'GA';
    
    % PM
    nAlg = nAlg + 1;
    algs{nAlg} = 'PM';

    % SM
    nAlg = nAlg + 1;
    parIni = st('alg', 'sm', 'top', 'eigs');
    parPosC = st('alg', 'none');
    parPosD = st('alg', 'hun');
    pars{nAlg} = {parIni, parPosC, parPosD};
    algs{nAlg} = 'SM';
    
    % SMAC
    nAlg = nAlg + 1;
    parIni = st('alg', 'smac', 'top', 'eigs');
    parPosC = st('alg', 'none');
    parPosD = st('alg', 'hun');
    pars{nAlg} = {parIni, parPosC, parPosD};
    algs{nAlg} = 'SMAC';
    
%     % IPFP-U
%     nAlg = nAlg + 1;
%     parIni = st('alg', 'unif', 'nor', 'doub');
%     parPosC = st('alg', 'none');
%     parPosD = st('alg', 'ipfp', 'deb', 'n');
%     pars{nAlg} = {parIni, parPosC, parPosD};
%     algs{nAlg} = 'IPFP-U';
    
    % IPFP-S
    nAlg = nAlg + 1;
    parIni = st('alg', 'sm', 'top', 'eigs');
    parPosC = st('alg', 'none');
    parPosD = st('alg', 'ipfp', 'deb', 'n');
    pars{nAlg} = {parIni, parPosC, parPosD};
    algs{nAlg} = 'IPFP';
    
    % RRWM
    nAlg = nAlg + 1;
    parIni = st('alg', 'unif', 'nor', 'unit');
    parPosC = st('alg', 'rrwm');
    parPosD = st('alg', 'hun');
    pars{nAlg} = {parIni, parPosC, parPosD};
    algs{nAlg} = 'RRWM';
    
%     % FGM
%     nAlg = nAlg + 1;
%     parFgmS = st('nItMa', 100, 'nAlp', 101, 'thAlp', 0, 'deb', 'n');
%     pars{nAlg} = {parFgmS};
%     algs{nAlg} = 'FGM';
    
        
    % AGM
    nAlg = nAlg + 1;
    parAgm = st('rho', 8);
    pars{nAlg} = {parAgm};
    algs{nAlg} = 'AGM';
    
    % AGMNC
    nAlg = nAlg + 1;
    parAgmNC = st('rho', 10, 'beta', 2);
    pars{nAlg} = {parAgmNC};
    algs{nAlg} = 'OURS';


% graph matching with asymmetric edge feature
elseif tag == 2
    nAlg = 0;

    % GA
    nAlg = nAlg + 1;
    parIni = st('alg', 'unif', 'nor', 'none');
    parPosC = st('alg', 'grad', 'b0', .5, 'bMax', 10);
    % parPosC = st('alg', 'grad', 'b0', max(ns), 'bMax', 200); % better
    parPosD = st('alg', 'hun');
    pars{nAlg} = {parIni, parPosC, parPosD};
    algs{nAlg} = 'GA';
    
    % PM
    nAlg = nAlg + 1;
    algs{nAlg} = 'PM';

    % SM
    nAlg = nAlg + 1;
    parIni = st('alg', 'sm', 'top', 'eigs');
    parPosC = st('alg', 'none');
    parPosD = st('alg', 'hun');
    pars{nAlg} = {parIni, parPosC, parPosD};
    algs{nAlg} = 'SM';
    
    % SMAC
    nAlg = nAlg + 1;
    parIni = st('alg', 'smac', 'top', 'eigs');
    parPosC = st('alg', 'none');
    parPosD = st('alg', 'hun');
    pars{nAlg} = {parIni, parPosC, parPosD};
    algs{nAlg} = 'SMAC';

%     % IPFP-U
%     nAlg = nAlg + 1;
%     parIni = st('alg', 'unif', 'nor', 'doub');
%     parPosC = st('alg', 'none');
%     parPosD = st('alg', 'ipfp', 'deb', 'n');
%     pars{nAlg} = {parIni, parPosC, parPosD};
%     algs{nAlg} = 'IPFP-U';
    
    % IPFP-S
    nAlg = nAlg + 1;
    parIni = st('alg', 'sm', 'top', 'eigs');
    parPosC = st('alg', 'none');
    parPosD = st('alg', 'ipfp', 'deb', 'n');
    pars{nAlg} = {parIni, parPosC, parPosD};
    algs{nAlg} = 'IPFP';
    
    % RRWM
    nAlg = nAlg + 1;
    parIni = st('alg', 'unif', 'nor', 'unit');
    parPosC = st('alg', 'rrwm');
    parPosD = st('alg', 'hun');
    pars{nAlg} = {parIni, parPosC, parPosD};
    algs{nAlg} = 'RRWM';
    
    % FGM-U
%     nAlg = nAlg + 1;
%     parFgmS = st('nItMa', 100, 'nAlp', 101, 'thAlp', 0, 'deb', 'n', 'ip', 'n');
%     pars{nAlg} = {parFgmS};
%     algs{nAlg} = 'FGM-U';
%     
%     % FGM-D
%     nAlg = nAlg + 1;
%     parFgmA = st('nItMa', 100, 'nAlp', 101, 'deb', 'n', 'ip', 'n', 'lamQ', .5);
%     pars{nAlg} = {parFgmA};
%     algs{nAlg} = 'FGM-D';
    
        
    % AGM
    nAlg = nAlg + 1;
    parAgm = st('rho', 10.5);
    pars{nAlg} = {parAgm};
    algs{nAlg} = 'AGM';
    
    % AGMNC
    nAlg = nAlg + 1;
    parAgmNC = st('rho', 12.5, 'beta', 2.5);
    pars{nAlg} = {parAgmNC};
    algs{nAlg} = 'OURS';

else
    error('unknown tag: %d', tag);
end

pars(nAlg + 1 : end) = [];
algs(nAlg + 1 : end) = [];
