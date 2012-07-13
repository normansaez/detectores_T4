function [readout] = calculate_readout_m2(temp)
% ccd, get the fits given:
% directory, type, temperature and exposure time

bias_1 = ccd('imgA','bias',temp,0);
bias_2 = ccd('imgB','bias',temp,0);
bias_3 = ccd('imgC','bias',temp,0);

master_bias_temp=zeros(size(bias_1,1),size(bias_2,2),3);
master_bias_temp(:,:,1)=bias_1;
master_bias_temp(:,:,2)=bias_2;
master_bias_temp(:,:,3)=bias_3;
master_bias=median(master_bias_temp,3);
readout = std(master_bias(:));
