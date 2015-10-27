% Run knn for a single instance
function predict = knn_classify(train_data, train_label, features, k)
	% compute all distances
	features = repmat(features, length(train_data), 1);
	diffs = train_data - features;
	distances = sqrt(sum((diffs).^2, 2));

	% append indices and sort by distances
	distances = [(1:length(train_data))' distances];
	distances = sortrows(distances, 2);

	% convert label from binary vector to integer in order to find mode
	knn = train_label(distances(1:k), :);

	if (k == 1)
		predict = knn;
	else
		predict = mode(knn);
	end
end
