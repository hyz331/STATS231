function h = buildWeakClassifier(ul, lr, ori)
	h = @(f) weakClassifier(f, ul, lr, ori);
end
