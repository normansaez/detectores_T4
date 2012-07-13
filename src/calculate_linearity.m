function [imgs] = calculate_linearity(temp, times)
imgs = size(times);

index = 1;
for time=times
    img = ccd('imgA','flat',temp,time);
    imgs(index) = mean(img(:));
    index = index +1;
end

%[a,b,c] = polyfit(times,imgs,2);