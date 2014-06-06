% Chirp Scaling Algorithm
% reference: Precision SAR Processing Using Chirp Scaling

% clear all the parameters in the workspace
clear all
clc

[ Fc,~,~,~,PRF,~,c,H0,L0,~,~,~,~,~,~,Vr ] = ParametersSystem();

% SAR characteristics
lambda = c / Fc;    % wavelength

% target area
X0 = 200;    % target area in azimuth is within [-X0, X0]
Rc = sqrt(H0^2+L0^2); % center of imaged area
R0 = 200;   % target area in range is within [Rc-R0, Rc+R0]

% orbital information
v = 400;    % plane speed

% antenna
D = 2;  % antenna length in azimuth direction
Lsar = lambda * Rc / D; % SAR integration length

% fast-time(range) domain
Tr = 1e-7;    % pulse duration
Br = 4.5e8; % chirp frequency modulation bandwidth
Kr = Br / Tr;   % chirp slope
Nr = 1024;  % sample number in fast-time domain
R = Rc + linspace(-R0, R0, Nr);
tau = 2 * R / c;  % discrete time array in fast-time domain
dtau = R0 * 4 / c / Nr;   % sampling period in fast-time domain
ftau = linspace(-1 / 2 / dtau, 1 / 2 / dtau, Nr); % frenquency array in fast-time domain

% slow-time(azimuth, cross-range) domain
Na = 512;   % sample number in slow-time domain
x = linspace(-X0, X0, Na);  % trace of the plane
t = x / v;  % slow time
dt = 2 * X0 / v / Na; % sampling period in slow-time domain
f = linspace(-1 / 2 / dt, 1 / 2 / dt, Na);  % frenquency array in slow-time domain
Ka = - 2 * v^2 / lambda / Rc;    % doppler frequency modulation rate

% resolution
DY = c / 2 / Br;    % range resolution
DX = D / 2; % azimuth resolution

% point targets
Ptarget = [Rc, 0, 1 % positions of targets
           Rc + 10, -40, 1
           Rc - 50, 40, 1];
Ntarget = length(Ptarget);  % number of targets

% generate the raw signal data
s_tau_t = zeros(Nr, Na);    % echo
T = ones(Nr, 1) * t;
TAU = tau' * ones(1, Na);
for i = 1 %: Ntarget
    pr = Ptarget(i, 1); % position of range diretion
    pa = Ptarget(i, 2); % position of azimuth diretion
    sigma = Ptarget(i, 3);  % scattering coefficient
    r = sqrt(pr^2 + (pa - v * T).^2);
    phase = - pi * Kr * (TAU - 2 * r / c) .^2 - 4 * pi / lambda * r;
    s_tau_t = s_tau_t + sigma * exp(j * phase) .* (abs(TAU - 2 * r / c) < Tr / 2).* (abs(v * T - pa) < Lsar / 2);
end

% some parameters for the following computation
Cs = 1 ./ sqrt(1 - (lambda * f / 2 / v).^2) - 1;
Cs = ones(Nr, 1) * Cs;
Ks = Kr ./ (1 + Kr * R' * 2 * lambda / c^2 * ((lambda * f / 2 / v).^2 ./ sqrt((1 - (lambda * f / 2 / v).^2).^3)));
tau_ref = 2 / c * Rc * (1 + Cs);
% Ks_Rref = Kr ./ (1 + Kr * Rc * 2 * lambda * c^2 * ((lambda * f / 2 / v).^2 ./ sqrt((1 - (lambda * f / 2 / v).^2).^3)));
% Ks_Rref = ones(Nr, 1) * Ks_Rref;
sita = 4 * pi / c^2 * Ks .* (1 + Cs) .* Cs .* ((R' * ones(1, Na) - Rc).^2);

% azimuth fft
s_tau_f = FFTX(s_tau_t);

% CS transform
phase_1 = - pi * Ks .* Cs .* ((tau' * ones(1, Na) - tau_ref).^2);
s_tau_f_1 = s_tau_f .* exp(j * phase_1);

% range fft
s_ftau_f = FFTY(s_tau_f_1);

% range compressing and range cell migration correction
phase_2 = - pi * ftau'.^2 * ones(1, Na) ./ Ks ./ (1 + Cs) + 4 * pi / c * ftau' * ones(1, Na) * Rc .* Cs; 
s_ftau_f_2 = s_ftau_f .* exp(j * phase_2);

% range ifft
ss_tau_f = IFFTY(s_ftau_f_2);

% azimuth compressiong and phase compensation
phase_3 = - 2 * pi / lambda * c * tau' * (1 - sqrt(1 - (lambda * f / 2 / v).^2)) + sita;
s_tau_f_3 = ss_tau_f .* exp(j * phase_3);

% azimuth ifft
ss_tau_t = IFFTX(s_tau_f_3);

subplot(2,2,1)
G = 20 * log10(abs(s_tau_t) + 1e-6);
gm = max(max(G));
gn = gm - 40;   % dynamic display in 40dB
G = 255 / (gm - gn) * (G - gn) .* (G > gn);
imagesc(x,R-Rc,-G)
colormap(gray)
grid on
axis tight
xlabel('Azimuth')
ylabel('Range')
title('(a) raw signal')

subplot(2,2,2)
G = 20 * log10(abs(s_ftau_f_2) + 1e-6);
gm = max(max(G));
gn = gm - 40;   % dynamic display in 40dB
G = 255 / (gm - gn) * (G - gn) .* (G > gn);
imagesc(x,R-Rc,-G)
colormap(gray)
grid on
axis tight
xlabel('Azimuth')
ylabel('Range')
title('(b) spectrum after CS|rc|rcmc')

subplot(2,2,3)
G = 20 * log10(abs(s_tau_f_3) + 1e-6);
gm = max(max(G));
gn = gm - 40;   % dynamic display in 40dB
G = 255 / (gm - gn) * (G - gn) .* (G > gn);
imagesc(x,R-Rc,G)
colormap(gray)
grid on
axis tight
xlabel('Azimuth')
ylabel('Range')
title('(c) spectrum after CS|rc|rcmc|ac|pc')

subplot(2,2,4)
G = 20 * log10(abs(ss_tau_t) + 1e-6);
gm = max(max(G));
gn = gm - 60;   % dynamic display in 60dB
G = 255 / (gm - gn) * (G - gn) .* (G > gn);
imagesc(x,R-Rc,G)
colormap(gray)
grid on
axis tight
xlabel('Azimuth')
ylabel('Range')
title('(d) signal after CS|rc|rcmc|ac|pc')