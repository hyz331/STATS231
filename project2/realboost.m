function [H trainedWeaks alpha] = realboost(faces, nonfaces, weaks)
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
	for iter = 1 : 50
		% Find the best h
        %classifiers = struct(1, length(weaks));
		errors = zeros(1, length(weaks));
        for idx = 1 : length(weaks)
			[h err] = realboostTrainSingle(weaks{idx}, faces, nonfaces, D_faces, D_nonfaces);
            classifiers{idx} = h;
            errors(idx) = err;
        end
        [minErr, best] = min(errors);
        best_h = classifiers{best};
        
		% Move and store the best h
		trainedWeaks{iter} = best_h;
		weaks = {weaks{1:best-1} weaks{best+1:length(weaks)}};

		% Update D

		ht = @(f) realboostRunH(best_h, f);
		facesExp = exp(-1 * cellfun(ht, faces));
		nonfacesExp = exp(1 * cellfun(ht, nonfaces));

		D_faces = D_faces .* facesExp;
		D_nonfaces = D_nonfaces .* nonfacesExp;
		D_sum = sum(D_faces) + sum(D_nonfaces);
		D_faces = D_faces ./ D_sum;
		D_nonfaces = D_nonfaces ./ D_sum;

		% Test string classifier
		facesRes = zeros(1, length(faces));
		nonfacesRes = zeros(1, length(faces));
		for i = 1 : length(faces)
			facesRes(i) = realboostRunStrongClassifier(trainedWeaks, faces{i});
		end
		for i = 1 : length(nonfaces)
			nonfacesRes(i) = realboostRunStrongClassifier(trainedWeaks, nonfaces{i});
        end
        corr = sum(facesRes >= 0) + sum(nonfacesRes < 0);
        corr = corr / (length(facesRes) + length(nonfacesRes));
        [iter corr]
	end

	% Build strong classifier
	H = @(f) realboostRunStrongClassifier(trainedWeaks, f);
end
