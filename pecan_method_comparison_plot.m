binRange = 70:5:130;

hcx = histcounts(pecan_method_comp(:,1),[binRange Inf]);
hcy = histcounts(pecan_method_comp(:,2),[binRange Inf]);

figure
bar(binRange,[hcx;hcy]')
