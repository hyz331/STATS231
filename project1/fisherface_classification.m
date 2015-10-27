function [error] = fisherface_classification()
    % Load data
    [male_train male_test] = loadfaces(78, 'face_data/male_face/');
    [male_train_lk male_test_lk] = loadlandmarks(78, 'face_data/male_landmark_87/');
    [female_train female_test] = loadfaces(75, 'face_data/female_face/');
    [female_train_lk female_test_lk] = loadlandmarks(75, 'face_data/female_landmark_87/');
    num_train_male = size(male_train, 1);
    num_train_female = size(female_train, 1);
    num_test_male = size(female_test, 1);
    num_test_female = size(female_test, 1);
    
    % Align original images
    mean_lk_male = reshape(mean(male_train_lk), [87, 2]);
    mean_lk_female = reshape(mean(female_train_lk), [87, 2]);
    for i = 1:num_train_male
        male_train(i, :) = reshape(warpImage_kent(reshape(male_train(i, :), [255, 256]), reshape(male_train_lk(i, :), [87, 2]), mean_lk_male), [1, 255*256]);
    end
    for i = 1:num_train_female
        female_train(i, :) = reshape(warpImage_kent(reshape(female_train(i, :), [255, 256]), reshape(female_train_lk(i, :), [87, 2]), mean_lk_female), [1, 255*256]);
    end
    for i = 1:num_test_male
        male_test(i, :) = reshape(warpImage_kent(reshape(male_test(i, :), [255, 256]), reshape(male_test_lk(i, :), [87, 2]), mean_lk_male), [1, 255*256]);
    end
    for i = 1:num_test_female
        female_test(i, :) = reshape(warpImage_kent(reshape(female_test(i, :), [255, 256]), reshape(female_test_lk(i, :), [87, 2]), mean_lk_female), [1, 255*256]);
    end
    
    % Compute fisher face
    C = [male_train' female_train'];
    B = C'*C;
    [V D] = eig(B);
    for i = 1:(size(male_train, 1) + size(female_train, 1))
       A(:, i) = C * V(:, i); 
       A(:, i) = A(:, i) .* sqrt(D(i, i)) ./ norm(A(:, i));
    end
    y = A' * (mean(male_train) - mean(female_train))';
    z = pinv(D*D*V') * y;
    W = C*z;
    
    % Project training sets
    face_proj_male = W' * male_train';
    face_proj_female = W' * female_train';
    
    % Run KNN to classifiy testing data
    train_faces = [face_proj_male'; face_proj_female'];
    train_labels = [zeros(num_train_male, 1); ones(num_train_female, 1)];
    num_correct = 0;
    for i = 1:num_test_male
        if (knn_classify(train_faces, train_labels, W'*male_test(i, :)', 4) == 0)
            num_correct = num_correct + 1;
        end
    end
    for i = 1:num_test_female
        if (knn_classify(train_faces, train_labels, W'*female_test(i, :)', 4) == 1)
            num_correct = num_correct + 1;
        end
    end
    error = num_correct / (num_test_male + num_test_female);
end
