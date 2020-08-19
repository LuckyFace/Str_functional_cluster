%Behavior clustering
%2019 JH Shin

clear; close all

for session=1:13
 % 2019.1.15. Deeplabcut 
 
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
load('./Neuron_z.mat');

thlocstr = thlocstr1;
thlocend = thlocend1;


% Where is it implanted? Based on contralateral turn activity.
% WT7 : Left , WT11 : Left, WT13 : Left
% D1_4 : Right, D1_5 : Right D1_6 : Right D1_7 : Left
% A2a5 : Right, A2a_6 : Left, A2a_7 : Right A2a_8 : Left

for b1=2:length(thlocstr)
    Cvf{b1,1} = Cv10(thlocstr(b1)-20:thlocstr(b1)+20)';
    Cvf2{b1,1} = Cv(thlocstr(b1)-20:thlocstr(b1)+20)';
end

for b1=2:length(thstopstr)
    Cvsf{b1,1} = Cv10(thstopstr(b1)-20:thstopstr(b1)+20)';
    Cvsf2{b1,1} = Cv(thstopstr(b1)-20:thstopstr(b1)+20)';
end

x=1;y=1;
for b1=2:length(thstart)
     if thangle(b1) < 0
    angle{x,1} = ncanglev(thstart(b1)-20:thstart(b1)+20)';
    x=x+1;
     else
    angle2{y,1} = ncanglev(thstart(b1)-20:thstart(b1)+20)';
    y=y+1;
     end
end
TB(session,1) = {Cvf2(2:end)};TB(session,2) = {Cvsf2(2:end)};TB(session,3) = {angle(2:end)};TB(session,4) = {angle2(2:end)};
Cvf2=[];Cvsf2=[];angle=[];angle2=[];

for j=1:length(Ff_2)
k=1;
for i=1:size(Ff_2,2)       
   if length(Ff_2{j,i})>40
    min = 40;
    F_2(k,:) = Ff_2{j,i}(1:40);
    TF_2{j,1} = (F_2); 
    mtempt(k,:)= repmat(meantrace(j),1,min);    
    TF_2{j,2} = mtempt;
    TF_2{j,3} = F_2/meantrace(j);
    k=k+1;
   else
   end
end
end
TTF_2(session,1) = {TF_2(:,1)};
TTF_2(session,2) = {TF_2(:,2)};
TTF_2(session,3) = {TF_2(:,3)};
mtempt=[];

for j=1:length(Ff_22)
k=1;
for i=1:size(Ff_22,2)       
   if length(Ff_22{j,i})>1
    F(k,:) = Ff_22{j,i}(1:60);
    TF{j,1} = (F);    
    mtempt(k,:)= repmat(meantrace(j),1,min);    
    TF{j,2} = mtempt;
    TF{j,3} = F/meantrace(j);
    k=k+1;
   else
   end
end
end
TTF(session,1) = {TF(:,1)};
TTF(session,2) = {TF(:,2)};
TTF(session,3) = {TF(:,3)};
mtempt=[];

for j=1:length(Afl_2)
k=1;
for i=1:size(Afl_2,2)       
   if length(Afl_2{j,i})>40
    min = 40;
    Fl_2(k,:) = Afl_2{j,i}(1:min);
    TFl_2{j,1} = Fl_2;
    mtempt(k,:)= repmat(meantrace(j),1,min);    
    TFl_2{j,2} = mtempt;
    TFl_2{j,3} = Fl_2/meantrace(j);
    k=k+1;
   else
   end
end
end
TTFl(session,1) = {TFl_2(:,1)};
TTFl(session,2) = {TFl_2(:,2)};
TTFl(session,3) = {TFl_2(:,3)};


mtempt=[];

for j=1:length(Afr_2)
k=1;
for i=1:size(Afr_2,2)       
   if length(Afr_2{j,i})>40
    min = 40;
    Fr_2(k,:) = Afr_2{j,i}(1:min);
    TFr_2{j,1} = Fr_2;
    mtempt(k,:)= repmat(meantrace(j),1,min);    
    TFr_2{j,2} = mtempt;
    TFr_2{j,3} = Fr_2/meantrace(j);
    k=k+1;
   else
   end
end
end
TTFr(session,1) = {TFr_2(:,1)};
TTFr(session,2) = {TFr_2(:,2)};
TTFr(session,3) = {TFr_2(:,3)};



mtempt2=[];

% % Where is it implanted? Based on contralateral turn activity.
% % WT7 : Left , WT11 : Left, WT13 : Left
% % D1_4 : Right, D1_5 : Right D1_6 : Right D1_7 : Left D1_9 : Left
% % A2a5 : Right, A2a_6 : Left, A2a_7 : Right A2a_8 : Left A2a_11 : Right

 ctrind = [1 1 1 2 2 2 1 1 2 1 2 1 2];
if ctrind(session) > 1
  TTFCtr(session,1) = {TFl_2};
  TTFIps(session,1) = {TFr_2};
else    
  TTFCtr(session,1) = {TFr_2};
  TTFIps(session,1) = {TFl_2};
end

for j=1:length(Sf_2)
k=1;
for i=1:size(Sf_2,2)       
   if length(Sf_2{j,i})>40
    min = 40;
    S_2(k,:) = Sf_2{j,i}(1:min);
    TS_2{j,1} = S_2;    
    mtempt(k,:)= repmat(meantrace(j),1,min);    
    TS_2{j,2} = mtempt;
    TS_2{j,3} = S_2/meantrace(j);
    k=k+1;
   else
   end
end
end
TTS(session,1) = {TS_2(:,1)};
TTS(session,2) = {TS_2(:,2)};
TTS(session,3) = {TS_2(:,3)};
mtempt=[];

clear F TF Ff_2 F_2 TF_2 Sf_2 S_2 TS_2 Afl_2 Fl_2 TFl_2 Afr_2 Fr_2 TFr_2
end

% saved file: Tot_behav_2.5.mat