function computeTraits()
	load 'data.mat';
	load 'trained_models.mat';
	num_gov = size(Features_governor, 1);
	num_sen = size(Features_senator, 1);
	num_trait = size(Labels, 2);

	traits_gov = zeros(num_gov, num_trait);
	traits_sen = zeros(num_sen, num_trait);

	tmp = zeros(num_gov, 1);	
	for i = 1:num_trait
		traits_gov(:, i) = svmpredict(tmp, Features_governor, m{i}); 
	end

	tmp = zeros(num_sen, 1);	
	for i = 1:num_trait
		traits_sen(:, i) = svmpredict(tmp, Features_senator, m{i}); 
	end

	save 'traits.mat' 'traits_gov' 'traits_sen';
end
