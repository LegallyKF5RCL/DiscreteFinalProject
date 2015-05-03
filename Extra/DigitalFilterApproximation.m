clc;
clear all;
close all;
format shorteng;

FreqSamp = 10000;

x = linspace(-pi, pi, FreqSamp);
y = zeros(1, FreqSamp);
y2 = zeros(1, FreqSamp);

r1 = .9;
r2 = .8;
Theta1 = pi / 4;
Theta2 = pi / 3;

for t = 1:FreqSamp
    Pole1a = exp(1i * x(1, t)) - (r1*cos(Theta1) + 1i*r1*sin(Theta1));
    Pole1b = exp(1i * x(1, t)) - (r1*cos(Theta1) - 1i*r1*sin(Theta1));
    Pole2a = exp(1i * x(1, t)) - (r2*cos(Theta2) + 1i*r2*sin(Theta2));
    Pole2b = exp(1i * x(1, t)) - (r2*cos(Theta2) - 1i*r2*sin(Theta2));
    
    Zero1 = exp(1i * x(1, t)) - 1;
    Zero2 = exp(1i * x(1, t)) + 1;
%     Zero3a = 
%     Zero3b = 
    
    Poles = (Pole1a * Pole1b * Pole2a * Pole2b);
    Zeros = Zero1^2 * Zero2^2;
    y(1, t) = Zeros / Poles;
end

y = abs(y);
% y2 = abs(y2);

figure;
plot(x, y);
% figure;
% plot(x, y2);




