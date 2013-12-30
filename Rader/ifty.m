function fs=ifty(s)
fs=ifftshift(ifft(ifftshift(s.')))'; 