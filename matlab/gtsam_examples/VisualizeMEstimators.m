import gtsam.*

clear all;
close all;

x = linspace(-10, 10, 1000);
% x = linspace(-10, 10, 21)

[rho, psi, w] = fair(x);
plot_rho(x, rho, 1, -1, 30)
title('Fair');
plot_psi(x, psi, 7, -3, 3);
plot_w(x, w, 13, 3);

[rho, psi, w] = huber(x);
plot_rho(x, rho, 2, -1, 30);
title('Huber');
plot_psi(x, psi, 8, -15, 15);
plot_w(x, w, 14, 5);

[rho, psi, w] = cauchy(x);
plot_rho(x, rho, 3, -0.1, 0.1);
title('Cauchy');
plot_psi(x, psi, 9, -0.2, 0.2);
plot_w(x, w, 15, 1.5);

[rho, psi, w] = gemancclure(x);
plot_rho(x, rho, 4, -1, 1);
title('Geman-McClure');
plot_psi(x, psi, 10, -1, 1);
plot_w(x, w, 16, 1.5);

[rho, psi, w] = welsch(x);
plot_rho(x, rho, 5, -5, 10);
title('Welsch');
plot_psi(x, psi, 11, -2, 2);
plot_w(x, w, 17, 2);

[rho, psi, w] = tukey(x);
plot_rho(x, rho, 6, -5, 10);
title('Tukey');
plot_psi(x, psi, 12, -2, 2);
plot_w(x, w, 18, 2);

function plot_rho(x, y, idx, yll, ylu)
    subplot(3, 6, idx);
    plot(x, y);
    xlim([-15, 15]);
    ylim([yll, ylu]);
end

function plot_psi(x, y, idx, yll, ylu)
    subplot(3, 6, idx);
    plot(x, y);
    xlim([-15, 15]);
    ylim([yll, ylu]);
end

function plot_w(x, y, idx, yl)
    subplot(3, 6, idx);
    plot(x, y);
    xlim([-15, 15]);
    ylim([-yl, yl]);
end

function [rho, psi, w] = fair(x)
    import gtsam.*
    c = 1.3998;

    rho = c^2 * ( (abs(x) ./ c) - log(1 + (abs(x)./c)) );
    est = noiseModel.mEstimator.Fair(c);
    
    w = zeros(size(x));
    for i = 1:size(x, 2)
        w(i) = est.weight(x(i));
    end

    psi = w .* x;
end

function [rho, psi, w] = huber(x)
    import gtsam.*
    k = 5;
    t = (abs(x) > k);

    rho = (x .^ 2) ./ 2;
    rho(t) = k * (abs(x(t)) - (k/2));
    est = noiseModel.mEstimator.Huber(k);

    w = zeros(size(x));
    for i = 1:size(x, 2)
        w(i) = est.weight(x(i));
    end

    psi = w .* x;
end

function [rho, psi, w] = cauchy(x)
    import gtsam.*
    c = 0.1;
    
    rho = (c^2 / 2) .* log(1 + ((x./c) .^ 2));

    est = noiseModel.mEstimator.Cauchy(c);
    
    w = zeros(size(x));
    for i = 1:size(x, 2)
        w(i) = est.weight(x(i));
    end

    psi = w .* x;
end

function [rho, psi, w] = gemancclure(x)
    import gtsam.*
    c = 1.0;
    rho = ((x .^ 2) ./ 2) ./ (1 + x .^ 2);
    
    est = noiseModel.mEstimator.GemanMcClure(c);
    
    w = zeros(size(x));
    for i = 1:size(x, 2)
        w(i) = est.weight(x(i));
    end

    psi = w .* x;
end

function [rho, psi, w] = welsch(x)
    import gtsam.*
    c = 2.9846;
    rho = (c^2 / 2) * ( 1 - exp(-(x ./ c) .^2 ));
    
    est = noiseModel.mEstimator.Welsh(c);

    w = zeros(size(x));
    for i = 1:size(x, 2)
        w(i) = est.weight(x(i));
    end

    psi = w .* x;
end

function [rho, psi, w] = tukey(x)
    import gtsam.*
    c = 4.6851;
    t = (abs(x) > c);

    rho = (c^2 / 6) * (1 - (1 - (x ./ c) .^ 2 ) .^ 3 );
    rho(t) = c .^ 2 / 6;

    est = noiseModel.mEstimator.Tukey(c);

    w = zeros(size(x));
    for i = 1:size(x, 2)
        w(i) = est.weight(x(i));
    end

    psi = w .* x;
end
