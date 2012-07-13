function [readoutnoise] = calculate_readout(gain, temp)
% ccd, get the fits given:
% directory, type, temperature and exposure time

bias_1 = ccd('imgA','bias',temp,0);
bias_2 = ccd('imgB','bias',temp,0);

bias = bias_1 - bias_2;

bias_s = std(bias(:));

readoutnoise = (gain*bias_s) / sqrt(2);
