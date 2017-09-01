clear all;
close all;

%%Parameters
C = 1; %nF
R = 10; %MOhms
Vrest = 0; %mV
Vspk = 70; %mV
t_thresh = 50; %ms
E_inh = -15; %mV
t_syn = 15; %ms
g_peak = 0.1; %us
T_max = 1500; %ms
dt = 1; %ms
E_syn = E_inh; %given in question
V_1(1) = 0; %starting potential
V_2(1) = 0; %starting potential
g_1(1) = 0;
g_2(1) = 0;
E_1(1) = 0;
E_2(1) = 0;
theta_1(1) = 0;
theta_2(1) = 0;
z_1(1) = 0;
z_2(1) = 0;
g_1(1) = 0;
g_2(1) = 0;

%%Time array
t = [1:dt:T_max];

%%Input array
I_1 = 1.1*ones(1, T_max);
I_2 = 0.9*ones(1, T_max);

%%Euler integration loop
for i = 2:1:length(t)
    
    %threshold update
    d_theta_1 = (-theta_1(i-1) + V_1(i-1)) / t_thresh;
    d_theta_2 = (-theta_2(i-1) + V_2(i-1)) / t_thresh;
    theta_1(i) = theta_1(i-1) + d_theta_1*dt;
    theta_2(i) = theta_2(i-1) + d_theta_2*dt;
    
    %condutance update 1
    u_1 = (V_1(i-1) == Vspk);
    u_2 = (V_2(i-1) == Vspk);
    dz_1 = (-z_1(i-1) / t_syn) + (g_peak / (t_syn / exp(1))) * u_2;
    dz_2 = (-z_2(i-1) / t_syn) + (g_peak / (t_syn / exp(1))) * u_1;
    z_1(i) = z_1(i-1) + dz_1*dt;
    z_2(i) = z_2(i-1) + dz_2*dt;
    
    %conductance update 2
    dg_1 = (-g_1(i-1) / t_syn) + z_1(i-1);
    dg_2 = (-g_2(i-1) / t_syn) + z_2(i-1);
    g_1(i) = g_1(i-1) + dg_1*dt;
    g_2(i) = g_2(i-1) + dg_2*dt;
    
    %voltage update
    if V_1(i-1) == Vspk;
        V_1(i) = E_inh;
    else
        dv_1 = ((-V_1(i-1) / R) - g_1(i-1) * (V_1(i-1) - E_inh) + I_1(i-1))/C;
        V_1(i) = V_1(i-1) + dv_1*dt;
    end
    
    %pass threshold check
    if V_1(i) >= theta_1(i)
        V_1(i) = Vspk;
    end
   
    %voltage update
    if V_2(i-1) == Vspk;
        V_2(i) = E_inh;
    else
        dv_2 = ((-V_2(i-1) / R) - g_2(i-1) * (V_2(i-1) - E_inh) + I_2(i-1))/C;
        V_2(i) = V_2(i-1) + dv_2*dt;
    end
    
    %pass threshold check
    if V_2(i) >= theta_2(i)
        V_2(i) = Vspk;
    end

end

subplot(2,1,1)
plot(t, V_1);
hold on;
plot(t, theta_1, 'r');
title('Firing response of first neuron');
xlabel('Time in ms');
ylabel('Membrane potential in mV');
legend('Firing response', 'Membrane threshold');
subplot(2,1,2);
plot(t, V_2);
hold on;
plot(t, theta_2, 'r');
title('Firing response of second neuron');
xlabel('Time in ms');
ylabel('Membrane potential in mV');
legend('Firing response', 'Membrane threshold');
