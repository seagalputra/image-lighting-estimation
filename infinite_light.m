function L = infinite_light(N, intensity, lambda)

if (nargin < 3)
    lambda = 1;
end

M = blkdiag(N{:});
M = [M ones(size(M,1),1)];
b = intensity';
c = {[-1 0 1 0; 0 -1 0 1]};
c = repmat(c,1,size(N,1)/2);
block_c = blkdiag(c{:});
block_c = [block_c zeros(size(block_c,1),1)];
v = pinv((M'*M) + lambda*(block_c'*block_c))*M'*b;
v(end) = [];
% average the result of light estimation
Lx = [];
Ly = [];
for i = 1:size(v,1)
    if (mod(i,2) == 0)
        Ly = [Ly; v(i,:)];
    else
        Lx = [Lx; v(i,:)];
    end
end
L = [Lx, Ly];
L = mean(L);
end

