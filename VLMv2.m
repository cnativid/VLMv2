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
%% define geometry & discretization
    %   for one section wing:
    %   pdata = [b/2,bPanels,rootC,offset;
    %            ~,~,tipC,offset]
    %   for multi section wing:
    %   pdata = [b/2,bPanels,rootC,offset;
    %            b/2,bPanels,intermediateC,offset;
    %            ~,~,tipC,offset]
% pdata = [1.5,3,1,0;
%     .5,1,.97,0;
%     2,4,.93,0;
%     1,2,.65,0;
%     NaN,NaN,.2,0];
pdata = [2.8,20,1,0;
    NaN,NaN,.4,0];

cfun = {@(x) 0*sin(pi.*x),@(x) 0*sin(pi.*x),@(x) 0*sin(pi.*x),@(x) 0*sin(pi.*x),@(x) 0*sin(pi.*x)};
cPanels = 10;

U_inf = 1;
alpha = 10*pi/180;


% solve!
[wingGeomX,wingGeomY,wingGeomZ,panelRX,panelRY,panelRZ,panelTX,panelTY,panelTZ,panelCPX,panelCPY,panelCPZ,nX,nY,nZ,S,AR] = wingGeom3D(pdata,cPanels,cfun,alpha);
Gamma = VLMSOLVE3D(panelRX,panelRY,panelRZ,panelTX,panelTY,panelTZ,panelCPX,panelCPY,panelCPZ,nX,nY,nZ); 
VLMPOST(Gamma,wingGeomX,wingGeomY,panelRY,panelTY,S);

% check w/ eq:
disp(alpha*2*pi/(1+2*pi/(pi*AR)))

% fake visualization (will fix later)
b = 2*sum(pdata(1:end-1,1));
bPanels = 2*sum(pdata(1:end-1,2));
nPanels = cPanels*bPanels;
x = linspace(-5,50,50);
y = linspace(-b,b,50);
z = y;
[X,Y,Z] = meshgrid(x,y,z);

U=U_inf*ones(size(X));
V=zeros(size(X));
W=zeros(size(X));

for p = 1:nPanels
    [Ui,Vi,Wi]=BSL2(X-panelRX(p),Y-panelRY(p),Z-panelRZ(p),X-panelTX(p),Y-panelTY(p),Z-panelTZ(p),Gamma(p));
    U = U + Ui;
    V = V + Vi;
    W = W + Wi;
end
cfigure([.5,.5])
hold on
surf(wingGeomX,wingGeomY,wingGeomZ,'FaceColor','none','Displayname','Wing Geometry')
streamline(X,Y,Z,U,V,W,wingGeomX(end,:),wingGeomY(end,:),wingGeomZ(end,:),[.01,10^6])
axis equal, axis tight