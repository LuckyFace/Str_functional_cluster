% spatial correlation analysis
% 2019. S Min, JH Shin
clear; close all;

%%
load('./\Tot_fon.mat')
load('./\center.mat')
load('./\color_set.mat')
Mousename = {'WT7','WT11','WT13','D1-4','D1-5','D1-6','D1-7','D1-9','A2a-5','A2a-6','A2a-7','A2a-8','A2a-11'};
%%
fHandle = figure('PaperUnits','centimeters','PaperPosition',[0 0 17.4 17.4],'Renderer','Painters');
for k=1:8    
for i=1:13
disp(Mousename{i});
Cell_num = length(Cue{i,1});
loc_mat = zeros(Cell_num,1);
pp_bool = zeros(Cell_num,1);
coef_matT = zeros(Cell_num,1);
% pp_bool = Cue{i,1}(:,3);
 coef_matT(:,1) = Cue{i,1}(:,4);
 coef_matT(:,2) = Outcome{i,1}(:,6);
 coef_matT(:,3) = Prevrew{i,1}(:,8);
 coef_matT(:,4) = Prevval{i,1}(:,8);
 coef_matT(:,5) = Lick{i,1}(:,8);
 % RPE has been excluded.

center = center_t{i,1};
for ii = 1:Cell_num 
    temp = center(ii,:);
    loc_mat(ii) = temp(1) + 1i*temp(2);
end

coef_mat = coef_matT(:,k);
[xx_temp,yy_temp] = meshgrid(coef_mat,coef_mat);
coef_diff_all = abs(xx_temp-yy_temp);
coef_diff_all(coef_diff_all==0) = nan;
chance_lev = nanmean(coef_diff_all(:));
%% Nearest distance
near_dist = zeros(Cell_num,1);
for ii = 1:Cell_num
    dist_temp = abs(loc_mat-loc_mat(ii));
    dist_temp(ii) = [];
    near_dist(ii) = min(dist_temp);
end
% figure
% histogram(near_dist)
% xlabel('cortical distance')

%% Local clustering
NN = 40;
sample_unit = 3;
mean_coef = zeros(NN,1);
std_coef = zeros(NN,1);
coef_mat_rand = coef_mat(randperm(size(coef_mat,1)));
xmargin = [min(center(:,1)) max(center(:,1))];
ymargin = [min(center(:,2)) max(center(:,2))];
for ss = 1:NN
    coef_list = [];
    coef_list_rand = [];
    sample_size = sample_unit*ss;
%   % only cells within the boundary
%   xmargin_temp = [xmargin(1)+sample_size xmargin(2)-sample_size];
%   ymargin_temp = [ymargin(1)+sample_size ymargin(2)-sample_size];
%   cell_temp = center(:,1) >= xmargin_temp(1) & center(:,1) <= xmargin_temp(2) & center(:,2) >= ymargin_temp(1) & center(:,2) <= ymargin_temp(2);
%   loc_mat_in = loc_mat(cell_temp);
%   coef_mat_in = coef_mat(cell_temp);
    for ii = 1:Cell_num
        dist_temp = abs(loc_mat-loc_mat(ii));
        coef_temp = abs(coef_mat-coef_mat(ii));
        dist_temp(ii) = [];
        coef_temp(ii) = [];
        if sum(dist_temp<sample_size) > 5
        coef_list = [coef_list; coef_temp(dist_temp<sample_size)];
        else
        end
    end
    mean_coef(ss) = nanmean(coef_list);
    std_coef(ss) = nanstd(coef_list);
end
Local_clust_index = -sum(mean_coef-chance_lev);


%%% control
mean_coef_rand = zeros(1000,NN);
std_coef_rand = zeros(1000,NN);
for kk = 1:1000
    coef_mat_rand = coef_mat(randperm(size(coef_mat,1)));
    for ss = 1:NN
        coef_list = [];
        coef_list_rand = [];
        sample_size = sample_unit*ss;
        for ii = 1:Cell_num
            dist_temp = abs(loc_mat-loc_mat(ii));
            coef_temp_rand = abs(coef_mat_rand-coef_mat_rand(ii));
            dist_temp(ii) = [];
            coef_temp_rand(ii)= [];
            coef_list_rand = [coef_list_rand; coef_temp_rand(dist_temp<sample_size)];
        end
%         mean_coef(ss) = mean(coef_list);
%         std_coef(ss) = std(coef_list);
        mean_coef_rand(kk,ss) = mean(coef_list_rand);
        std_coef_rand(kk,ss) = std(coef_list_rand);
    end
end
Local_clust_index_cont = -sum(mean_coef_rand-chance_lev);
[rr, pp] = ttest(Local_clust_index_cont,Local_clust_index);

 Spcor{i,1} = chance_lev;
 Spcor{i,2} = mean_coef_rand;
 Spcor{i,3} = Local_clust_index_cont;
 Spcor{i,4} = mean_coef;
 Spcor{i,5} = Local_clust_index;
 Spcor{i,6} = pp;
 
end
  T_spcor{k,1} = Spcor;
  Spcor=[];
end


