function processData()
	% load data
    images  = dir(['img/' '*.jpg']);
    num_faces = length(images);
    for i = 1:num_faces
        img = imread(['img/' images(i).name]);
        faces{i} = img;
    end
	load train-anno.mat;
	mex HoGfeatures.cc;

	% combine features
	HoG = zeros(num_faces, 61*61*32);
	for i = 1:num_faces
		HoG(i, :) = reshape(HoGfeatures(double(faces{1})), [1 61*61*32]);
	end
	
	Features = [HoG face_landmark];
	Labels = trait_annotation;

	save 'data.mat' 'Features' 'Labels';
end
