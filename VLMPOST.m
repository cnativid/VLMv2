function C_L = VLMPOST(Gamma,wingGeomX,wingGeomY,panelRY,panelTY,S)
    panelPY=panelTY-panelRY;
    b = wingGeomY(end)-wingGeomY(1);
    Gammab = sum(Gamma,1);
    C_ln = Gamma.*panelPY*2;
    C_L = sum(C_ln,'all')/S
    

    % plotting
    cfigure([.5,.5])
    hold on
    plot(reshape([wingGeomY(end,1:end-1);wingGeomY(end,2:end)],1,[]),reshape([Gammab;Gammab],1,[]),DisplayName='Gamma Distribution')
    plot(wingGeomY(end,:),max(Gammab).*(1-4*(wingGeomY(end,:)./b).^2).^.5,DisplayName='Elliptical Distribution')
    legend()

end