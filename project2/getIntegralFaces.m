function inte_faces = getIntegralFaces(faces)
	for i = 1:length(faces)
		inte_faces{i} = integralImage(faces{i});
	end	
end 
