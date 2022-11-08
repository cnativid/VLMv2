function [wingGeomX,wingGeomY,wingGeomZ,panelRX,panelRY,panelRZ,panelTX,panelTY,panelTZ,panelCPX,panelCPY,panelCPZ,nX,nY,nZ,K] = wingGeom2D(data,cPanels,cfun)
% last updated: 11/8/2022
% data formatting: 
%   for one section wing:
%   pdata = [b/2,bPanels,rootC,offset;
%            ~,~,tipC,offset]
%   for multi section wing:
%   pdata = [b/2,bPanels,rootC,offset;
%            b/2,bPanels,intermediateC,offset;
%            ~,~,tipC,offset]
% cpanels = # of chordwise panels
%   dependencies:
%   cfigure()
%   BSL()
%   vlinspace()
%     b = 2*sum(data(1:end-1,2));
% cfun = MCL function

    % ease of editing var:
    sectionb = data(1:end-1,1); % section length
    sectionp = data(1:end-1,2); % section panel count
    sectionc = data(:,3); % section chord
    sectiono = data(:,4); % section offset
    
    bPanels = sum(sectionp);
    wingGeomX = zeros(cPanels+1,bPanels+1);
    wingGeomY = zeros(1,bPanels+1);
    wingGeomZ = zeros(cPanels+1,bPanels+1);
    
    m = 1;
    for i = 1:(length(sectionb)) % generate wing geometry
        wingGeomX(:,m:m+sectionp(i)) = vlinspace(linspace(sectiono(i),sectionc(i)+sectiono(i),cPanels+1)',linspace(sectiono(i+1),sectionc(i+1)+sectiono(i+1),cPanels+1)',sectionp(i)+1);
        wingGeomY(m:m+sectionp(i)) = linspace(sum(sectionb(1:i-1)),sum(sectionb(1:i)),sectionp(i)+1);
        wingGeomZ(:,m:m+sectionp(i)) = vlinspace(cfun{i}(linspace(0,1,cPanels+1)'),cfun{i+1}(linspace(0,1,cPanels+1)'),sectionp(i)+1);
        m = m + sectionp(i);
    end
    wingGeomY = repmat([-flip(wingGeomY,2),wingGeomY(:,2:end)],cPanels+1,1);
    wingGeomX = [flip(wingGeomX,2),wingGeomX(:,2:end)];
    wingGeomZ = [flip(wingGeomZ,2),wingGeomZ(:,2:end)];
    [wingGeomX,wingGeomY,wingGeomZ] = eulerangles(wingGeomX,wingGeomY,wingGeomZ,0,0,0);

    panelRX = .75*wingGeomX(1:end-1,1:end-1)+.25*wingGeomX(2:end,1:end-1);
    panelRY = .75*wingGeomY(1:end-1,1:end-1)+.25*wingGeomY(2:end,1:end-1);
    panelRZ = .75*wingGeomZ(1:end-1,1:end-1)+.25*wingGeomZ(2:end,1:end-1);

    panelTX = .75*wingGeomX(1:end-1,2:end)+.25*wingGeomX(2:end,2:end);
    panelTY = .75*wingGeomY(1:end-1,2:end)+.25*wingGeomY(2:end,2:end);
    panelTZ = .75*wingGeomZ(1:end-1,2:end)+.25*wingGeomZ(2:end,2:end);
    
    K = sqrt((panelTX-panelRX).^2+(panelTY-panelRY).^2+(panelTZ-panelRZ).^2);
    panelCPX = (.25*wingGeomX(1:end-1,1:end-1)+.75*wingGeomX(2:end,1:end-1)+.25*wingGeomX(1:end-1,2:end)+.75*wingGeomX(2:end,2:end))*.5;
    panelCPY = (.25*wingGeomY(1:end-1,1:end-1)+.75*wingGeomY(2:end,1:end-1)+.25*wingGeomY(1:end-1,2:end)+.75*wingGeomY(2:end,2:end))*.5;
    panelCPZ = (.25*wingGeomZ(1:end-1,1:end-1)+.75*wingGeomZ(2:end,1:end-1)+.25*wingGeomZ(1:end-1,2:end)+.75*wingGeomZ(2:end,2:end))*.5;
       
    d1X= wingGeomX(2:end,2:end)-wingGeomX(1:end-1,1:end-1);
    d1Y= wingGeomY(2:end,2:end)-wingGeomY(1:end-1,1:end-1);
    d1Z= wingGeomZ(2:end,2:end)-wingGeomZ(1:end-1,1:end-1);
    d2X= wingGeomX(2:end,1:end-1)-wingGeomX(1:end-1,2:end);
    d2Y= wingGeomY(2:end,1:end-1)-wingGeomY(1:end-1,2:end);
    d2Z= wingGeomZ(2:end,1:end-1)-wingGeomZ(1:end-1,2:end);
    
    nX= d1Y.*d2Z - d1Z.*d2Y;
    nY= d1Z.*d2X - d1X.*d2Z;
    nZ= d1X.*d2Y - d1Y.*d2X;
    normN = sqrt(nX.^2 + nY.^2 + nZ.^2);
    nX = nX./normN;
    nY = nY./normN;
    nZ = nZ./normN;

    cfigure([.5,.5])
    hold on
    surf(wingGeomX,wingGeomY,wingGeomZ,'FaceColor','none','Displayname','Wing Geometry')
    scatter3(reshape(panelCPX,[],1),reshape(panelCPY,[],1),reshape(panelCPZ,[],1),'vb','DisplayName','Collocation Points')
    scatter3(reshape(panelRX,[],1),reshape(panelRY,[],1),reshape(panelRZ,[],1),'xr','Displayname','Vortex Filament Root')
    scatter3(reshape(panelTX,[],1),reshape(panelTY,[],1),reshape(panelTZ,[],1),'or','Displayname','Vortex Filament Root')
    legend
    view([90,90])
    axis equal
    axis tight
    xlabel('x'),ylabel('y'),zlabel('z')
end