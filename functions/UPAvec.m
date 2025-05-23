function antennaVec = UPAvec(Ny, Nz, lamda, theta, phi)
    k = 2*pi / lamda;
    d = lamda / 2;
    az = exp(1j * k * d * (0:Nz-1).' * sin(phi));
    az = az/sqrt(Nz);
    ay = exp(1j * k * d * (0:Ny-1).' * sin(theta) * cos(phi));
    ay = ay/sqrt(Ny);
    antennaVec = kron(ay, az);
end