function [gain] = calculate_gain(temp, time)
% ccd, get the fits given:
% directory, type, temperature and exposure time

bias_1 = ccd('imgA','bias',temp,0);
bias_2 = ccd('imgB','bias',temp,0);

flat_1 = ccd('imgA','flat',temp,time);
flat_2 = ccd('imgB','flat',temp,time);

bias_1_m = mean(bias_1(:));
bias_2_m = mean(bias_2(:));

flat_1_m = mean(flat_1(:));
flat_2_m = mean(flat_2(:));

bias = bias_1 - bias_2;
flat = flat_1 - flat_2;

bias_s = std(bias(:));
flat_s = std(flat(:));

gain = ((flat_1_m + flat_2_m) - (bias_1_m + bias_2_m))/(flat_s^2 + bias_s^2);
