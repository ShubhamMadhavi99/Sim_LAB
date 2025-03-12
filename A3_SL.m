clc;
clear all;                          %% Clear all previous values in command window
close all;                          %% Close all previous tabs open

%% Given Parameters
d = 4000;       % Distance between transmitter and receiver in meters
h = 121;        % Height of BTS tower
psd = pi;       % Value of pi
c = 3e8;        % Speed of light

%% Calculating Path Distances
d1 = 2 * sqrt((d/2)^2 + h^2);  % Distance due to ground reflection

%% Defining Step-Size, Frequency, and Time Parameters
Fs = 2000;                      % Time samples
fs = 1668e6;                    % Sampling frequency
f = 824e6:5000:834e6;           % Frequency range
t = 0:5e-5:0.1;                 % FM signal time vector

%% Input Signal
A = input("Enter the value of amplitude: ");
w = 2 * psd * f;
x = A * cos(w .* t);

figure(1);
plot(t, x);
title("Input Signal");
xlabel("Time in seconds");
ylabel("Amplitude");

%% Calculating Time Delays
u0 = d / c;
u1 = d1 / c;

%% Calculating Attenuation Factors
a0 = 1 / d;             % Direct path
a1 = (1 / d1) * 0.9;   % Ground-reflected path (R = 0.9)

%% Output Signals with Delay
y0 = a0 * delayseq(x, u0);
y1 = a1 * delayseq(x, u1);

figure(2);
subplot(2,2,1);
plot(t, y0, 'm');
title("DIRECT PATH Received Signal");
xlabel("Time in seconds");
ylabel("Amplitude");

subplot(2,2,2);
plot(t, y1, 'g');
title("GROUND Reflected Received Signal");
xlabel("Time in seconds");
ylabel("Amplitude");

%% Adding Zeros
nd0 = ceil(u0 * fs);
nd1 = ceil(u1 * fs);
z1 = zeros(1, nd0);
z2 = zeros(1, nd1);
Y0 = horzcat(z1, y0);
Y1 = horzcat(z2, y1);

%% Making Vectors Equal in Length
maxLength = max([length(Y0), length(Y1)]);
Y0(length(Y0)+1:maxLength) = 0;
Y1(length(Y1)+1:maxLength) = 0;

%% Received Signal
Y = Y0 + Y1;

figure(3);
subplot(2,2,1);
plot(Y0, 'm');
title("Signal 1 (after adding zeros)");
xlabel("Time in seconds");
ylabel("Amplitude");

subplot(2,2,2);
plot(Y1, 'g');
title("Signal 2 (after adding zeros)");
xlabel("Time in seconds");
ylabel("Amplitude");

figure(3);
plot(Y, 'r');
title("Received Signal");
xlabel("Time in seconds");
ylabel("Amplitude");

%% FFT Calculation
fs = 1668e6;  % Sampling frequency
q = fft(Y);
n = length(q);
Q = abs(q);
fbins = linspace(0, fs/2 - fs/n, n);

figure(4);
subplot(2,1,1);
plot(fbins, Q);
title("FFT OUTPUT");
xlabel('Frequency');
ylabel('Amplitude');

%% PSD Calculation
qc = conj(q);
m = (q .* qc);
psd = 1/n * 10 .* log10(m);

subplot(2,1,2);
plot(fbins, psd);
title("PSD Output");
xlabel('Frequency');
ylabel('Power Spectral Density (dB)');
