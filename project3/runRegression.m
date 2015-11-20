function runRegression()
	load 'data.mat';
	num_class = size(Labels, 2);
	m = cell(1, num_class);
	% Train models
	for i = 1:num_class
		m{i} = svmtrain(Labels(:, i), Features, '-s 3');
	end

	save '-binary' 'trained_models.mat' 'm';
end
