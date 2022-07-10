Psi = solval(:,:,1);

PsiShift = Psi-87.5;

figure(3)
fp = fimplicit(@(x,y) interpolatesurf(x,y,W1,W2,PsiShift),[0 10 0 10]);


function out = interpolatesurf(xq,yq,W1,W2,PsiShift)

out = interp2(W1,W2,PsiShift,xq,yq);
end

