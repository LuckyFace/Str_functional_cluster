% characterization of prior behavior
% 각각 behavior cluster가 전에 어떤 cluster로 시작되었는지 파악하는 code
% Behavioral clustering analysis
% 1-> Forward, 2-> Left, 3-> Right, 4-> Back, 5-> Stop, 6,7 -> others
% 2019.1.15. JH Shin
clear; close all;
n=1;
for session=1:13
 
load('./\color_set.mat')

Maindir(1,1) = {'./\Animal data\WT\WT7\'};
Maindir(1,2) = {'./\Animal data\WT\WT11\'};
Maindir(1,3) = {'./\Animal data\WT\WT13\'};
    
    % D1
Maindir(1,4) = {'./\Animal data\D1\D1_4\'};%D1_4_7
Maindir(1,5) = {'./\Animal data\D1\D1_5\'};% D1_5_9
Maindir(1,6) = {'./\Animal data\D1\D1_6\'};% D1_6
Maindir(1,7) = {'./\Animal data\D1\D1_7\'};%D1_7
Maindir(1,8) = {'./\Animal data\D1\D1_9\'};%D1_9

% D2 
Maindir(1,9) = {'./\Animal data\A2a\A2a_5\'};%A2a_5
Maindir(1,10) = {'./\Animal data\A2a\A2a_6\'};%A2a_6
Maindir(1,11) = {'./\Animal data\A2a\A2a_7\'};%A2a_7
Maindir(1,12) = {'./\Animal data\A2a\A2a_8\'};%A2a_8
Maindir(1,13) = {'./\Animal data\A2a\A2a_11\'};%A2a_11 
 
dir = char(Maindir(1,session));
cd(dir);
load('./sync_deep_z_mk3.mat');

thlocstr = thlocstr2_5;
thlocend = thlocend2_5;
rs = thstart(thangle>0,:);re = thend(thangle>0,:);
ls = thstart(thangle<0,:);le = thend(thangle<0,:);
end