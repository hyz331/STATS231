function predictOutcomes()
	load 'traits.mat';
	gov = load('stat-gov.mat');
	sen = load('stat-sen.mat');
	num_gov = size(gov.vote_diff, 1);
	num_sen = size(sen.vote_diff, 1);
	num_trait = 14;

	% Governor
	diffs = zeros(num_gov/2, num_trait);
	for i = 1:2:num_gov
		diffs((i+1)/2, :)  = traits_gov(i, :) - traits_gov(i+1, :);
	end
	
	num_diffs = size(diffs, 1);
	wins = diffs(1 : num_diffs/2, :);
	losts = -diffs(num_diffs/2+1 : num_diffs, :);
	labels = [ones(size(wins, 1), 1); zeros(size(losts, 1), 1)];
	
	svmtrain(labels, [wins; losts], '-v 5');

	% Senator 
	diffs = zeros(num_sen/2, num_trait);
	for i = 1:2:num_sen
		diffs((i+1)/2, :)  = traits_sen(i, :) - traits_sen(i+1, :);
	end
	
	num_diffs = size(diffs, 1);
	wins = diffs(1 : num_diffs/2, :);
	losts = -diffs(num_diffs/2+1 : num_diffs, :);
	labels = [ones(size(wins, 1), 1); zeros(size(losts, 1), 1)];
	
	svmtrain(labels, [wins; losts], '-v 5');

	% Find corrlations
	for i = 1:num_trait
		c = corr(labels, [wins(:, i); losts(:, i)])
	end
end
