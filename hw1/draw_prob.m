function draw_prob()
    x = -100:0.5:100;
    joint_1 = 0.6 * normcdf(x, 9, 16);
    joint_2 = 0.4 * normcdf(x, 3, 25);
    plot(x, joint_1);
    hold on;
    plot(x, joint_2, ':');
    legend('p(x|y=1)p(y=1)', 'p(x|y=-1)p(y=-1)');
end
