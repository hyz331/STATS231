function getTraits()
	load 'data.mat';
	load 'trained_models.mat';
	num_traits = size(Labels, 2);
	num_governor = size(Features_governor, 1);
	num_senator = size(Features_senator, 1);

	% Predict traits for governor
	traits_governor = zeros(num_governor, num_traits);
	tmp = zeros(num_governor, 1);
	for i = 1:num_traits
		traits_governor(:, i) = svmpredict(tmp, Features_governor, m{i});
	end

	% Predict traits for senator 
	traits_senator = zeros(num_senator, num_traits);
	tmp = zeros(num_senator, 1);
	for i = 1:num_traits
		traits_senator(:, i) = svmpredict(tmp, Features_senator, m{i});
	end

	save 'traits.mat' 'traits_governor' 'traits_senator';
end
