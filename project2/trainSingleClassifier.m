function [trained_h minErr] = trainSingleClassifier(h, faces, nonfaces, faceWeights, nonfaceWeights)
	for i = 1:length(faces)
		faceVals(i) = single(h(faces{i}));
	end
	for i = 1:length(nonfaces)
		nonfaceVals(i) = single(h(nonfaces{i}));
	end
	vals = [faceVals nonfaceVals];

	minVals = single(min(vals));
	maxVals = single(max(vals));


	% For each 'cut' on the x-axis, we remember how many nonfaces to its left (misclassify),
	% and how many faces to its right (misclassify). That we have the total error

	minErr = 100;
	best_w = 0.0;

	if (minVals == maxVals)
		mis_faces = (faceVals > minVals) * faceWeights';
		mis_nonfaces = (nonfaceVals <= minVals) * nonfaceWeights';
		minErr = (mis_faces + mis_nonfaces);
		trained_h = struct('classifier', h, 'thresh', minVals);
		return;
	end

	for w = single(minVals-0.001) : single(maxVals-minVals)/100.0: single(maxVals+0.001)
		mis_faces = (faceVals > w) * faceWeights';
		mis_nonfaces = (nonfaceVals <= w) * nonfaceWeights';
		err = (mis_faces + mis_nonfaces); % / (length(faces) + length(nonfaces));
		if (err < minErr)
			minErr = err;
			best_w = w;
		end
	end
	
	trained_h = struct('classifier', h, 'thresh', best_w);
end
