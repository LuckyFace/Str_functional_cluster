clear;clc
% Extraction of video-tracking
% because of the coding issue D1_9 and A2a_11 should be analyzed with
% different code(Behavior_extraction_video_5th_session.mat)

load('./\Behavior_trace.mat');
load('./\color_set.mat')
for session=1:11




Maindir(1,1) = {'./\Animal data\WT\WT7\'};
Maindir(1,2) = {'./\Animal data\WT\WT11\'};
Maindir(1,3) = {'./\Animal data\WT\WT13\'};
    
    % D1
Maindir(1,4) = {'./\Animal data\D1\D1_4\'};%D1_4_7
Maindir(1,5) = {'./\Animal data\D1\D1_5\'};% D1_5_9
Maindir(1,6) = {'./\Animal data\D1\D1_6\'};% D1_6
Maindir(1,7) = {'./\Animal data\D1\D1_7\'};%D1_7

% D2 
Maindir(1,8) = {'./\Animal data\A2a\A2a_5\'};%A2a_5
Maindir(1,9) = {'./\Animal data\A2a\A2a_6\'};%A2a_6
Maindir(1,10) = {'./\Animal data\A2a\A2a_7\'};%A2a_7
Maindir(1,11) = {'./\Animal data\A2a\A2a_8\'};%A2a_8

 

dir = char(Maindir(1,session));
cd(dir);
nCol = 1;
nrow = 2;
% Merge video tracking data
% Center of the body
% load video tracking data
% load('./VT1.smi')
smiFile = FindFiles('smimat.mat','CheckSubdirs',0);
load(smiFile{1});
eventString = smimat;
for i=1:length(eventString)-2
   smi(i,:) = sscanf(eventString{i,1},'<SYNC Start=%f><P Class=ENUSCC>%f');
end
%load event data
eventFile = FindFiles('Events_video.nev','CheckSubdirs',0);
[timeStamp, eventString] = Nlx2MatEV(eventFile{1}, [1 0 0 0 1], 0, 1, []);
if ismember(session,[1,2,3]) == 0    
sync = timeStamp(strcmp(eventString, 'start')); % D1 and A2a
else 
sync = timeStamp(strcmp(eventString, 'Non-reward')); 
end
synctime = smi(find(histc(sync,smi(:,2))==1),1)/1000;

%load ethovision analysis
xFile = FindFiles('Raw*.xlsx','CheckSubdirs',0); % Video_trace from deeplabcut
xlsFile = xlsread(xFile{1});

% in case of D1_7 refine to 8min_

% ratio correction - x and y axis
ratx = (max((Deeptrace{session,1}(:,11)))-min((Deeptrace{session,1}(:,11))))/(max(xlsFile(:,3))-min(xlsFile(:,3)));
raty = (max((Deeptrace{session,1}(:,12)))-min((Deeptrace{session,1}(:,12))))/(max(xlsFile(:,4))-min(xlsFile(:,4)));
Dtrace = Deeptrace{session,1};
Dtrace(:,[2 5 8 11]) = Dtrace(:,[2 5 8 11])/ratx;
Dtrace(:,[3 6 9 12]) = Dtrace(:,[3 6 9 12])/raty;
% calculate distance and velocity
for i=1:length(Dtrace)
    T(i,1) = Dtrace(i,2) + 1i*Dtrace(i,3);
    C(i,1) = Dtrace(i,11) + 1i*Dtrace(i,12);
    C_etho(i,1) = xlsFile(i,3) + 1i*xlsFile(i,4);
    RN(i,1) = Dtrace(i,5) + 1i*Dtrace(i,6);
    N(i,1) = Dtrace(i,8) + 1i*Dtrace(i,9);
    F(i,1) = Dtrace(i,1);
end  
 Tv = abs(diff(T));Cv = abs(diff(C));Nv = abs(diff(N));Cv_e = abs(diff(C_etho));
 ct = T-C;cn = N-C;
%  cn = flipud(cn);
 %nctangle = (wrapTo360(rad2deg(angle(ct))) - wrapTo360(rad2deg(angle(cn)))); %N-C-T angle
 %mcangle = wrapTo360(rad2deg(angle(cm))); %Absolute M-C angle 
 ncangle = wrapTo360(rad2deg(angle(cn))); %Absolute N-C angle 
 ncanglev = diff(ncangle);
 ncanglev = medfilt1(medfilt1(ncanglev));
 ncanglev_g = imgaussfilt(ncanglev,10);
 thl = mean(ncanglev_g) + 2*std(ncanglev_g);
 thm = mean(ncanglev_g) - 2*std(ncanglev_g);
 thl5 = mean(ncanglev_g) + 0.5*std(ncanglev_g);
 thm5 = mean(ncanglev_g) - 0.5*std(ncanglev_g);
 
 thind = find(ncanglev_g >= thl | ncanglev_g <=thm);
 thend = thind(find(diff(thind)>1));
 thstart = thind(find(diff(thind)>1)+1);
 thstart = [thind(1);thstart(1:end-1)];
 
 thind5 = find(ncanglev_g >= thl5 | ncanglev_g <=thm5);
 thend5 = thind5(find(diff(thind5)>1));
 thstart5 = thind5(find(diff(thind5)>1)+1);
 thstart5 = [thind5(1);thstart5(1:end-1)];
 
 thmid = round((thend+thstart)/2);

 k=1;
for i=1:length(thstart5)
   temp = find(thstart > thstart5(i) & thstart < thend5(i));
   if isempty(temp) < 1;    
   thstart2_5(k,1) = thstart5(i);   
   thend2_5(k,1) = thend5(i);   
   k=k+1;
   end
   temp=[];
end

thmid2_5 = round((thend2_5+thstart2_5)/2);

 
 for i=1:length(thend2_5)
     sv = cn(thstart2_5(i))/abs(cn(thstart2_5(i)));
     mv = cn(thmid2_5(i))/abs(cn(thmid2_5(i)));
     ev = cn(thend2_5(i))/abs(cn(thend2_5(i)));
     an = wrapTo360(rad2deg(angle(sv)));
     svr = [real(sv) imag(sv)];
     mvr = [real(mv) imag(mv)];
     evr = [real(ev) imag(ev)];
     
     R = [cosd(an), -sind(an);sind(an) cosd(an)];
     s=svr*R;
     m=mvr*R;
     e=evr*R;
     sv2 = s(1) + 1i*s(2);
     mv2 = m(1) + 1i*m(2);
     ev2 = e(1) + 1i*e(2);
 
 initangle = rad2deg(angle(mv2));
 if initangle > 0 % right turn
 th2(i,1) =  wrapTo360(rad2deg(angle(ev2)));
 else % left turn
     th2(i,1) = (rad2deg(angle(ev2)));
 end
 end

 thangle = th2(abs(th2)>20);
 thend = thend(abs(th2)>20); thstart = thstart(abs(th2)>20);
 thend2_5 = thend2_5(abs(th2)>20); thstart2_5 = thstart2_5(abs(th2)>20);
 
 
 
 % median filter
 Tv = medfilt1(Tv);Cv = medfilt1(Cv);Nv = medfilt1(Nv);

% locomotion 
%  [time, Nv10] = traceBin(Nv,F(1:end-1),1);     
%  [time, Cv10] = traceBin(Cv,F(1:end-1),1);     
%  [time, Tv10] = traceBin(Tv,F(1:end-1),1);     
 Cv10 = imgaussfilt(Cv,10);
 Nv10 = imgaussfilt(Nv,10);
%  Ca10 = imgaussfilt(diff(Cv),10);
thmax5 = mean(Cv10) + 0.5*std(Cv10);
thmax1 = mean(Cv10) + 1*std(Cv10);
thmax15 = mean(Cv10) + 1.5*std(Cv10);
thmax2 = mean(Cv10) + 2*std(Cv10);

thmax5n = mean(Nv10) + 0.5*std(Nv10);
thmax1n = mean(Nv10) + 1*std(Nv10);
thmax15n = mean(Nv10) + 1.5*std(Nv10);
thmax2n = mean(Nv10) + 2*std(Nv10);


thlocind5 = find(Cv10 >=thmax5);
thlocend5 = thlocind5(find(diff(thlocind5)>1));
thlocstr5 = thlocind5(find(diff(thlocind5)>1)+1);
thlocstr5 = [thlocind5(1); thlocstr5(1:end-1)];

thlocind1 = find(Cv10 >=thmax1);
thlocend1 = thlocind1(find(diff(thlocind1)>1));
thlocstr1 = thlocind1(find(diff(thlocind1)>1)+1);
thlocstr1 = [thlocind1(1); thlocstr1(1:end-1)];

thlocind15 = find(Cv10 >=thmax15);
thlocend15 = thlocind15(find(diff(thlocind15)>1));
thlocstr15 = thlocind15(find(diff(thlocind15)>1)+1);
thlocstr15 = [thlocind15(1); thlocstr15(1:end-1)];

thlocind2 = find(Cv10 >=thmax2);
thlocend2 = thlocind2(find(diff(thlocind2)>1));
thlocstr2 = thlocind2(find(diff(thlocind2)>1)+1);
thlocstr2 = [thlocind2(1); thlocstr2(1:end-1)];


thlocind5n = find(Nv10 >=thmax5n);
thlocend5n = thlocind5n(find(diff(thlocind5n)>1));
thlocstr5n = thlocind5n(find(diff(thlocind5n)>1)+1);
thlocstr5n = [thlocind5n(1); thlocstr5n(1:end-1)];

thlocind1n = find(Nv10 >=thmax1n);
thlocend1n = thlocind1n(find(diff(thlocind1n)>1));
thlocstr1n = thlocind1n(find(diff(thlocind1n)>1)+1);
thlocstr1n = [thlocind1n(1); thlocstr1n(1:end-1)];

thlocind15n = find(Nv10 >=thmax15n);
thlocend15n = thlocind15n(find(diff(thlocind15n)>1));
thlocstr15n = thlocind15n(find(diff(thlocind15n)>1)+1);
thlocstr15n = [thlocind15n(1); thlocstr15n(1:end-1)];

thlocind2n = find(Nv10 >=thmax2n);
thlocend2n = thlocind2n(find(diff(thlocind2n)>1));
thlocstr2n = thlocind2n(find(diff(thlocind2n)>1)+1);
thlocstr2n = [thlocind2n(1); thlocstr2n(1:end-1)];

k=1;
for i=1:length(thlocstr1)
   temp = find(thlocstr2 > thlocstr1(i) & thlocstr2 < thlocend1(i));
   if isempty(temp) < 1;    
   thlocstr2_1(k,1) = thlocstr1(i);   
   thlocend2_1(k,1) = thlocend1(i);   
   k=k+1;
   end
   temp=[];
end

k=1;
for i=1:length(thlocstr1)
   temp = find(thlocstr15 > thlocstr1(i) & thlocstr15 < thlocend1(i));
   if isempty(temp) < 1;    
   thlocstr15_1(k,1) = thlocstr1(i);   
   thlocend15_1(k,1) = thlocend1(i);   
   k=k+1;
   end
   temp=[];
end

k=1;
for i=1:length(thlocstr5)
   temp = find(thlocstr2 > thlocstr5(i) & thlocstr2 < thlocend5(i));
   if isempty(temp) < 1;    
   thlocstr2_5(k,1) = thlocstr5(i);   
   thlocend2_5(k,1) = thlocend5(i);   
   k=k+1;
   end
   temp=[];
end

k=1;
for i=1:length(thlocstr5)
   temp = find(thlocstr15 > thlocstr5(i) & thlocstr15 < thlocend5(i));
   if isempty(temp) < 1;    
   thlocstr15_5(k,1) = thlocstr5(i);   
   thlocend15_5(k,1) = thlocend5(i);   
   k=k+1;
   end
   temp=[];
end

k=1;
for i=1:length(thlocstr5)
   temp = find(thlocstr1 > thlocstr5(i) & thlocstr1 < thlocend5(i));
   if isempty(temp) < 1;    
   thlocstr1_5(k,1) = thlocstr5(i);   
   thlocend1_5(k,1) = thlocend5(i);   
   k=k+1;
   end
   temp=[];
end

% complete stop
% Cv and Nv both below mean (0.5SD);
 Nv10 = imgaussfilt(Nv,10);
 Tv10 = imgaussfilt(Tv,10);
 thstopind = find(Cv10 <= (mean(Cv10)-0.5*std(Cv10) & Nv10 <=(mean(Nv10)-0.5*std(Nv10)) & Tv10 <=(mean(Tv10)-0.5*std(Tv10))));
 thstopend = thstopind(find(diff(thstopind)>1));
 thstopstr = thstopind(find(diff(thstopind)>1)+1);
 thstopstr = [thstopind(1);thstopstr(1:end-1)];
 
time = xlsFile(:,1);
time2 = (F+1)*(1/30);

load('./Neuron_z.mat');
syncpos = find(histc(synctime,time)==1);
syncpos2 = find(histc(synctime,time2)==1);
% syncpos = find(histc(synctime,time3)==1);

save('./sync_deep_z_mk3.mat','Cv','Nv','Tv','Nv10','Tv10','Cv10','ncanglev_g','ncanglev','thstopstr','thstopend', ...
    'thlocstr1','thlocstr15','thlocstr2','thlocstr2_1','thlocstr15_1', 'thlocstr2_5','thlocstr15_5', 'thlocstr1_5', ...
    'thlocend1','thlocend15','thlocend2','thlocend2_1','thlocend15_1', 'thlocend2_5','thlocend15_5', 'thlocend1_5', ...
    'thend','thstart', 'thend2_5','thstart2_5', ...
    'thangle','th2','syncpos','syncpos2','synctime','sync','time','time2');
clear
end

