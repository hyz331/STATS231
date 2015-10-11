function plot_roc()
    true_positive_rate = [];
    false_positive_rate = [];
    false_negative_rate = [];
    precision = [];
    recall = [];
    for T = 20:-1:-10
        tp = 1-normcdf(T, 4, 16);
        fp = 1-normcdf(T, 3, 25);
        fn = normcdf(T, 4, 16);
        
        true_positive_rate = [true_positive_rate; tp];
        false_positive_rate = [false_positive_rate; fp];
        precision = [tp / (tp + fp); precision];
        recall = [tp / (tp + fn); recall];
    end
    
%    plot(false_positive_rate, true_positive_rate, '^');
%    hold on;
%    xlabel('false positive rate');
%    ylabel('true postive rate');
%    hold off;
    
    plot(recall, precision, '^');
    hold on;
    xlabel('recall');
    ylabel('precision');
end
