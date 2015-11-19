function corr = testStrongClassifier(H, faces, nonfaces, draw)
	
	facesRes = zeros(1, length(faces));
	nonfacesRes = zeros(1, length(nonfaces));
	for i = 1:length(faces)
		facesRes(i) = int32(H(faces{i}) >= 0);   
	end
	for i = 1:length(nonfaces)
		nonfacesRes(i) = int32(H(nonfaces{i}) < 0);
	end
	
	corr = sum(facesRes) + sum(nonfacesRes);
	corr = corr / (length(faces) + length(nonfaces));

	if (draw == true)
		facesRes = cellfun(@(f) H(f), faces);
		nonfacesRes = cellfun(@(f) H(f), nonfaces);
		hold on;
		histogram(nonfacesRes, 'FaceColor', 'r');
		histogram(facesRes, 'FaceColor', 'g');
		hold off;
	end
end
