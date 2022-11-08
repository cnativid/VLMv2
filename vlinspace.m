function V = vlinspace(v1,v2,n) % vectorized linspace, accepts column vectors
    n = linspace(0,1,n);
    m = v1-v2;
    V = v1-m.*n;
end