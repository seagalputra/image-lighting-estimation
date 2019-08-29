function v = curvefit(x,y,num)
p = polyfit(y,x,num);
yy = y;
xx = polyval(p,yy);
v(:,1) = xx;
v(:,2) = yy;
end

