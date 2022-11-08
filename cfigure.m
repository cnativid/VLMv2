function cfigure(winsize) % version two! :D
    screensize = get(groot,'Screensize');
    set(figure,'position',[screensize(3:4).*(1-winsize)/2,screensize(3:4).*winsize])
end