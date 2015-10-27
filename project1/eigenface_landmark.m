function [error] = eigenface(num_train)
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

    % Compute average face
    mean_F = mean(Faces);
    
    % Compute PCA
    X = Faces - repmat(mean_F, [num_train, 1]);
    [V D] = eig(X*X');
    % Sort eigen values
    [D, I] = sort(diag(D), 'descend');
    D = diag(D);
    V = V(I, :);
    U = X'* V;
    % normalize
    for i = 1:size(U, 2)
        U(:, i) = U(:, i) ./ norm(U(:, i));
    end
    
    % Draw first 5 eigen faces
    for i = 1:5
        subplot(2,3,i);
        k = abs(U(:, i)) + mean_F';
        k = (reshape(k, [img_h, img_w]));
        scatter(k(:,1), -k(:,2));
        title(strcat('k=', num2str(i)));
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
    
    % Reconstruct
    error = 0;
    for i = 1:num_test
        face = reshape(Faces_test_nolk(i, :), [256, 256]);
        o = Faces_test(i, :);
        x = Faces_test(i, :) - mean_F;
        x = U(:, 1:5) * (U(:, 1:5)' * x');
        x = x + mean_F';
        recons = warpImage_kent(face, double(reshape(o, [img_h, img_w])), double(reshape(x, [img_h, img_w])));
        error = error + norm(double(recons) - double(face))^2 / (256 * 256);
        %imshow(uint8(reshape(recons, [256, 256])), []);
    end
    error = error / num_test;
end