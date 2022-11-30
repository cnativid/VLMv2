function [Wx,Wy,Wz] = BSL2(r1x,r1y,r1z,r2x,r2y,r2z,Gamma)
    % BSL2: uses eq 6.33 from Mark Drela - Flight Vehicle Aerodynamics for
    % general freestream velocity
    
    normr1 = sqrt(r1x.^2+r1y.^2+r1z.^2);
    normr2 = sqrt(r2x.^2+r2y.^2+r2z.^2);
    pmag1 = (Gamma/(4*pi)).*(1./normr1+1./normr2)./(normr1.*normr2+r1x.*r2x+r1y.*r2y+r1z.*r2z);
    pmag2 = (Gamma/(4*pi))./(normr1.*(normr1-r1x));
    pmag3 = (Gamma/(4*pi))./(normr2.*(normr2-r2x));
    Wx = (r1y.*r2z-r1z.*r2y).*pmag1;
    Wy = (r1z.*r2x-r1x.*r2z).*pmag1 + r1z.*pmag2 - r2z.*pmag3;
    Wz = (r1x.*r2y-r1y.*r2x).*pmag1 - r1y.*pmag2 + r2y.*pmag3;
    

    % detect colinear points, set to zero
    Wx(isnan(Wx))=0;
    Wy(isnan(Wy))=0;
    Wz(isnan(Wz))=0;
end