clear all;
close all;

%%Parameters
a = 0.02;
b = 0.2;
c = -65;
d = 8;
V(1) = -65;
u(1) = b*V(1);
dt = 0.1;

%%Time matrix
t = [1:dt:20]; %0.1ms

%%Input matrix
I = zeros(1, length(t));
for ind = 1:1:length(t)
    I(ind) = 10;
end

%%Eulers integration loop
for i = 1:length(t)-1;
    dv = 0.04*V(i)^2+5*V(i)+140-u(i)+I(i);
    du = a*(b*V(i) - u(i));
    
    if V(i) >= 30
        V(i) = 30;
        V(i+1) = c;
        u(i+1) = u(i) + d;
    else
        V(i+1) = V(i) + dv*dt;
        u(i+1) = u(i) + du*dt;
    end
end

plot(t, V)
xlabel('Time in ms');
ylabel('Potential in mV');
title('Model simulation - E. M. Izhikevich, Simple model of spiking neurons');
