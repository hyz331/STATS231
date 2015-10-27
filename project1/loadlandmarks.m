function [train test] = loadlandmarks(num_train, face_dir)
	%%%%%%%%%%%%%%% Loading Image and Landmarks %%%%%%%%%%%%%%%%%%%%%%%%%%
	%
	% Load into Faces, Faces_test, Faces_nolk, Faces_test_nolk
	%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Load images into matrix
    filetype = '*.txt';
    imgType = filetype; % change based on image type
    images  = dir([face_dir imgType]);
    num_images = length(images);
    for i = 1:num_images;
        Seq{i} = dlmread([face_dir images(i).name]);
    end
    img_size = size(Seq{1});
    img_h = img_size(1);
    img_w = img_size(2);
    train = zeros(num_train, img_h * img_w);
    test = zeros(num_images - num_train, img_h * img_w);
    for i = 1:num_train
        train(i, :) = reshape(Seq{i}, [1, img_h * img_w]);
    end
    num_test = num_images - num_train;
    for i = num_train+1:num_images
        test(i-num_train, :) = reshape(Seq{i}, [1, img_h * img_w]);
    end
end
