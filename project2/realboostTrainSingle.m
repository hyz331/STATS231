function [h Z] = realboostTrainSingle(h, faces, nonfaces, D_faces, D_nonfaces)
	num_bins = 50;

	faceVals = zeros(1, length(faces));
	nonfaceVals = zeros(1, length(nonfaces));

	% Use 100 bins to approximate h
	for i = 1:length(faces)
		faceVals(i) = single(h(faces{i}));
	end
	for i = 1:length(nonfaces)
		nonfaceVals(i) = single(h(nonfaces{i}));
	end
	vals = [faceVals nonfaceVals];

	minVal = single(min(vals)) - 0.001;
	maxVal = single(max(vals)) + 0.001;;
	step = (maxVal - minVal) / num_bins;

	p = zeros(1, num_bins);
	q = zeros(1, num_bins);
	b = 1;
	for leftEdge = minVal : step : maxVal-step
		rightEdge = leftEdge + step;

		indices = (faceVals > leftEdge & faceVals <= rightEdge);
		p(b) = single(indices) * D_faces';

		indices = (nonfaceVals > leftEdge & nonfaceVals <= rightEdge);
		q(b) = single(indices) * D_nonfaces';
		b = b + 1;
	end

	% Fix zeros
	p = p + 0.001 * (p == 0);
	q = q + 0.001 * (q == 0);

	% Compute Z
	Z = 2 * sum(sqrt(p.*q));
	
	% Construct ht
	h = struct('classifier', h, 'bins', 0.5 * log(p ./ q), 'range', minVal:step:(maxVal-step));
end
