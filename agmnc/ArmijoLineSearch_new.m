function alpha = ArmijoLineSearch_new(f, gradf, x0, d)
    c = 0.5;
    rho = 0.4;
    alpha = 1;
    max_iter = 500;

    f0 = f(x0);
    grad0 = gradf(x0);
    slope = grad0' * d;

    for iter = 1:max_iter
        x1 = x0 + alpha * d;
        if f(x1) >= f0 + c * alpha * slope
            break;
        else
            alpha = rho * alpha;
        end
    end
end