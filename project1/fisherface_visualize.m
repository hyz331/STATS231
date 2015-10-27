function fisherface_fisualize()
    [male_train male_test] = loadfaces(78, 'face_data/male_face/');
    [male_train_lk male_test_lk] = loadlandmarks(78, 'face_data/male_landmark_87/');
    [female_train female_test] = loadfaces(75, 'face_data/female_face/');
    [female_train_lk female_test_lk] = loadlandmarks(75, 'face_data/female_landmark_87/');
    num_train_male = size(male_train, 1);
    num_train_female = size(female_train, 1);
    num_test_male = size(male_train_test, 1);
    num_test_female = size(female_train_test, 1);
    
    % Compute fisher face for geometry
    X1 = male_train_lk - repmat(mean(male_train_lk), [size(male_train_lk, 1), 1]);
    X2 = female_train_lk - repmat(mean(female_train_lk), [size(female_train_lk, 1), 1]);
    S1 = X1'*X1;
    S2 = X2'*X2;
    W_mk = pinv(S1+S2) * (mean(male_train_lk) - mean(female_train_lk))';
    % Project landmark for male and female
    landmark_proj_male = W_mk' * male_test_lk';
    landmark_proj_female = W_mk' * female_test_lk';
    
    % Compute fisher face for appearance
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
    % Porject faces of male and female
    face_proj_male = W' * male_test';
    face_proj_female = W' * female_test';
    
    % Visualization
    scatter(face_proj_male, landmark_proj_male);
    hold on;
    scatter(face_proj_female, landmark_proj_female, '*');
    legend('male', 'female');
    ylabel('geometry');
    xlabel('appearance');
end









