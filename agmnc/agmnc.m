function asg = agmnc(K, Ct, gphs, asgT, pars)
    ha = tic;
    [n1, n2] = size(Ct);
    ns = [n1, n2];
    
    
    
    sum_K = sum(K(:)); % 

    % 
    rho = 4.1 * n1 * (sum_K / ((n1 * n2)^2));
    beta = 0.06 * rho ;
    
    
%     sum_K = sum(K(:)); % 
% 
%     % 
%     rho = 1.3 * n1 * (sum_K / ((n1 * n2)^2));
%     beta = 0.2 * rho ;
    
%     prIn('AgmNC', 'rho %4.2f, beta %4.2f', rho, beta);
    
    para = struct();
    para.K = K;
    para.rho = rho;
    para.beta = beta;
    para.n = n1 * n2;

    % Initialization
%     asgX = zeros(ns);
    asgX = ones(ns);
%     asgX = bsxfun(@rdivide, asgX, sum(asgX, 2));
%     asgX = bsxfun(@rdivide, asgX, sum(asgX, 1));%
    x0 = asgX(:)/max(n1, n2);
%     x0 = asgX(:);

%     asgX = rand(ns);
% 
%     asgX = asgX ./ sum(asgX, 2);
%     asgX = asgX ./ sum(asgX);
%     x0 = asgX(:);

    
    nc1 = node_centrality(gphs{1, 1}.vis, 'closeness'); % node centrality of gph1
    nc2 = node_centrality(gphs{1, 2}.vis, 'closeness'); 
    nc1 = nc1(:);
    nc2 = nc2(:);
    nc = bsxfun(@times, nc1, nc2'); % integrating node centrality of gph1 and gph2
    nc = nc(:)/max(nc(:)); % nomalized vector form
    
    para.nc = nc;
    eps = 1e-4;

    for theta = -1:0.02:1
        para.theta = theta;
        f = ftheta(para);
        gradf = gradftheta(para);
        grad = gradf(x0);

        asgY = zeros(ns);

        for i = 1:300
            costVec = -1 * grad;
            costVec(costVec >= 0) = 0;
            costMat = reshape(costVec, n1, n2);
            ylap = lapjv(costMat);

            if n1 > n2
                asgY(sub2ind(ns, ylap, 1:n2)) = 1;
            else
                asgY(sub2ind(ns, 1:n1, ylap)) = 1;
            end

            y0 = asgY(:);
            y0(costVec == 0) = 0;

            alpha = ArmijoLineSearch_new(f, gradf, x0, y0 - x0);
            x1 = x0 + alpha * (y0 - x0);
            x0 = x1;

            if norm(gradf(x0)) < eps
                break;
            end
        end

        if theta >= 0 && all(x0 > 0.99)
            break;
        end
    end

    asgX = reshape(x0, n1, n2);
    asgX(asgX > 0.9) = 1;
    asgX(asgX <= 0.9) = 0;

    recall = matchAsg_recall(asgX, asgT);
    acc = matchAsg_acc(asgX, asgT);
    
    asg.alg = 'AgmNC';
    asg.recall = recall;
    asg.acc = acc;
    asg.X = asgX;
    asg.obj = f(x0);
    asg.tim = toc(ha);
end
% 
% function ftheta = ftheta(para)
% % define the obj function
%     if para.theta <=0 % input the current obj func
%         ftheta = @(x) (1+para.theta)*(x'*para.K*x - para.rho*x'*ones([para.n,1]) + para.beta*x'*para.nc) + para.theta*(x'*x - x'*ones([para.n,1]));
%     else
%         ftheta = @(x) (1-para.theta)*(x'*para.K*x - para.rho*x'*ones([para.n,1]) + para.beta*x'*para.nc) + para.theta*(x'*x - x'*ones([para.n,1]));
%     end
% end
% 
% function gradftheta = gradftheta(para)
% % define the gradient of obj function
%     if para.theta <=0 % input the current obj func
%         gradftheta = @(x) (1+para.theta)*((para.K+para.K')*x - para.rho*ones([para.n,1]) + para.beta*para.nc) + para.theta*(2*x-ones([para.n,1]));
%         %grad = (1+theta)*((K+K')*x0 - rho*ones([n1*n2,1])) + theta*(2*x0-ones([n1*n2,1])); 
%     else
%         gradftheta = @(x) (1-para.theta)*((para.K+para.K')*x - para.rho*ones([para.n,1]) + para.beta*para.nc) + para.theta*(2*x-ones([para.n,1]));
%         %grad = (1-theta)*((K+K')*x0 - rho*ones([n1*n2,1])) + theta*(2*x0-ones([n1*n2,1]));
%     end
% end

function ftheta = ftheta(para)
    % define objective function
    if para.theta <= 0
        ftheta = @(x) (1 + para.theta) * common_part(x) + para.theta * (x' * x - x' * ones(para.n, 1));
    else
        ftheta = @(x) (1 - para.theta) * common_part(x) + para.theta * (x' * x - x' * ones(para.n, 1));
    end

    % Anonymous function
    function val = common_part(x)
        val = x' * para.K * x - para.rho * x' * ones(para.n, 1) + para.beta * x' * para.nc;
    end
end

function gradftheta = gradftheta(para)
    % gradient of objective funtion
    if para.theta <= 0
        gradftheta = @(x) (1 + para.theta) * common_part(x) + para.theta * (2 * x - ones(para.n, 1));
    else
        gradftheta = @(x) (1 - para.theta) * common_part(x) + para.theta * (2 * x - ones(para.n, 1));
    end

    % Anonymous function
    function val = common_part(x)
        val = (para.K + para.K') * x - para.rho * ones(para.n, 1) + para.beta * para.nc;
    end
end