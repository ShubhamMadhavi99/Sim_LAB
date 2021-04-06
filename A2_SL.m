
clc;
clear all;                          %%cleara all previous values in command window
close all;                          %%closes all previous tabs open
%% given parameters
d = 4000;                           %%distance between tx and rx in meters
h = 500;                            %%height of BTS tower
p = pi;                             %%declaring value of pi
c = 3*10^8;                         %%speed of light
h1 = 48000;                         %%height from tx antenna to inospheric layer

%% finding the path distances from tx to rx
d2 = 2 * sqrt((d/2)^2 + h1^2);       %%distance from tx to rx due to ionsopheric reflection
d1 = 2 * sqrt((d/2)^2 + h^2);      %%distance from tx to rx due to ground reflection

%% delcaring the step-size, frequnecy and time parameter
Fs = 250e2;                             %%time samples
f = 824e6:400:834e6;                    %%Frequency range (taking ss = 250000)
t = 0:4e-12:0.1e-6;                     %%FM signal
fs = 1668e6;                            %sampling frequency

%% input signal
A = input("Enter the value of amplitude: "); %disp(A)
w = 2*p*f; %disp(w)
x = A*cos(w.*t); disp(x); figure(1); subplot(2,2,1); plot(t,x); title("Input Signal");xlabel("Time in seconds"); ylabel("Amplitude");

%% time delay
u0 = (d/c); u1 = (d1/c); u2 = (d2/c);       %%time delays

%% calculating the value of alpha
a0 = 1/d;               %%direct path
a1 = (1/d1)*0.9;    %%ground reflected path R = 0.9
a2 = (1/d2)*0.5;    %%inospheric reflection R = 0.5  (considering that 50 percent energy will be bouncing back at the receiver

%% outpur signal( direct delay fuction )
y0 = a0*delayseq(x,u0); 
disp(y0); figure(1); subplot(2,2,2); plot(t,y0,'m'); title("DIRECT PATH Received Signal");xlabel("Time in seconds"); ylabel("Amplitude");
y1 = a1*delayseq(x,u1); 
disp(y1); figure(1); subplot(2,2,3);plot(t,y1,'g'); title("GROUND Reflected Received Signal");xlabel("Time in seconds"); ylabel("Amplitude");
y2 = a2*delayseq(x,u2); 
disp(y2); figure(1); subplot(2,2,4); plot(t,y2); title("INOSPHERIC Reflected Received Signal");xlabel("Time in seconds"); ylabel("Amplitude");

%% adding zeros
nd0 = ceil(u0 * fs);
nd1 = ceil(u1 * fs);
nd2 = ceil(u2 * fs);
disp(nd0); disp(nd1); disp(nd2);

%% concatenating zeros with input signal ( method 2 )
z1 = zeros(1,nd0); z2 = zeros(1,nd1); z3 = zeros(1,nd2);
Y0 = horzcat(z1,y0);
Y1 = horzcat(z2,y1);
Y2 = horzcat(z3,y2);

%% making the vectors to eual length of summation
maxLength = max([length(Y0), length(Y1), length(Y2)]);
disp(maxLength);
Y0(length(Y0)+1:maxLength) = 0;
Y1(length(Y1)+1:maxLength) = 0;
Y2(length(Y2)+1:maxLength) = 0;

%% receiver signal
Y = Y0 + Y1 + Y2; disp(Y); %figure; plot(Y,'r'); %subplot(2,2,1);plot(y);
%figure(2);plot(Y); 
figure(3);subplot(2,2,1); plot(Y0,'m'); title("Signal 1 (after adding zeros)");xlabel("Time in seconds"); ylabel("Amplitude");
figure(3);subplot(2,2,2); plot(Y1,'g'); title("Signal 2 (after adding zeros)");xlabel("Time in seconds"); ylabel("Amplitude");
figure(3);subplot(2,2,3); plot(Y2); title("Signal 3 (after adding zeros)");xlabel("Time in seconds"); ylabel("Amplitude");
figure(3);subplot(2,2,4); plot(Y,'r'); title("Received Signal"); xlabel("Time in seconds"); ylabel("Amplitude");%subplot(2,2,1);plot(y);

%% calculating fft
fs = 1668e6;                    %sampling frequency, considering fm = 834MHz and fs = 2*fm = 1668 MHz ~ 1700 MHz(approx)
q = fft(Y); 
n = length(q);
Q = abs(q);
fbins = linspace(0,fs/2-fs/n,n);
figure;
plot(fbins,Q);
title('Output of FFT');
xlabel('frequency');
ylabel('amplitude');

