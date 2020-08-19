% Filtering with gaussian kernel followed by autocorrelation
% 2019. JH Shin

clear;
close all;

load('./\Tot_fon.mat')
load('./\center.mat')
load('./\rbcmap.mat')
load('./\color_set.mat')
for session=1:13
 neuron_no = length(center_t{session});   
loc_mat = zeros(neuron_no,1);
pp_bool = zeros(neuron_no,1);
coef_mat = zeros(neuron_no,1);
Val = Cue{session};
cent = center_t{session};
for ii = 1:neuron_no
    loc_mat(ii,:) = cent(ii,1) + 1i*cent(ii,2);
    
    pp_bool(ii) = Val(ii,3);
    coef_mat(ii) = Val(ii,4);
end
coef_list = coef_mat;

%%
% figure
% scatter(real(loc_mat),imag(loc_mat),10,coef_mat,'filled')
% colormap(rbcmap);
% caxis([-0.5 0.5])
% axis xy image

%%
[xx,yy] = meshgrid(min(real(loc_mat)):(max(real(loc_mat))+5),min(imag(loc_mat)):(max(imag(loc_mat))+5));
xy_field = xx+1i*yy;



max_coef = max(abs(coef_list));
norm_coef = coef_list/max_coef;
rad_coef = norm_coef*pi/2;
comp_coef = exp(1i*rad_coef);

coef_map = zeros(size(xy_field));
smooth_sig = 6; %% filter size
for vv = 1:length(loc_mat)
    Pos_temp = loc_mat(vv);
    amp = comp_coef(vv);
    rr_temp = abs(xy_field-Pos_temp);
    gau_kernal = exp(-(rr_temp.^2)/(2*(smooth_sig^2)));
    gau_kernal = gau_kernal/sum(gau_kernal(:));
    aniso_temp = amp*gau_kernal;
    coef_map = coef_map + aniso_temp;
end
coef_map = angle(coef_map);
coef_map = coef_map*2/pi;
coef_map = coef_map*max_coef;

figure
imagesc(coef_map)
axis xy image
colormap(rbcmap);
caxis([-0.5 0.5])
xx = real(loc_mat)-min(real(loc_mat));
yy = imag(loc_mat)-min(imag(loc_mat));

hold on
scatter(xx,yy,10,coef_mat,'filled')
colormap(rbcmap);
caxis([-0.5 0.5])
axis xy image

%%
cross_corr = xcorr2(coef_map,coef_map);
norm_cross_corr = cross_corr/max(cross_corr(:));


%%
iter_num = 1000;
coef_map_cont = zeros(size(coef_map,1),size(coef_map,2),iter_num);
norm_cross_corr_cont = zeros(size(cross_corr,1),size(cross_corr,2),iter_num);
for iter = 1:iter_num
    
    [xx,yy] = meshgrid(min(real(loc_mat)):(max(real(loc_mat))+5),min(imag(loc_mat)):(max(imag(loc_mat))+5));
    xy_field = xx+1i*yy;


    permute_coef_list = coef_list;
    permute_coef_list = permute_coef_list(randperm(size(permute_coef_list,1)));

    
    max_coef = max(abs(permute_coef_list));
    norm_coef = permute_coef_list/max_coef;
    rad_coef = norm_coef*pi/2;
    comp_coef = exp(1i*rad_coef);
    
    coef_map_temp = zeros(size(xy_field));
    smooth_sig = 6; %% filter size
    for vv = 1:length(loc_mat)
        Pos_temp = loc_mat(vv);
        amp = comp_coef(vv);
        rr_temp = abs(xy_field-Pos_temp);
        gau_kernal = exp(-(rr_temp.^2)/(2*(smooth_sig^2)));
        gau_kernal = gau_kernal/sum(gau_kernal(:));
        aniso_temp = amp*gau_kernal;
        coef_map_temp = coef_map_temp + aniso_temp;
    end
    coef_map_temp = angle(coef_map_temp);
    coef_map_temp = coef_map_temp*2/pi;
    coef_map_temp = coef_map_temp*max_coef;
    coef_map_cont(:,:,iter) = coef_map_temp;
    
    cross_corr_temp = xcorr2(coef_map_temp,coef_map_temp);
    norm_cross_corr_temp = cross_corr_temp/max(cross_corr_temp(:));
    norm_cross_corr_cont(:,:,iter) = norm_cross_corr_temp;
end

%%
P_val_temp = norm_cross_corr_cont > repmat(norm_cross_corr,[1,1,iter_num]);
P_val = sum(P_val_temp,3)/iter_num;
sig_val = P_val<0.05;
figure
subplot(1,2,1)
imagesc(P_val)
axis xy image
subplot(1,2,2)
imagesc(sig_val)
axis xy image
%%
figure
imagesc(norm_cross_corr)
axis xy image
colormap(hot)
hold on
contour(sig_val,[1 1])
axis xy image

    
end
    
    

