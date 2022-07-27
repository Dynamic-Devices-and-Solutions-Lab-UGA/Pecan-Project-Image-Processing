Psi = solval(:,:,1);
Xi = solval(:,:,2);

PsiShift = Psi-91;

figure(3)
fp = fimplicit(@(x,y) interpolatesurf(x,y,W1,W2,PsiShift),[0 10 0 10]);

figure(4)
plot3(fp.XData',fp.YData',interpolatesurfXi(fp.XData',fp.YData',W1,W2,Xi))

function out = interpolatesurf(xq,yq,W1,W2,PsiShift)

out = interp2(W1,W2,PsiShift,xq,yq);
end

function out = interpolatesurfXi(xq,yq,W1,W2,Xi)

out = interp2(W1,W2,Xi,xq,yq);
end

