function [Wx,Wy,Wz] = BSL(r1x,r1y,r1z,r2x,r2y,r2z,Gamma)
    % calculate magnitude via BSL
    normr1 = sqrt(r1x.^2+r1y.^2+r1z.^2);
    normr2 = sqrt(r2x.^2+r2y.^2+r2z.^2);
    pmag = (Gamma/(4*pi)).*(1./normr1+1./normr2)./(normr1.*normr2+r1x.*r2x+r1y.*r2y+r1z.*r2z);
    Wx = (r1y.*r2z-r1z.*r2y).*pmag;
    Wy = (r1z.*r2x-r1x.*r2z).*pmag;
    Wz = (r1x.*r2y-r1y.*r2x).*pmag;

    % detect colinear points, set to zero
    Wx(isnan(Wx))=0;
    Wy(isnan(Wy))=0;
    Wz(isnan(Wz))=0;
end