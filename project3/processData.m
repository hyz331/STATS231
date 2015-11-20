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
		HoG(i, :) = reshape(HoGfeatures(double(faces{i})), [1 61*61*32]);
	end
	face_landmar = (face_landmark) - 50 / 400;
	Features = [HoG face_landmark];
	Labels = trait_annotation;

	% load governor 
	load 'stat-gov.mat';
    images  = dir(['img-elec/governor/' '*.jpg']);
    num_faces = length(images);
    for i = 1:num_faces
        img = imread(['img-elec/governor/' images(i).name]);
        faces{i} = img;
    end
	% combine features
	HoG = zeros(num_faces, 61*61*32);
	for i = 1:num_faces
		HoG(i, :) = reshape(HoGfeatures(double(faces{i})), [1 61*61*32]);
	end
	face_landmar = (face_landmark) - 50 / 400;
	Features_governor = [HoG face_landmark];

	% load senator 
	load 'stat-sen.mat';
    images  = dir(['img-elec/senator/' '*.jpg']);
    num_faces = length(images);
    for i = 1:num_faces
        img = imread(['img-elec/senator/' images(i).name]);
        faces{i} = img;
    end
	% combine features
	HoG = zeros(num_faces, 61*61*32);
	for i = 1:num_faces
		HoG(i, :) = reshape(HoGfeatures(double(faces{i})), [1 61*61*32]);
	end
	face_landmar = (face_landmark) - 50 / 400;
	Features_senator = [HoG face_landmark];

	save '-binary' 'data.mat' 'Features' 'Labels' 'Features_governor' 'Features_senator';
end
