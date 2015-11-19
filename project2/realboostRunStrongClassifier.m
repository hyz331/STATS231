function val = realboostRunStrongClassifier(weaks, f)
	% Test string classifier
	val = 0;
	for i = 1 : length(weaks)
		val = val + realboostRunH(weaks{i}, f);
	end
end
