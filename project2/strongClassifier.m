function val = strongClassifier(weaks, alpha, f)
	alpha = single(cell2mat(alpha));
	vals = zeros(1, length(weaks));
	for i = 1 : length(weaks)
		vals(i) = single(weaks{i}(f));
	end
	val = sum(alpha .* vals);
end
