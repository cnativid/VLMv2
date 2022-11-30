function Gamma = VLMSOLVE3D(panelRX,panelRY,panelRZ,panelTX,panelTY,panelTZ,panelCPX,panelCPY,panelCPZ,nX,nY,nZ)
    nPanels = numel(panelCPX);
    W=zeros(nPanels);
    for p = 1:nPanels
        [Wx,Wy,Wz]=BSL2(panelCPX(p)-panelRX,panelCPY(p)-panelRY,panelCPZ(p)-panelRZ,panelCPX(p)-panelTX,panelCPY(p)-panelTY,panelCPZ(p)-panelTZ,1);
        W(p,:) = reshape(nX(p)*Wx+nY(p)*Wy+nZ(p)*Wz,1,[]);
    end
    RHS = reshape(-nX,[],1);
    Gamma = reshape(linsolve(W,RHS),size(panelRX));
end