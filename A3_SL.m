%% PROBLEM STATEMENT
% Aim: Consider 2-ray model (1 direct path and 1 multipath reflecting from ground) where
% transmitter and receiver are placed 4000m apart at BTS tower of height 121m. Transmitter and
% receiver are equipped with Omni directional antennas radiating FMCW signal of 0.1 second
% window of frequency varying from 824MHz to 834MHz. Consider specular reflection happens at
% dry ground surface of earth. Derive mathematical expression for received power at receiver
% antenna and study effects of multipath fading over estimated power of received signal. Use
% Nyquist theorem for deciding sampling rate. Refer suitable assumptions to solve above problem.

clc;
clear all;                          %%clears all previous values in command window
close all;                          %%closes all previous tabs open
%% given parameters
d = 4000;                           %%distance between tx and rx in meters
h = 121;                            %%height of BTS tower
psd = pi;                             %%declaring value of pi
c = 3*10^8;                         %%speed of light

%% finding the path distances from tx to rx
d1 = 2 * sqrt((d/2)^2 + h^2);      %%distance from tx to rx due to ground reflection

%% delcaring the step-size, frequnecy and time parameter
Fs = 2000;                             %%time samples
fs = 1668e6;                            %sampling frequency
f = 824e6:5000:834e6;                    %%Frequency range (taking ss = 25000)
t = 0:5e-5:0.1;                     %%FM signal

%% input signal
A = input("Enter the value of amplitude: "); %disp(A)
w = 2*psd*f; %disp(w)
x = A*cos(w.*t); disp(x); figure(1); plot(t,x); title("Input Signal");xlabel("Time in seconds"); ylabel("Amplitude");

%% time delay
u0 = (d/c); u1 = (d1/c);      %%time delays

%% calculating the value of alpha
a0 = 1/d;               %%direct path
a1 = (1/d1)*0.9;    %%ground reflected path R = 0.9

%% outpur signal( direct delay fuction )
y0 = a0*delayseq(x,u0); 
disp(y0); figure(2); subplot(2,2,1); plot(t,y0,'m'); title("DIRECT PATH Received Signal");xlabel("Time in seconds"); ylabel("Amplitude");
y1 = a1*delayseq(x,u1); 
disp(y1); figure(2); subplot(2,2,2); plot(t,y1,'g'); title("GROUND Reflected Received Signal");xlabel("Time in seconds"); ylabel("Amplitude");

%% adding zeros
nd0 = ceil(u0 * fs);
nd1 = ceil(u1 * fs);
disp(nd0); disp(nd1); 

%% concatenating zeros with input signal ( method 2 )
z1 = zeros(1,nd0); z2 = zeros(1,nd1);
Y0 = horzcat(z1,y0);
Y1 = horzcat(z2,y1);

%% making the vectors to eual length of summation
maxLength = max([length(Y0), length(Y1)]);
disp(maxLength);
Y0(length(Y0)+1:maxLength) = 0;
Y1(length(Y1)+1:maxLength) = 0;

%% receiver signal
Y = Y0 + Y1; %disp(Y); figure; plot(Y,'r'); %subplot(2,2,1);plot(y);
figure(2); subplot(2,2,3); plot(Y0,'m'); title("Signal 1 (after adding zeros)");xlabel("Time in seconds"); ylabel("Amplitude");
figure(2); subplot(2,2,4); plot(Y1,'g'); title("Signal 2 (after adding zeros)");xlabel("Time in seconds"); ylabel("Amplitude");
figure(3); plot(Y,'r'); title("Received Signal"); xlabel("Time in seconds"); ylabel("Amplitude");%subplot(2,2,1);plot(y);
 
%% fft
fs = 1668e6;                    %sampling frequency, considering fm = 834MHz and fs = 2*fm = 1668 MHz ~ 1700 MHz(approx)
q = fft(Y); 
n = length(q);
Q = abs(q);
fbins = linspace(0,fs/2-fs/n,n);
figure(4); subplot(2,1,1); plot(fbins,Q); title("FFT OUTPUT"); xlabel('frequency'); ylabel('amplitude');

%% psd of signal
qc=conj(q);
m = (q.*qc);
psd = 1/n*10.*log10(m);
figure(4); subplot(2,1,2); plot(fbins, psd); title(" PSD output "); xlabel('frequency'); ylabel('');
