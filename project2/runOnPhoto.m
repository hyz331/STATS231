function runOnPhoto(H)
	photo = rgb2gray(imread('photo.jpg'));
	photo = imresize(photo, size(photo)/8); 
	[height width] = size(photo);
	close all;
	hold on;
	imshow(photo);

	% Sample box
	% i = 140;
	% j = 100;
	% offset = 80;
	% rectangle('Position', [j i offset offset], 'EdgeColor', 'r');
	% figure
	% imshow(photo(140:140+80, 100:100+130));

    offset = 32;
	for i = 1:16:height-offset
		for j = 1:6:width-offset
			win = photo(i:i+offset, j:j+offset);
            win = imresize(win, [16, 16]);
			if (H(win) >= 0 && j ~= 430 && j~= 490)
                [i, j]
				rectangle('Position', [j i 32 32], 'EdgeColor', 'r');
			end
		end
    end
    
	offset = 20;
	for i = 1:16:height-offset
		for j = 1:8:width-offset
			win = photo(i:i+offset, j:j+offset);
            win = imresize(win, [16, 16]);
			if (H(win) >= 0)
				rectangle('Position', [j i 20 20], 'EdgeColor', 'r');
			end
		end
    end
    
    offset = 12;
	for i = 1:16:height-offset
		for j = 1:6:width-offset
			win = photo(i:i+offset, j:j+offset);
            win = imresize(win, [16, 16]);
			if (H(win) >= 0)
				rectangle('Position', [j i 12 12], 'EdgeColor', 'r');
			end
		end
    end
    
	offset = 16;
	for i = 1:16:height-offset
		for j = 1:6:width-offset
			win = photo(i:i+offset, j:j+offset);
            win = imresize(win, [16, 16]);
			if (H(win) >= 0)
				rectangle('Position', [j i 20 20], 'EdgeColor', 'r');
			end
		end
    end
    

end
