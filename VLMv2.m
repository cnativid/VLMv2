%{
VLM v1
11/6/2022
Supports 2D planform geometries at various AOA, no sideslip, inviscid
dependencies:
    wingGeom2D()
    VLMSOLVE2D()
    BSL()
    vlinspace()
    cfigure()
%}
%%
clc
clear
close all
format compact
format shortg
%%
% define geometry & discretization
    %   for one section wing:
    %   pdata = [b/2,bPanels,rootC,offset;
    %            ~,~,tipC,offset]
    %   for multi section wing:
    %   pdata = [b/2,bPanels,rootC,offset;
    %            b/2,bPanels,intermediateC,offset;
    %            ~,~,tipC,offset]
pdata = [1,10,1,0;
    3,40,.7,0.2;
    NaN,NaN,.5,0.9];

pdata2 = [.4,3,.5,0;
    .3,3,.5,0.05;
    NaN,NaN,.5,0.1];
cfun = {@(x) .1*sin(pi.*x),@(x) .05*sin(pi.*x),@(x) .025*sin(pi.*x)};
cfun2 = {@(x) 0*x,@(x) 0*x,@(x) 0*x};
cPanels = 6;
b = 2*sum(pdata(1:end-1,1));
bPanels = 2*sum(pdata(1:end-1,2));
nPanels = cPanels*bPanels;
Uinf = 1; 
alpha = 10*pi/180;

% solve!
[wingGeomX1,wingGeomY1,wingGeomZ1,panelRX1,panelRY1,panelRZ1,panelTX1,panelTY1,panelTZ1,panelCPX1,panelCPY1,panelCPZ1,nX1,nY1,nZ1,K1] = wingGeom3D(pdata,cPanels,cfun);
[wingGeomX2,wingGeomY2,wingGeomZ2,panelRX2,panelRY2,panelRZ2,panelTX2,panelTY2,panelTZ2,panelCPX2,panelCPY2,panelCPZ2,nX2,nY2,nZ2,K2] = wingGeom3D(pdata2,cPanels,cfun2);
wingGeomX = [wingGeomX1,wingGeomX2+5];
wingGeomY = [wingGeomY1,wingGeomY2];
wingGeomZ = [wingGeomZ1,wingGeomZ2];

panelRX = [panelRX1,panelRX2+5];
panelRY = [panelRY1,panelRY2];
panelRZ = [panelRZ1,panelRZ2];
panelTX = [panelTX1,panelTX2+5];
panelTY = [panelTY1,panelTY2];
panelTZ = [panelTZ1,panelTZ2];
panelCPX = [panelCPX1,panelCPX2+5];
panelCPY = [panelCPY1,panelCPY2];
panelCPZ = [panelCPZ1,panelCPZ2];
nX = [nX1,nX2];
nY = [nY1,nY2];
nZ = [nZ1,nZ2];
% [wingGeomX,wingGeomY,wingGeomZ,panelRX,panelRY,panelRZ,panelTX,panelTY,panelTZ,panelCPX,panelCPY,panelCPZ,nX,nY,nZ,K] = wingGeom3D(pdata,cPanels,cfun);
Gamma = VLMSOLVE3D(panelRX,panelRY,panelRZ,panelTX,panelTY,panelTZ,panelCPX,panelCPY,panelCPZ,nX,nY,nZ,Uinf,alpha);

%
x = linspace(-5,15,40);
y = linspace(-b,b,20);
z = y;
[X,Y,Z] = meshgrid(x,y,z);

U=Uinf*ones(size(X));
V=zeros(size(X));
W=zeros(size(X));

% fake visualization (will fix later)
for p = 1:nPanels
    [Ubi,Vbi,Wbi]=BSL(X-panelRX(p),Y-panelRY(p),Z-panelRZ(p),X-panelTX(p),Y-panelTY(p),Z-panelTZ(p),Gamma(p));
    [Utri,Vtri,Wtri]=BSL(X-(panelRX(p)+4000),Y-panelRY(p),Z-panelRZ(p),X-panelRX(p),Y-panelRY(p),Z-panelRZ(p),Gamma(p));
    [Utti,Vtti,Wtti]=BSL(X-panelTX(p),Y-panelTY(p),Z-panelTZ(p),X-(panelTX(p)+4000),Y-panelTY(p),Z-panelTZ(p),Gamma(p));
    U = U + Ubi + Utri + Utti;
    V = V + Vbi + Vtri + Vtti;
    W = W + Wbi + Wtri + Wtti;
end
cfigure([.5,.5])
hold on
surf(wingGeomX1,wingGeomY1,wingGeomZ1,'FaceColor','none','Displayname','Wing Geometry')
surf(wingGeomX2+5,wingGeomY2,wingGeomZ2,'FaceColor','none','Displayname','Wing Geometry')
streamline(X,Y,Z,U,V,W,wingGeomX(end,:),wingGeomY(end,:),wingGeomZ(end,:),[.01,10^6])
axis equal, axis tight