%%Constants
C = 1; %microF/cm^2
el = -61; %mV
ek = -77; %mV
ena = 55; %mV
gl = 0.3; %mS/cm^2
gk = 36; %mS/cm^2
gna = 120; %mS/cm^2
V(1) = -65; %mV

%%calculating the initial values for the parameters
h(1) = (0.07*exp((-65-V(1))/20))/(0.07*exp((-65-V(1))/20) + (1/(exp(((-65-V(1))+30)/10)+1)));
m(1) = ((0.1*((-65-V(1))+25))/(exp(((-65-V(1))+25)/10)-1)) / (4*exp((-65-V(1))/18) + ((0.1*((-65-V(1))+25))/(exp(((-65-V(1))+25)/10)-1)));
n(1) = ((0.01*((-65-V(1))+10))/(exp(((-65-V(1))+10)/10)-1)) / (0.125*exp((-65-V(1))/80) + ((0.01*((-65-V(1))+10))/(exp(((-65-V(1))+10)/10)-1)));

%%Euler's method parameters
dt = 0.001;
t = 0:dt:50; %change the bounds for different time
t_plot = 0:dt:50-dt; %special array for plotting purposes only

I = randn(1, length(t));
%%Change the input here
for i = 2:1:50000
    I(i) = I(i) + 20; %units 0.01nA
end
% for i = 14000:1:14500 %%Second input for refractory study
%     I(i) = 32;
% end

for i = 1:length(t)-1
    %%Equations
an = (0.01*((-65-V(i))+10))/(exp(((-65-V(i))+10)/10)-1);
bn = 0.125*exp((-65-V(i))/80);
am = (0.1*((-65-V(i))+25))/(exp(((-65-V(i))+25)/10)-1);
bm = 4*exp((-65-V(i))/18);
ah = 0.07*exp((-65-V(i))/20);
bh = 1/(exp(((-65-V(i))+30)/10)+1);

dn = (an*(1-n(i)) - bn*n(i))*dt;
dm = (am*(1-m(i)) - bm*m(i))*dt;
dh = (ah*(1-h(i)) - bh*h(i))*dt;

n(i+1) = n(i) + dn;
m(i+1) = m(i) + dm;
h(i+1) = h(i) + dh;

gk_(i) = gk*n(i)^4;
%gna_(i) = gna*m(i)^3*h(i); %normal
gna_n(i) = gna*(0.89-1.1*n(i))*(am/(am+bm))^3; %reduced
gl_(i) = gl;

%Ina(i) = gna_(i)*(V(i) - ena); %normal
Ina(i) = gna_n(i)*(V(i) - ena); %reduced
Ik(i) = gk_(i)*(V(i) - ek);
Il(i) = gl_(i)*(V(i) - el);

dv = ((I(i) - (Ik(i) + Ina(i) + Il(i)))/C)*dt;
V(i+1) = (V(i)) + dv;
end

%%plot data
figure(1);
plot(t, h);
hold on;
plot(t, m, 'r');
plot(t, n, 'k');
legend('h', 'm', 'n');
title('Evolution of HH variables m, n, h following an action potential');
xlabel('Time in ms');
ylabel('Value');

figure(2);
plot(t_plot, gna_n);
hold on;
plot(t_plot, gk_, 'r');
legend('gna', 'gk');
title('Evolution of gk and gna following an action potential');
xlabel('Time in ms');
ylabel('Conductance in mS/cm^2');

figure(3);
plot(t_plot, Ina);
hold on;
plot(t_plot, Ik, 'r');
plot(t_plot, Il, 'k');
legend('Ina', 'Ik', 'Il');
title('Evolution of currents following an action potential');
xlabel('Time in ms');
ylabel('Current in nA');

figure(4);
plot(t, V, 'r');
title('Evolution of Membrane potential during action potential');
xlabel('Time in ms');
ylabel('Membrane potential in mV');