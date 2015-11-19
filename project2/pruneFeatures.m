function weaks = pruneFeatures(faces, nonfaces)
    weaksRaw = genWeakLearners();
    numUnpruned = length(weaksRaw)
	% Initialize data weights
	total = length(faces) + length(nonfaces);
	D_faces = ones(1, length(faces));
	D_nonfaces = ones(1, length(nonfaces));
	D_faces = D_faces * (length(D_nonfaces) / length(D_faces));
	totalWeight = sum(D_faces) + sum(D_nonfaces);

	D_faces = D_faces ./ totalWeight;
	D_nonfaces = D_nonfaces ./ totalWeight;

	% Prune features
	numWeak = 1;
	for i = 1:length(weaksRaw)
		[h err] = trainSingleClassifier(weaksRaw{i}, faces, nonfaces, D_faces, D_nonfaces);
		if (err < 0.45)
			weaks{numWeak} = weaksRaw{i};
			numWeak = numWeak + 1;
        end
        i
    end
    numWeak
end