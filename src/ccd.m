function [fits] = ccd(img_collection,img_type, temp, exp_time)
filepath = fullfile('..',img_collection,sprintf('%s_T_%d_E_%d_0001.fits',img_type,temp,exp_time));
fits = fitsread(filepath);