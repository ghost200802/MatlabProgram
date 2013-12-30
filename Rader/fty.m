function fs=fty(s)
fs=fftshift(fft(fftshift(s.')))';