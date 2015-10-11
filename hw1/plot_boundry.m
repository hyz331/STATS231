function [c1 c2 c3] = plot_boundry()
	c1 = [];
	c2 = [];
	c3 = [];
	for i = 0:18
		for j = 0:18
			p = classify(i, j);
			if (p == 1)
				c1 = [c1; [i j]];
			elseif (p == 2)
				c2 = [c2; [i j]];
			else
				c3 = [c3; [i j]];
			end
	end
%	hold off;
%	scatter(c1(:,1), c2(:, 2), 'r');
%	hold on;
%	scatter(c2(:,1), c2(:, 2), 'g');
%	scatter(c3(:,1), c3(:, 2), 'b');
end
