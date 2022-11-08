function W = BSL3(r1,r2)
    normr1 =sqrt(sum(r1.^2,3));
    normr2 = sqrt(sum(r2.^2,3));
    d1 = (normr1+r1(:,:,1)).*normr1;
    d2 = (normr2+r2(:,:,1)).*normr2;
    W = (cross(r1,r2,3)./(normr1.*normr2+sum(r1.*r2,3))).*(1./normr1+1./normr2); 
    W(:,:,2)=W(:,:,2)+(r1(:,:,3))./d1+(r2(:,:,3))./d2;
    W(:,:,3)=W(:,:,3)-(r1(:,:,2))./d1-(r2(:,:,2))./d2;
end