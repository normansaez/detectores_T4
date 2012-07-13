function [mean_vector,var_vector, k_vector] = calculate_convertion_factor(temp_ccd)
times =[0,600,1200,1800,2400,3000,9000,15000,21000];
warning off;
k_vector = zeros(size(times+1),1);
mean_vector = zeros(size(times+1),1);
var_vector = zeros(size(times+1),1);
warning on;
gain =1.408932;
index = 1;
for time=times
    if time == 0
        A = ccd('imgA','bias',temp_ccd,time);
        B = ccd('imgB','bias',temp_ccd,time);
    else
        A = ccd('imgA','flat',temp_ccd,time);
        B = ccd('imgB','flat',temp_ccd,time);
    end
    c1 = 423;
    c2 = 481;
    f1 = 224;
    f2 = 278;
    
    A_plus_B = A(f1:f2,c1:c2)+B(f1:f2,c1:c2);
    A_minus_B = A(f1:f2,c1:c2)-B(f1:f2,c1:c2);
    mean_vector(index) = mean(A_plus_B(:));
    var_vector(index) = var(A_minus_B(:));
    k_vector(index) = mean_vector(index)./(var_vector(index).^2);
    
    %str = sprintf('Exposure time: %d, mean: %.2f sigma: %.2f', time,mean_vector(index),std_vector(index));
    %disp(str)
    %figure, imshow(A/65535,[])
    %close;
    index = index + 1;
end



