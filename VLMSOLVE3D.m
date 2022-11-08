function Gamma = VLMSOLVE3D(panelRX,panelRY,panelRZ,panelTX,panelTY,panelTZ,panelCPX,panelCPY,panelCPZ,nX,nY,nZ,Uinf,alpha)
%     [panelRX,panelRY,panelRZ] = eulerangles(panelRX,panelRY,panelRZ,0,alpha,0);
%     [panelTX,panelTY,panelTZ] = eulerangles(panelTX,panelTY,panelTZ,0,alpha,0);
%     [nX,nY,nZ] = eulerangles(nX+panelCPX,nY+panelCPY,nZ+panelCPZ,0,alpha,0);
%     [panelCPX,panelCPY,panelCPZ] =eulerangles(panelCPX,panelCPY,panelCPZ,0,alpha,0);
%     nX = nX-panelCPX;
%     nY = nY-panelCPY;
%     nZ = nZ-panelCPZ;
    nPanels = numel(panelCPX);
    W=zeros(nPanels);
    for p = 1:nPanels
        [Wxb,Wyb,Wzb]=BSL(panelCPX(p)-panelRX,panelCPY(p)-panelRY,panelCPZ(p)-panelRZ,panelCPX(p)-panelTX,panelCPY(p)-panelTY,panelCPZ(p)-panelTZ,1);
        [Wxrt,Wyrt,Wzrt]=BSL(panelCPX(p)-(panelRX+4000),panelCPY(p)-panelRY,panelCPZ(p)-panelRZ,panelCPX(p)-panelRX,panelCPY(p)-panelRY,panelCPZ(p)-panelRZ,1);
        [Wxtt,Wytt,Wztt]=BSL(panelCPX(p)-panelTX,panelCPY(p)-panelTY,panelCPZ(p)-panelTZ,panelCPX(p)-(panelTX+4000),panelCPY(p)-panelTY,panelCPZ(p)-panelTZ,1);
        W(p,:) = reshape(nX(p)*(Wxb+Wxrt+Wxtt)+nY(p)*(Wyb+Wyrt+Wytt)+nZ(p)*(Wzb+Wzrt+Wztt),1,[]);
    end
    u = Uinf;
    v = 0;
    w = 0;
    RHS = reshape(-nX*u,[],1);
    Gamma = reshape(linsolve(W,RHS),size(panelRX));
end