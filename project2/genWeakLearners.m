function weaks = genWeakLearners()
	num = 0;
	for i = 1:1:14
		for j = 1:1:14
			for ori = 1:6
				num = num + 1;
				weaks{num} = buildWeakClassifier([i, j], [i+1, j+1], ori);
			end
		end
    end
    for i = 1:1:13
		for j = 1:1:4
			for ori = 1:6
				num = num + 1;
				weaks{num} = buildWeakClassifier([i, j], [i+3, j+9], ori);
			end
		end
    end
    for i = 1:1:4
		for j = 1:1:13
			for ori = 1:6
				num = num + 1;
				weaks{num} = buildWeakClassifier([i, j], [i+9, j+3], ori);
			end
		end
	end
	for i = 1:1:13
		for j = 1:1:13
			for ori = 5:6
				num = num + 1;
				weaks{num} = buildWeakClassifier([i, j], [i+2, j+2], ori);
			end
		end
	end
	for i = 1:2:14
		for j = 1:2:14
			for ori = 7:8
				num = num + 1;
				weaks{num} = buildWeakClassifier([i, j], [i+3, j+3], ori);
			end
		end
	end
end
