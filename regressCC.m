% regression analysis of classical conditioning task

clear;clc;close all;

load('./\color_set.mat')
for Trial=1:13
MousenameWT = {'WT7','WT11','WT13',};
MousenameD1 = {'D1-4','D1-5','D1-6','D1-7','D1-9'};
MousenameD2 = {'A2a-5','A2a-6','A2a-7','A2a-8','A2a-11'};

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

dir = char(Maindir(1,Trial));
cd(dir);
disp(dir);
load('./Neuron_z.mat');
load('./Events.mat');


n = length(Neuron);
compreg=[];
compreg_total = [];compreg_total_d = [];compreg_total_s = [];
for trial = 1:n
  
% load lick
winRw = [-1000 7000];
LickTime = spikeWin(lickOnsetTime, eventTime(:,1), winRw);
LickTimeRw = spikeWin(lickOnsetTime,rewardLickTime, winRw);

binWindow = 0.1; % s 
binWindow2 = 100; %lick ¿¡ ´ëÇÑ window
binStep = 100;  
[reg_licktime, reg_lick] = spikeBin(LickTime, winRw, binWindow2, binStep);
[reg_licktimer, reg_lickr] = spikeBin(LickTimeRw, winRw, binWindow2, binStep);

% C_raw
df = Neuron{trial,8};
dfr = Neuron{trial,9};
%(:,(find(timer100>-2500 & timer100<3000)));
df_d = Neuron_d{trial,8};
dfr_d = Neuron_d{trial,9};

%mean firing rates_C-raw
%start signal was cue onset.
     valmean = mean(df(:,find(time100 >0 & time100 <1000)),2);
     delmean = mean(df(:,find(time100 >1000 & time100 <2000)),2);     
%      rewmean = mean(df(:,find(time100 >0 & time100 <2000)),2);     
     rewmean = mean(dfr(:,find(timer100>0 & timer100<2000)),2);
     taskmean = mean(df(:,find(time100 >0 & time100 <4000)),2);     
     
%mean firing rates_C
%start signal was cue onset.
     valmean_d = mean(df_d(:,find(time100 >0 & time100 <1000)),2);
     delmean_d = mean(df_d(:,find(time100 >1000 & time100 <2000)),2);     
%      rewmean = mean(df(:,find(time100 >0 & time100 <2000)),2);     
     rewmean_d = mean(dfr_d(:,find(timer100>0 & timer100<2000)),2);
     taskmean_d = mean(df_d(:,find(time100 >0 & time100 <4000)),2);     
     
%mean lick rates
     lickvalmean = mean(reg_lick(:,find(time100 >0 & time100 <1000)),2);
     lickdelmean = mean(reg_lick(:,find(time100 >1000 & time100 <2000)),2); 
     lickrewmean = mean(reg_lickr(:,find(timer100>0 & timer100<2000)),2);
     licktaskmean = mean(reg_lick(:,find(time100 >0 & time100 <4000)),2); 

inRegress1 = (cue==1); 
inRegress2 = (cue==2); 
inRegress3 = (cue==3);
inRegress4 = (cue==1 | cue==2 | cue==3);        
    value1 = inRegress1*0.8;
    value2 = inRegress2*0.2;
    value3 = inRegress3*0.5;
    value = value1 + value2 + value3;     
RRw = (reward==1);
PPn = (reward==0);
% rearranging the variables
bin = size(df,2);
rewardT = repmat(reward,1,size(df,2));
valueT = repmat(value,1,size(df,2));
rewardT2 = repmat((reward*2)-1,1,size(df,2));

% previousreward
prevrewT = repmat(prevrew,1,size(df,2));

% previous cue
prevalueT = repmat(prevalue,1,size(df,2));

% rearranging the variables
value = repmat(value,1,size(reg_lick,2));
Time = time100;%(:,(find(reg_licktime > -0.5 & reg_licktime < 5)));

%% C-raw
%for total outcome evaluation
regT_sCL5 = slideReg80(Time, df, [rewardT valueT reg_lick prevrewT prevalueT]); 
regT_sCL5_Rw = slideReg80(Time, dfr, [rewardT valueT reg_lick prevrewT prevalueT]); 

