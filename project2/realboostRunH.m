function val = realboostRunH(h, f)
	[x b] = histc(h.classifier(f), [h.range inf]);
	b = max(1, min(b, length(h.bins)));
	val = h.bins(b);
end
