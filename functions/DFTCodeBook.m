function W = DFTCodeBook(Ny,Nz)
    DFTz = dftmtx(Nz);
    DFTy = dftmtx(Ny);
    N = Ny * Nz;
    W = zeros(N, N);
    for i = 1:Ny
        for j = 1:Nz
            index = (j - 1) * Ny + i;
            W(:, index) = kron(DFTz(:, j), DFTy(:, i));
        end
    end
    W = W./vecnorm(W);
end