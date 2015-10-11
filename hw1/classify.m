function [label] = classify(x, y)
	j1 = mvncdf([x y], [2 12], 9*eye(2)) * 0.3;
	j2 = mvncdf([x y], [12 3], 9*eye(2)) * 0.3;
	j3 = mvncdf([x y], [7 5], 9*eye(2)) * 0.4;
	total = j1 + j2 + j3;
	lambda = [0 3 2; 2 0 1; 3 1 0];
	g1 = (lambda(1, 1)*j1 + lambda(2, 1)*j1 + lambda(3,1)*j1) / total;
	g2 = (lambda(1, 2)*j2 + lambda(2, 2)*j2 + lambda(3,2)*j2) / total;
	g3 = (lambda(1, 3)*j3 + lambda(2, 3)*j3 + lambda(3,3)*j3) / total;

	g = [g1 g2 g3];
	[gm label] = max(g);
end
