function [nonfaces] = loadnonfaces()
	%%%%%%%%%%%%%%% Loading Image and Landmarks %%%%%%%%%%%%%%%%%%%%%%%%%%
	%
	% Load into Faces, Faces_test, Faces_nolk, Faces_test_nolk
	%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Load images into matrix
	filetype = '*.bmp';
	face_dir = 'nonface16/';
	imgType = filetype; % change based on image type
	images  = dir([face_dir imgType]);
	num_images = length(images);
	for i = 1:num_images
		img = imread([face_dir images(i).name]);
		if (size(img, 3) == 3)
			nonfaces{i} = rgb2gray(img);
		else
			nonfaces{i} = img;
		end
	end

	save 'nonfaces.dat' 'nonfaces' -mat7-binary;
end
