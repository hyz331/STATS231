function s = getSum(inte_img, ul, lr)
	if (ul(1) == 1 && ul(2) == 1)
		a = 0;
		b = 0;
		c = 0;
		d = inte_img(lr(1), lr(2));
	elseif (ul(1) == 1)
		a = 0;
		b = 0;
		c = inte_img(lr(1), ul(2)-1);
		d = inte_img(lr(1), lr(2));
	elseif (ul(2) == 1)
		a = 0;
		b = inte_img(ul(1)-1, lr(2));
		c = 0;
		d = inte_img(lr(1), lr(2));
	else
		a = inte_img(ul(1)-1, ul(2)-1);
		b = inte_img(ul(1)-1, lr(2));
		c = inte_img(lr(1), ul(2)-1);
		d = inte_img(lr(1), lr(2));
	end
	s = d - b - c + a;
end
