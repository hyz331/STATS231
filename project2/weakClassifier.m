% Apply rectangle on integral image
% a -- b
% | -- |
% c -- d

function val = weakClassifier(inte_img, ul, lr, ori)

	total = getSum(inte_img, ul, lr);

	% Generate patterns based on parameters
	if (ori == 1)
		%  [* ]
		%  [* ]
		ul_new = ul;
		lr_new = [lr(1) ul(2) + uint8((lr(2)-ul(2)) / 2) - 1];
		val = total - 2 * getSum(inte_img, ul_new, lr_new);
	elseif (ori == 2)
		%  [ *]
		%  [ *]
		ul_new = [ul(1) ul(2) + uint8((lr(2)-ul(2)) / 2)];
		lr_new = lr;
		val = total - 2 * getSum(inte_img, ul_new, lr_new);
	elseif (ori == 3)
		%  [**]
		%  [  ]
		ul_new = ul;
		lr_new = [ul(1) + uint8((lr(1)-ul(1)) / 2) - 1  lr(2)];
		val = total - 2 * getSum(inte_img, ul_new, lr_new);
	elseif (ori == 4)
		%  [  ]
		%  [**]
		ul_new = [ul(1) + uint8((lr(1)-ul(1)) / 2) ul(2)];
		lr_new = lr;
		val = total - 2 * getSum(inte_img, ul_new, lr_new);
	elseif (ori == 5)
		%  [ * ]
		%  [ * ]
		%  [ * ]
		ul_new = [ul(1) ul(2) + uint8((lr(2)-ul(2)+1) / 3) * 1];
		lr_new = [lr(1) ul_new(2) + uint8((lr(2)-ul(2)+1) / 3) - 1];
		val = total - 2 * getSum(inte_img, ul_new, lr_new);
	elseif (ori == 6)
		%  [   ]
		%  [***]
		%  [   ]
		ul_new = [ul(1) + uint8((lr(1)-ul(1)+1) / 3) * 1 ul(2)];
		lr_new = [ul_new(1) + uint8((lr(1)-ul(1)+1) / 3) - 1 lr(2)];
		val = total - 2 * getSum(inte_img, ul_new, lr_new);
		%  [* ]
		%  [ *] Size must be 4!
	elseif (ori == 7)
		s1 = getSum(inte_img, ul, ul);
		s2 = getSum(inte_img, lr, lr);
		val = total - 2 * (s1 + s2);
		%  [ *]
		%  [* ] Size must be 4!
	elseif (ori == 8)
		s1 = getSum(inte_img, ul, ul);
		s2 = getSum(inte_img, lr, lr);
		val = -(total - 2 * (s1 + s2));
	end

	% For visualizing to verify correctness
	% test_img = inte_img;
	% test_img(ul_new(1) : lr_new(1), ul_new(2) : lr_new(2)) = 0
end
