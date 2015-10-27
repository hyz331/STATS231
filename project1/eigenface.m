function [meanface error] = eigenface(face_dir, num_train)
    % Load images into matrix
    imgType = '*.bmp'; % change based on image type
    images  = dir([face_dir imgType]);
    num_images = length(images);
    for i = 1:num_images;
        Seq{i} = imread([face_dir images(i).name]);
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
    meanface = uint8(reshape(mean_F, [img_h, img_w]));
    %imshow(meanface);
    
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
    
    % Draw first 20 eigen faces
    for i = 1:20
        subplot(5,4,i);
        k = abs(U(:, i));
        imshow(reshape(k, [img_w, img_h]), []);
        title(strcat('k=', num2str(i)));
    end

    % Reconstruct
    error = 0;
    for i = 1:num_test
        x = Faces_test(i, :) - mean_F;
        x = U(:, 1:20) * (U(:, 1:20)' * x');
        x = x + mean_F';
        eigenface = uint8(reshape(x, [img_h, img_w]));
        error = error + (norm(x' - Faces_test(i, :))^2) / (img_h * img_w);
    end
    error = error / num_test;
end