%for value evaluation
regT_svCL5v = slideReg80([1], valmean, [rewardT(:,1) valueT(:,1) lickvalmean prevrew prevalue]); 
regT_svCL5d = slideReg80([1], delmean, [rewardT(:,1) valueT(:,1) lickdelmean prevrew prevalue]); 
regT_svCL5r = slideReg80([1], rewmean, [rewardT(:,1) valueT(:,1) lickrewmean prevrew prevalue]); 
regT_svCL5t = slideReg80([1], taskmean, [rewardT(:,1) valueT(:,1) licktaskmean prevrew prevalue]); 
regT_value = slideReg80([1], delmean, [valueT(:,1)]);
regT_out = slideReg80([1], rewmean, [rewardT(:,1)]);

%CPD calculation
% value - delay, outcome - reward, prevoutcome - task, prevvalue - task,
% lick - task
regT_svCL5_v = slideReg80([1], delmean, [rewardT(:,1) lickdelmean, prevrew prevalue]); 
regT_svCL5_o = slideReg80([1], rewmean, [valueT(:,1) lickrewmean, prevrew prevalue]); 
regT_svCL5_po = slideReg80([1], taskmean, [rewardT(:,1) valueT(:,1) licktaskmean prevalue]); 
regT_svCL5_pv = slideReg80([1], taskmean, [rewardT(:,1) valueT(:,1) licktaskmean prevrew]); 
regT_svCL5_l = slideReg80([1], taskmean, [rewardT(:,1) valueT(:,1) prevrew prevalue]); 

%Whole CPD calculation
regT_sCL5_v = slideReg80(Time, df, [rewardT reg_lick prevrewT prevalueT]); 
regT_sCL5_o = slideReg80(Time, dfr, [valueT reg_lick prevrewT prevalueT]); 
regT_sCL5_pv = slideReg80(Time, df, [rewardT valueT reg_lick prevrewT]); 
regT_sCL5_po = slideReg80(Time, df, [rewardT valueT reg_lick prevalueT]); 
regT_sCL5_l = slideReg80(Time, df, [rewardT valueT prevrewT prevalueT]); 




%lick pre vs post evaluation
regR_cue = slideReg80([1],valmean(RRw,1),[value(RRw,1) lickvalmean(RRw,1) prevrew(RRw,1)  prevalue(RRw,1)]);
regR_del = slideReg80([1],delmean(RRw,1),[value(RRw,1) lickdelmean(RRw,1) prevrew(RRw,1)  prevalue(RRw,1)]);
regR_rew = slideReg80([1],rewmean(RRw,1),[value(RRw,1) lickrewmean(RRw,1) prevrew(RRw,1)  prevalue(RRw,1)]);

%lick pre vs post evaluation
regP_cue = slideReg80([1],valmean(PPn,1),[value(PPn,1) lickvalmean(PPn,1) prevrew(PPn,1)  prevalueT(PPn,1)]);
regP_del = slideReg80([1],delmean(PPn,1),[value(PPn,1) lickdelmean(PPn,1) prevrew(PPn,1) prevalueT(PPn,1)]);
regP_rew = slideReg80([1],rewmean(PPn,1),[value(PPn,1) lickrewmean(PPn,1) prevrew(PPn,1)  prevalueT(PPn,1)]);


reg_sCL5 = struct('regT_sCL5',regT_sCL5,'regT_sCL5Rw',regT_sCL5_Rw,'regT_svCL5v',regT_svCL5v ,'regT_svCL5d',regT_svCL5d,'regT_svCL5r',regT_svCL5r, ...
    'regT_svCL5t',regT_svCL5t, 'regT_svCL5_v',regT_svCL5_v, 'regT_svCL5_o',regT_svCL5_o,'regT_svCL5_po', regT_svCL5_po, ...
    'regT_svCL5_pv',regT_svCL5_pv,'regT_svCL5_l',regT_svCL5_l, ...
    'regT_sCL5_v',regT_sCL5_v,'regT_sCL5_o',regT_sCL5_o,'regT_sCL5_pv',regT_sCL5_pv, 'regT_sCL5_po',regT_sCL5_po,'regT_sCL5_l',regT_sCL5_l, ...
    'regR_cue',regR_cue,'regR_del',regR_del,'regR_rew',regR_rew', ...
    'regP_cue',regP_cue,'regP_del',regP_del,'regP_rew',regP_rew', 'regT_value',regT_value,'regT_out',regT_out);

compreg_total = [compreg_total;reg_sCL5];
df=[];

end

% save('./regression_z.mat','compreg_total','compreg_total_d','compreg_total_s','reg_licktime');
clear;
end

