function [H trainedWeaks alpha] = adaboost(faces, nonfaces, weaks)
	% Initialize data weights
	total = length(faces) + length(nonfaces);
	D_faces = ones(1, length(faces));
	D_nonfaces = ones(1, length(nonfaces));
	D_faces = D_faces * (length(D_nonfaces) / length(D_faces));
	totalWeight = sum(D_faces) + sum(D_nonfaces);

	D_faces = D_faces ./ totalWeight;
	D_nonfaces = D_nonfaces ./ totalWeight;
	
	numPlot = 1;
	best_h = weaks{1};

	% Choose top 5 classifiers
	for iter = 1 : 105

		% Find the best h
        %classifiers = struct(1, length(weaks));
		errors = zeros(1, length(weaks));
        parfor idx = 1 : length(weaks)
			[h, err] = trainSingleClassifier(weaks{idx}, faces, nonfaces, D_faces, D_nonfaces);
            classifiers{idx} = h;
            errors(idx) = err;
        end
        [minErr, best] = min(errors);
        best_h = classifiers{best};
        
		% Move and store the best h
		trainedWeaks{iter} = best_h;
		weaks = {weaks{1:best-1} weaks{best+1:length(weaks)}};

		% Comupute alpha and update D
		alpha{iter} = single(0.5 * log((1-minErr) / minErr));

		ht = @(f) -sign(single(best_h.classifier(f)) - best_h.thresh);
		facesExp = exp(-1 * alpha{iter} * cellfun(ht, faces));
		nonfacesExp = exp(1 * alpha{iter} * cellfun(ht, nonfaces));

		D_faces = D_faces .* facesExp;
		D_nonfaces = D_nonfaces .* nonfacesExp;
		D_sum = sum(D_faces) + sum(D_nonfaces);
		D_faces = D_faces ./ D_sum;
		D_nonfaces = D_nonfaces ./ D_sum;

		% Test current classifierhc 
		[~, t_err] = trainSingleClassifier(best_h.classifier, faces, nonfaces, ones(1, length(faces)) ./ total, ones(1, length(nonfaces)) ./ total);

		% Test strong classifier
		H = buildStrongClassifier(trainedWeaks, alpha);
		if (iter == 10 || iter == 50 || iter == 100)
			subplot(3, 2, numPlot);
			numPlot = numPlot + 1;
			corr = testStrongClassifier(H, faces, nonfaces, true);
			subplot(3, 2, numPlot);
			numPlot = numPlot + 1;
			plot(sort(errors));
		else
			corr = testStrongClassifier(H, faces, nonfaces, false);
		end

		disp([iter minErr t_err corr]);

		% Plot error curves
		%errors = sort(errors); 
		%subplot(1, 5, iter);
		%plot(errors)
	end

end
