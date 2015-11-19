function H = buildStrongClassifier(weaks, alpha)
	% Pack trained classifier objects into a single function
	for i = 1:length(weaks)
		weak = weaks{i};
		weaks{i} = @(f) -sign(single(weak.classifier(f)) - weak.thresh);
	end 
	H = @(f) strongClassifier(weaks, alpha, f);
end
