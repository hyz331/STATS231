function [error error_landmark error_face] = eigen_recons(num_train)
	%%%%%%%%%%%%%%% Loading Image and Landmarks %%%%%%%%%%%%%%%%%%%%%%%%%%
	%
	% Load into Faces, Faces_test, Faces_nolk, Faces_test_nolk
	%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	face_dir = 'face_data/landmark_87/';
    % Load images into matrix
    imgType = '*.dat'; % change based on image type
    images  = dir([face_dir imgType]);
    num_images = length(images);
    for i = 1:num_images;
        Seq{i} = dlmread([face_dir images(i).name]);
        Seq{i}(1, :) = [];
    end
    
    % Flatten image vectors and load them into matrices
    img_size = size(Seq{1});
    img_h = img_size(1);
    img_w = img_size(2);
    Faces = zeros(num_train, img_h * img_w);
    Faces_test = zeros(num_images - num_train, img_h * img_w);
    for i = 1:num_train
        Faces(i, :) = reshape(Seq{i}, [1, img_h * img_w]);
    end
    num_test = num_images - num_train;
    for i = num_train+1:num_images
        Faces_test(i-num_train, :) = reshape(Seq{i}, [1, img_h * img_w]);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    face_dir_nolk = 'face_data/face/';
    % Load images into matrix
    imgType_nolk = '*.bmp'; % change based on image type
    images_nolk  = dir([face_dir_nolk imgType_nolk]);
    for i = 1:num_images;
        Seq_nolk{i} = imread([face_dir_nolk images_nolk(i).name]);
    end
    % Flatten image vectors and load them into matrices
    Faces_nolk = zeros(num_train, 256 * 256);
    Faces_test_nolk = zeros(num_images - num_train, 256 * 256);
    for i = 1:num_train
        Faces_nolk(i, :) = reshape(Seq_nolk{i}, [1, 256 * 256]);
    end
    num_test = num_images - num_train;
    for i = num_train+1:num_images
        Faces_test_nolk(i-num_train, :) = reshape(Seq_nolk{i}, [1, 256 * 256]);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%
	% Compute eigenbase U for Faces, U_nolk for Faces_nolk
	% mean_F for Faces, mean_F_nolk for Faces_nolk
	%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mean_F = mean(Faces);
    % Compute PCA
    X = Faces - repmat(mean_F, [num_train, 1]);
    [U D] = eig(X'*X);
    % Sort eigen values
    [D, I] = sort(diag(D), 'descend');
    D = diag(D);
    U = U(I, :);

    mean_F_nolk = mean(Faces_nolk);
    % Compute PCA
    X = Faces_nolk - repmat(mean_F_nolk, [num_train, 1]);
    [V D] = eig(X*X');
    % Sort eigen values
    [D, I] = sort(diag(D), 'descend');
    D = diag(D);
    V = V(:, I);
    U_nolk = X'* V;
    % normalize
    for i = 1:size(U_nolk, 2)
        U_nolk(:, i) = U_nolk(:, i) ./ norm(U_nolk(:, i));
    end
    
    size(U_nolk)
    face = Faces_nolk(1,:);
    res = U_nolk(:, 1:150) * (U_nolk(:, 1:150)' * (face-mean_F_nolk)') + mean_F_nolk';
    norm(res - face')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%
	% 20 eigen vaces
	%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    for i = 1:20
        subplot(5,4,i);
        k = abs(U_nolk(:, i));
        imshow(reshape(k, [256, 256]), []);
        title(strcat('k=', num2str(i)));
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%
	% Reconstruct
	%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    error = [];
    error_landmark = [];
    error_face = [];
    for k = 1:150:150
        t_error = 0;
        t_error_landmark = 0;
        t_error_face = 0;
        for i = 1:num_test
            face = reshape(Faces_test_nolk(i, :), [256, 256]);
            face_landmark = Faces_test(i, :);
            % Reconstruct appearance
            face_aligned = warpImage_kent(face, double(reshape(face_landmark, [img_h, img_w])), double(reshape(mean_F, [img_h, img_w])));
            face_aligned = reshape(double(face_aligned), [1, 256*256]);
            face_proj = U_nolk(:, 1:k) * (U_nolk(:, 1:k)' * (face_aligned-mean_F_nolk)') + mean_F_nolk';

            % Reconstruct landmark
            landmark_proj = U(:, 1:k) * (U(:, 1:k)' * (face_landmark-mean_F)') + mean_F';

            % Warp
            warp_face = warpImage_kent(reshape(face_proj, [256, 256]), reshape(mean_F, [img_h, img_w]), reshape(landmark_proj, [img_h, img_w]));
            %imshow(reshape(uint8(warp_face), [256, 256]), []);

            t_error = t_error + norm(reshape(double(warp_face), [1, 256^2]) - reshape(double(face), [1, 256^2]))^2 / (256*256);
            t_error_landmark = t_error_landmark + norm(face_landmark - landmark_proj')^2 / 87;
            t_error_face = t_error_face + norm(reshape(face, [1, 256^2])' - U_nolk(:, 1:k) * (U_nolk(:, 1:k)' * (reshape(face, [1, 256^2])-mean_F_nolk)') - mean_F_nolk')^2 / 256^2;
        end
        error = [error; t_error / num_test];
        error_landmark = [error_landmark; t_error_landmark / num_test];
        error_face = [error_face; t_error_face / num_test];
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%
	% Randomly sample 20 faces
	%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure
    for i = 1:20
        subplot(4,5,i);
        face_rand = zeros(1, 10);
        landmark_rand = zeros(1, 10);
        for j = 1:10
            face_rand(j) = normrnd(0, 1600);
            landmark_rand(j) = normrnd(0, 7);
        end
        face_proj = U_nolk(:, 1:10) * face_rand' + mean_F_nolk';
        landmark_proj = U(:, 1:10) * landmark_rand' + mean_F';
        warp_face = warpImage_kent(reshape(face_proj, [256, 256]), reshape(mean_F, [img_h, img_w]), reshape(landmark_proj, [img_h, img_w]));
        imshow(warp_face);
    end
end
