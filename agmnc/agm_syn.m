function asg = agm_syn(K, Ct, asgT, pars)
    % for synthetic data, the predefined parameter are
    ha = tic;
    [n1, n2] = size(Ct);
    ns = [n1, n2];
    
    % function parameter
%     rho = ps(pars, 'rho', 0);
    sum_K = sum(K(:)); % 

    % 
    rho = 1.2 * n1 * (sum_K / ((n1 * n2)^2));
    
%     prIn('Agm', 'rho %4.2f', rho);
    
    para = struct();
    para.K = K;
    para.rho = rho;
    para.n = n1 * n2;

    % Initialization
%     asgX = zeros(ns);
    asgX = ones(ns);
%     asgX = bsxfun(@rdivide, asgX, sum(asgX, 2));
%     asgX = bsxfun(@rdivide, asgX, sum(asgX, 1));%
    x0 = asgX(:)/max(n1, n2);
%     x0 = asgX(:);

    
%     asgX = rand(ns);
%     asgX = asgX ./ sum(asgX, 2);
%     asgX = asgX ./ sum(asgX);
%     x0 = asgX(:);

    eps = 1e-4;

    for theta = -1:0.05:1
        para.theta = theta;
        f = ftheta(para);
        gradf = gradftheta(para);
        grad = gradf(x0);

        asgY = zeros(ns);

        for i = 1:200
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

            alpha = ArmijoLineSearch_syn(f, gradf, x0, y0 - x0);
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
    
    asg.alg = 'Agm';
    asg.recall = recall;
    asg.acc = acc;
    asg.X = asgX;
    asg.obj = f(x0);
    asg.tim = toc(ha);
end

function ftheta = ftheta(para)
    if para.theta <= 0
        ftheta = @(x) (1 + para.theta) * (x' * para.K * x - para.rho * x' * ones(para.n, 1)) + para.theta * (x' * x - x' * ones(para.n, 1));
    else
        ftheta = @(x) (1 - para.theta) * (x' * para.K * x - para.rho * x' * ones(para.n, 1)) + para.theta * (x' * x - x' * ones(para.n, 1));
    end
end

function gradftheta = gradftheta(para)
    if para.theta <= 0
        gradftheta = @(x) (1 + para.theta) * ((para.K + para.K') * x - para.rho * ones(para.n, 1)) + para.theta * (2 * x - ones(para.n, 1));
    else
        gradftheta = @(x) (1 - para.theta) * ((para.K + para.K') * x - para.rho * ones(para.n, 1)) + para.theta * (2 * x - ones(para.n, 1));
    end
end

