function dark_mean = calculate_darkcurrent(time_exp, temp_ccd, dark_threshole,gain)
%data for bias
bias0=ccd('imgA','bias',temp_ccd,0);
bias1=ccd('imgB','bias',temp_ccd,0);
bias2=ccd('imgC','bias',temp_ccd,0);

name = 'dark';
if time_exp == 0
    name = 'bias';
end

dark_exp_0=ccd('imgA',name,temp_ccd,time_exp);
dark_exp_1=ccd('imgB',name,temp_ccd,time_exp);
dark_exp_2=ccd('imgC',name,temp_ccd,time_exp);

%Calculo de Master Bias
master_bias_temp=zeros(size(bias0,1),size(bias0,2),3);
master_bias_temp(:,:,1)=bias0;
master_bias_temp(:,:,2)=bias1;
master_bias_temp(:,:,3)=bias2;
master_bias=median(master_bias_temp,3);

%Mediana exp
image_master=zeros(size(dark_exp_0,1),size(dark_exp_0,2),3);
image_master(:,:,1)=dark_exp_0;
image_master(:,:,2)=dark_exp_1;
image_master(:,:,3)=dark_exp_2;
image_master_exp=median(image_master,3)-master_bias;

%dark_mean = mean(image_master_exp(:))/65535;
histgrama=hist(image_master_exp(:),1:65535);
th = int16(floor(std(histgrama(:))));
dark_threshole = th;
ADU=0:length(histgrama)-1;

dark_mean = gain*sum(histgrama(1:dark_threshole).*ADU(1:dark_threshole))/sum(histgrama(1:dark_threshole));

% plot(histgrama(10:100));
% title(sprintf('Histograma Dark Current %d segundos a %d K',time_exp,temp_ccd))
% xlabel('ADU')
% ylabel('frecuencia')
% print(gcf,'-dpsc2',sprintf('../img/dark_hist_%d_%d.eps',time_exp,temp_ccd))
