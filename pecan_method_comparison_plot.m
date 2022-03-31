binRange = 15:5:75;

hcx = histcounts(pecan_method_comp(:,1),[binRange Inf]);
hcy = histcounts(pecan_method_comp(:,2),[binRange Inf]);

figure
bar(binRange,[hcx;hcy]')
