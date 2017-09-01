%%loading the files
load spikes.txt;
load stimulus.txt;

%%normalizing the stimulus
stimulus = round(stimulus*10); %%scaling  the stimulus to be rounded later
stimulus_n = zeros(1,200000); %20 seconds of data, at resolution of 0.0001, going to round due to the resolution of response being lower
for i = 1:1:length(stimulus)
    for j = stimulus(i):1:stimulus(i,2)
        stimulus_n(j) = 1;
    end
end

%%seperating the trials and normalizing
trial_1 = round(10000*spikes(spikes>0 & spikes<20));
trial_2 = round(10000*(spikes(spikes>20 & spikes<40)-20));
trial_3 = round(10000*(spikes(spikes>40 & spikes<60)-40));
trial_4 = round(10000*(spikes(spikes>60 & spikes<80)-60));
trial_5 = round(10000*(spikes(spikes>80 & spikes<100)-80));
trial_1_n = zeros(1,200000); %20 seconds of data, at resolution of 0.0001
trial_2_n = zeros(1,200000);
trial_3_n = zeros(1,200000);
trial_4_n = zeros(1,200000);
trial_5_n = zeros(1,200000);
for i = 1:1:length(trial_1)
    trial_1_n(trial_1(i)) = 1;
end
for i = 1:1:length(trial_2)
    trial_2_n(trial_2(i)) = 1;
end
for i = 1:1:length(trial_3)
    trial_3_n(trial_3(i)) = 1;
end
for i = 1:1:length(trial_4)
    trial_4_n(trial_4(i)) = 1;
end
for i = 1:1:length(trial_5)
    trial_5_n(trial_5(i)) = 1;
end

%plots stimulus and then spikes
subplot(5,1,1)
area(stimulus_n);
title('Stimulus plot');
xlabel('Time in 0.1 ms');
ylabel('On/off of stimulus (1=on, 0=off)');
hold all;
subplot(5,1,2);
plot(trial_1_n);
title('First trial response');
xlabel('Time in 0.1 ms');
ylabel('Spike response (1=spike, 0=no spike');
subplot(5,1,3);
plot(trial_2_n);
title('Second trial response');
xlabel('Time in 0.1 ms');
ylabel('Spike response (1=spike, 0=no spike');
subplot(5,1,4);
plot(trial_3_n);
title('Third trial response');
xlabel('Time in 0.1 ms');
ylabel('Spike response (1=spike, 0=no spike');
subplot(5,1,5);
plot(trial_4_n);
title('Forth trial response');
xlabel('Time in 0.1 ms');
ylabel('Spike response (1=spike, 0=no spike');

%%seperate the data into bins (100ms = 1000*0.1ms)
s_bin = [];
s_end_ind = 20000; %%starting bin ends at 2secs
while (s_end_ind < length(stimulus_n)) 
    s_bin = [s_bin; stimulus_n(s_end_ind-19999:s_end_ind)];
    s_end_ind = s_end_ind + 1000;
end
t1_bin = [];
t1_ind = 20000;
while (t1_ind < length(trial_1_n)) 
    t1_bin = [t1_bin; sum(trial_1_n(t1_ind-1000:t1_ind))];
    t1_ind = t1_ind + 1000;
end
t2_bin = [];
t2_ind = 20000;
while (t2_ind < length(trial_2_n)) 
    t2_bin = [t2_bin; sum(trial_2_n(t2_ind-1000:t2_ind))];
    t2_ind = t2_ind + 1000;
end
t3_bin = [];
t3_ind = 20000;
while (t3_ind < length(trial_3_n)) 
    t3_bin = [t3_bin; sum(trial_3_n(t3_ind-1000:t3_ind))];
    t3_ind = t3_ind + 1000;
end
t4_bin = [];
t4_ind = 20000;
while (t4_ind < length(trial_4_n)) 
    t4_bin = [t4_bin; sum(trial_4_n(t4_ind-1000:t4_ind))];
    t4_ind = t4_ind + 1000;
end

t_bin = t1_bin + t2_bin + t3_bin + t4_bin;
t_bin = t_bin/4; %average it

%%psuedoinverse calculation
w = pinv(s_bin)*t_bin;
r = s_bin*w;
r = r';
r_x = [21000:1000:200000];

%%plotting
figure;
plot(r_x, r, 'r');
hold on;
t5_bin = [];
t5_ind = 20000;
while (t5_ind < length(trial_5_n)) 
    t5_bin = [t5_bin; sum(trial_5_n(t5_ind-1000:t5_ind))];
    t5_ind = t5_ind + 1000;
end
plot(r_x, t5_bin);
legend('Predicted by model', 'Actual firing rate');
xlabel('Time in 0.1ms');
ylabel('Number of spikes in the 100ms bin');
title('Model response plotted against the fifth trial');