function asg = agm123(K,Ct,asgT,rho)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% running time
ha = tic;

% dimension
[n1, n2] = size(Ct);
ns = [n1, n2];

% initialization
asgX = rand(ns) ; % assign matrix form
asgX = asgX./sum(asgX,2);
asgX = asgX./sum(asgX,1);
x0 = asgX(:); % vector form

% terminate condition
eps = 1e-3;
% PATH algorithm
zeta = 1;
      f = @(x) zeta*(x'*x - x'*ones([n1*n2,1]));
      gradf = @(x) zeta*(2*x-ones([n1*n2,1]));
      %grad = (1+zeta)*((K+K')*x0 - rho*ones([n1*n2,1])) + zeta*(2*x0-ones([n1*n2,1])); 
      grad = gradf(x0); % calculate the current grad

    
    asgY = zeros(ns); % store matrix form of LAP solution
    %y0 = asgY(:); % store the search direction(LAP solution)
    for i=1:2000 % Frank-Wolfe algorithm
        costVec = -1*grad;
        for j = 1:n1*n2 % Find the useless assign elements
            if costVec(j)>0
                costVec(j) = 0; % assign them to 0
            end
        end
        costMat = reshape(costVec, n1, n2); % turn vec to matrix for LAP
        ylap = lapjv(costMat);
        if n1>n2 % turn the sol of LAP into vec and mat
            for k=1:n2
                asgY(ylap(k),k) = 1; % matrix form of LAP sol
            end
        else
            for k=1:n1
                asgY(k,ylap(k)) = 1; % matrix form of LAP sol
            end
        end
        y0 = asgY(:); % vector form of LAP sol
        for j=1:n1*n2
            if costVec(j) == 0 % turn the LAP sol into partial assign
                y0(j) = 0;
            end
        end

            %f2 = @(x) -1*(1-zeta)*(x'*K*x - rho*x'*ones([n1*n2,1])) - zeta*(x'*x - x'*ones([n1*n2,1]));
            %gradf2 = @(x) -1*(1-zeta)*((K+K')*x - rho*ones([n1*n2,1])) - zeta*(2*x-ones([n1*n2,1]));
            alpha = ArmijoLineSearch(f,gradf,x0,y0-x0);

        x1 = x0 + alpha*(y0-x0); %update current assign
        x0 = x1;
        if norm(gradf(x0))<eps
            break;
        end
    end


asgX = reshape(x0,n1,n2);

% compare with ground-truth
acc = matchAsg(asgX, asgT);


asg.acc = acc;
asg.X = asgX;
asg.obj = f(x0);
asg.tim = toc(ha);
end

