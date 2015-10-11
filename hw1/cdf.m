function p = cdf(x, u)
	p =  1/sqrt(9*(2*pi)^2) * e^(-0.5 * (x-u)' * (1/9)*eye(2) * (x-u));
end
