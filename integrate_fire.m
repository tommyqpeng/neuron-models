clear all;
close all;

%%Parameters
R = 10; %MOhm
C = 1; %nF
Vthr = 5; %mV
Vspk = 70; %mV
dt = 1; %ms
V(1) = 0; %initial voltage in mV

%%Time matrix
t = [1:1:1000]; %1000ms = 1sec

% %%Input current - normal
% input = zeros(1, length(t));
% for ind = 10:1:60
%     input(ind) = 1;
% end

%%Input current - sinusoidal
input = ones(1, length(t));
f = 1; %change frequency here
input = sin(2*pi*f/1000*t);

%%Eulers integration loop
for i = 1:length(t)-1
    dv = (input(i)-(V(i)/R))/C;
    if(V(i) < Vthr)
        V(i+1) = V(i) + dv*dt;
    elseif V(i) == 70
        V(i+1) = 0;
    else
        V(i+1) = 70;
    end
end

a = sum(V==70);

figure;
subplot(2,1,1);
plot(t, V);
xlabel('Time in ms');
ylabel('Membrane voltage in mV');
title('Representative plot of membrane voltage as a function of time');
subplot(2,1,2);
plot(t, input);
xlabel('Time in ms');
ylabel('Input current in nA');
title('Input as a function of time');
