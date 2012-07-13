%% Tarea N3 Detectores para Astronomia
%
% mailto: nfsaez@uc.cl
tic;
close all;
clear all;
clc;
%% Gain
disp('Gain')
gain = calculate_gain(278,3000);
disp(sprintf('Calculated Gain: %f ',gain))
%% Readout Noise
disp('Read Out Noise')
readoutnoise = calculate_readout(gain, 278);
disp(sprintf('Calculated Read Out Noise: %f ',readoutnoise))

readoutnoise = calculate_readout_m2(278);
disp(sprintf('Calculated Read Out Noise Method 2: %f ',readoutnoise))

%% Full Well
disp('Full Well')
full_well = calculate_fullwell(gain,16);
disp(sprintf('Calculated full well: %f ',full_well))

%% PTC: Photon Transfer Curve
disp('Photon Transfer Curve')
[mean_vector,var_vector, k_vector] = calculate_convertion_factor(278);
figure, loglog(mean_vector,var_vector)
grid on;
xlabel('mean');
ylabel('sigma^2');
title('mean v/s sigma^2');
print(gcf,'-dpsc2','../img/mean_vs_sigma_log.eps');
%close;

%% Linearity
disp('Linearity')
times =[0,600,1200,1800,2400,3000,9000,15000,21000];
[mean_vector] = calculate_linearity(278,times);
plot(times,mean_vector);
P = polyfit(times,mean_vector,2);
disp(sprintf('ax^2+bx+c: a= %f , b=%f, c= %f ', P(1) , P(2) , P(3)))
grid on;
xlabel('times [secs]');
ylabel('mean');
title('time v/s mean');
print(gcf,'-dpsc2','../img/time_vs_mean.eps');
%close;

%% Dark Current v/s Temperature
disp('Dark Current v/s Temperature')
temps = 278:1:289;
times =[0,600,1200,1800,2400,3000,9000,15000,21000];
for exp_time=times
    d = size(1,length(temps));
    count = 1;
    for temp=temps
        %disp(sprintf('Calculating Dark for time: %d temperature:%d',exp_time,temp))
        darks = calculate_darkcurrent(exp_time, temp,40,gain);
        d(count) = darks;
        count = count + 1;
    end
    plot(temps,d);
    set(gca,'XDir','reverse');
    grid on
    title(sprintf('Dark Current v/s Temperatura. Tiempo exposicion %d [msec]',exp_time));
    xlabel('Temperatura K')
    ylabel('Dark Current e/pix/sec')
    print(gcf,'-dpsc2',sprintf('../img/dark_vs_temp_t_%d.eps',exp_time))
    close all;
end

%% Silicon Band Gap
disp('Silicon Band Gap')
Eg_experimental = zeros(size(temps));
Eg_emp = zeros(size(temps));
index = 1;
k = 8.62*10^(-5);
C = 1/(273^(1.5)*exp(-1.1166/(2*k*273)));
C = 5.5052e+06;
exp_time = 21000;
for temp=temps
    Eg_emp(index) = 1.1557-((7.021*10^(-4)*temp^2)/(1108+temp));
    Eg_experimental(index) = -2*k*temp*log(calculate_darkcurrent(exp_time,temp,40,gain)/(C*temp^(1.5)));
    index = index + 1;
end
disp(sprintf('Silicon BandGap: %f +- %f',mean(Eg_experimental(:)), std(Eg_experimental(:))))
figure, plot(temps,Eg_experimental);
grid on
title(sprintf('BandGap (eV) v/s Temperatura K [Experimental]'));
xlabel('Temperatura K')
ylabel('BandGap (eV)')
print(gcf,'-dpsc2',sprintf('../img/bandgap_vs_temp_t_%d_exp.eps',exp_time))

figure, plot(temps,Eg_emp);
grid on
title(sprintf('BandGap (eV) v/s Temperatura K [Empirica]'));
xlabel('Temperatura K')
ylabel('BandGap (eV)')
print(gcf,'-dpsc2',sprintf('../img/bandgap_vs_temp_t_%d_emp.eps',exp_time))
%% Time taken
totaltime = toc;
str = sprintf('\nTotal time taken %.2f[min] or  %.2f [sec]', totaltime/60, totaltime);
disp(str)