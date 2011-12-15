function [phi, nfeature] = computeFeatures(state, order)

[x, y, z, h] = meshgrid(0:order, 0:order);
multipliers = [x(:), y(:)];
nfeature = length(multipliers);
norm = @(x1,r,m) (x1 - m)/r;

p = state(1);
v = state(2);

vRange = .14;
vMin = -0.07;
pRange = 1.7;
pMin = -1.2;

npos = norm(p, pRange, pMin);
nv = norm(v, vRange, vMin);

f = @(a1, a2) cos(pi*(npos*a1+nv*a2));

phi = [];

for i = 1:nfeature
    phi = [phi f(multipliers(i,1), multipliers(i,2))];
end;
end

