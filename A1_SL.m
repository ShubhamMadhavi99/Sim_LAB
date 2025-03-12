clc;
clear all;
close all;

%% Given Parameters
d = 4000;       % Distance between transmitter and receiver in meters
h = 500;        % Height of BTS tower
p = pi;         % Value of pi
c = 3e8;        % Speed of light
h1 = 48000;     % Height from TX antenna to ionospheric layer

%% Calculating Path Distances
d1 = 2 * sqrt((d/2)^2 + h^2);       % Distance due to ionospheric reflection
d2 = 2 * sqrt((d/2)^2 + h1^2);      % Distance due to ground reflection

%% Defining Step-Size, Frequency, and Time Parameters
Fs = 250e2;                          % Time samples
f = 824e6:400:834e6;                 % Frequency range
fs = 1700e6;                         % Sampling frequency
t = 0:4e-12:0.1e-6;                  % FM signal time vector

%% Input Signal
A = input("Enter the value of amplitude: ");
w = 2 * p * f;
x = A * cos(w .* t);

figure(1);
subplot(2,2,1);
plot(t, x);
title("Input Signal");
xlabel("Time in seconds");
ylabel("Amplitude");

%% Calculating Time Delays
u0 = d / c;
u1 = d1 / c;
u2 = d2 / c;

%% Calculating Attenuation Factors
a0 = 1 / d;              % Direct path
a1 = (1 / d1)^2 * 0.9;  % Ground-reflected path (R = 0.9)
a2 = (1 / d2)^2 * 0.5;  % Ionospheric reflection (R = 0.5)

%% Output Signals with Delay
y0 = a0 * delayseq(x, u0);
y1 = a1 * delayseq(x, u1);
y2 = a2 * delayseq(x, u2);

subplot(2,2,2);
plot(t, y0, 'm');
title("DIRECT PATH Received Signal");
xlabel("Time in seconds");
ylabel("Amplitude");

subplot(2,2,3);
plot(t, y1, 'g');
title("GROUND Reflected Received Signal");
xlabel("Time in seconds");
ylabel("Amplitude");

subplot(2,2,4);
plot(t, y2);
title("IONOSPHERIC Reflected Received Signal");
xlabel("Time in seconds");
ylabel("Amplitude");

%% Adding Zeros (Method 2)
nd0 = ceil(u0 * fs);
nd1 = ceil(u1 * fs);
nd2 = ceil(u2 * fs);

z1 = zeros(1, nd0);
z2 = zeros(1, nd1);
z3 = zeros(1, nd2);

Y0 = horzcat(z1, y0);
Y1 = horzcat(z2, y1);
Y2 = horzcat(z3, y2);

%% Making Vectors Equal in Length
maxLength = max([length(Y0), length(Y1), length(Y2)]);
Y0(length(Y0)+1:maxLength) = 0;
Y1(length(Y1)+1:maxLength) = 0;
Y2(length(Y2)+1:maxLength) = 0;

%% Received Signal
Y = Y0 + Y1 + Y2;

figure(2);
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

subplot(2,2,3);
plot(Y2);
title("Signal 3 (after adding zeros)");
xlabel("Time in seconds");
ylabel("Amplitude");

subplot(2,2,4);
plot(Y, 'r');
title("Received Signal");
xlabel("Time in seconds");
ylabel("Amplitude");
