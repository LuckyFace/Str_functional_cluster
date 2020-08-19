% Behavior regression
% 2019. JH Shin

clear; close all;

load('./\Tot_behav_2_5.mat');

for session = 1:13
    Ftemp = TTF_2{session,1};
    Mtemp = TTF_2{session,2};
    Stemp = TTS{session,1};
    Mtemps = TTS{session,2};
    Ctemp = TTFCtr{session,1};
    Itemp = TTFIps{session,1};   
    compreg_total=[];
 for i=1:length(Ftemp)
%% Forward 
 temptrace = cell2mat(Ftemp(i,1));        
 mtemptrace = cell2mat(Mtemp(i,1));
 forwardmean = mean(temptrace(:,20:end),2);
 forwardpremean = mean(temptrace(:,1:20),2);
 tracemean = repmat(Mtemp{i,1}(1,1),length(forwardmean),1); 
 forwardind = [ones(length(forwardmean),1);zeros(length(forwardmean),1)];
 
 Time = -1:0.05:0.95;
 form1 = [forwardmean ; forwardpremean];
 form2 = [forwardmean ; tracemean];
 cform = [temptrace ; mtemptrace];
 
 regT_f1 = slideReg80([1],form1, [forwardind]);  
 regT_f2 = slideReg80([1],form2, [forwardind]);  
 regT_cf = slideReg80(Time,cform, [forwardind]);  
 
 
 %% Stop
 temptraces = cell2mat(Stemp(i,1));     
 mtemptraces = cell2mat(Mtemps(i,1));
 stopmean = mean(temptraces(:,20:end),2);
 stoppremean = mean(temptraces(:,1:20),2);
 tracemeans = repmat(Mtemp{i,1}(1,1),length(stopmean),1); 
 stopind = [ones(length(stopmean),1);zeros(length(stopmean),1)];
 
 stop1 = [stopmean ; stoppremean];
 stop2 = [stopmean ; tracemeans];
 cstop = [temptraces ; mtemptraces];
 
 regT_s1 = slideReg80([1],stop1, [stopind]);  
 regT_s2 = slideReg80([1],stop2, [stopind]);  
 regT_cs = slideReg80(Time,cstop, [stopind]);  
 
%% Contralateral
 temptracec = cell2mat(Ctemp(i,1));      
 mtemptracec = repmat(Mtemp{i,1}(1,1),size(temptracec));
 contmean = mean(temptracec(:,20:end),2);
 contpremean = mean(temptracec(:,1:20),2);
 tracemeanc = repmat(Mtemp{i,1}(1,1),length(contmean),1); 
 contind = [ones(length(contmean),1);zeros(length(contmean),1)];
 
 cont1 = [contmean ; contpremean];
 cont2 = [contmean ; tracemeanc];
 ccont = [temptracec ; mtemptracec];
 
 regT_c1 = slideReg80([1],cont1, [contind]);  
 regT_c2 = slideReg80([1],cont2, [contind]);  
 regT_cc = slideReg80(Time,ccont, [contind]);  
%% Ipsilateral
 temptracei = cell2mat(Itemp(i,1));        
 mtemptracei = repmat(Mtemp{i,1}(1,1),size(temptracei));
 ipsimean = mean(temptracei(:,20:end),2);
 ipsipremean = mean(temptracei(:,1:20),2);
 tracemeani = repmat(Mtemp{i,1}(1,1),length(ipsimean),1); 
 ipsiind = [ones(length(ipsimean),1);zeros(length(ipsimean),1)];
 
 ipsi1 = [ipsimean ; ipsipremean];
 ipsi2 = [ipsimean ; tracemeani];
 cips = [temptracei ; mtemptracei];
  
 regT_i1 = slideReg80([1],ipsi1, [ipsiind]);  
 regT_i2 = slideReg80([1],ipsi2, [ipsiind]);  
 regT_ci = slideReg80(Time,cips, [ipsiind]); 
 
 %%
 
reg_behav = struct('regT_f1',regT_f1,'regT_f2',regT_f2,'regT_s1',regT_s1,'regT_s2',regT_s2,'regT_c1',regT_c1,'regT_c2',regT_c2, ...
    'regT_i1',regT_i1,'regT_i2',regT_i2, ...
    'regT_cf',regT_cf,'regT_cs',regT_cs,'regT_cc',regT_cc,'regT_ci',regT_ci);    

compreg_total = [compreg_total;reg_behav];

temptrace=[];forwardmean=[];forwardpremean=[];tracemean=[];forwardind=[];
temptraces=[];stopmean=[];stoppremean=[];tracemeans=[];stopind=[];
temptracec=[];contmean=[];contpremean=[];tracemeanc=[];contind=[];
temptracei=[];ipsimean=[];ipsipremean=[];tracemeani=[];ipsiind=[];


regT_f1=[];regT_f2=[];regT_s1=[];regT_s2=[];regT_c1=[];regT_c2=[];regT_i1=[];regT_i2=[];
regT_cf=[];regT_cs=[]; regT_cc=[];regT_ci;

end
    
 for k=1:length(compreg_total)
    srcp(k,1) = compreg_total(k).regT_f1.p;
    srcp(k,2) = compreg_total(k).regT_f1.src;    
    srcp2(k,1) = compreg_total(k).regT_f2.p;
    srcp2(k,2) = compreg_total(k).regT_f2.src;
    
    srcps(k,1) = compreg_total(k).regT_s1.p;
    srcps(k,2) = compreg_total(k).regT_s1.src;    
    srcps2(k,1) = compreg_total(k).regT_s2.p;
    srcps2(k,2) = compreg_total(k).regT_s2.src;
    
    srcpc(k,1) = compreg_total(k).regT_c1.p;
    srcpc(k,2) = compreg_total(k).regT_c1.src;    
    srcpc2(k,1) = compreg_total(k).regT_c2.p;
    srcpc2(k,2) = compreg_total(k).regT_c2.src;
    
    srcpi(k,1) = compreg_total(k).regT_i1.p;
    srcpi(k,2) = compreg_total(k).regT_i1.src;    
    srcpi2(k,1) = compreg_total(k).regT_i2.p;
    srcpi2(k,2) = compreg_total(k).regT_i2.src;   
    
    srcf(k,:) = compreg_total(k).regT_cf.src;
    srcs(k,:) = compreg_total(k).regT_cs.src;
    srcc(k,:) = compreg_total(k).regT_cc.src;
    srci(k,:) = compreg_total(k).regT_ci.src;
    
    srcpcf(k,:) = compreg_total(k).regT_cf.p;
    srcpcs(k,:) = compreg_total(k).regT_cs.p;
    srcpcc(k,:) = compreg_total(k).regT_cc.p;
    srcpci(k,:) = compreg_total(k).regT_ci.p;
 end
 compF(session,1) = {srcp(:,1)};
 compF(session,2) = {srcp(:,2)};
 compF(session,3) = {srcps(:,1)};
 compF(session,4) = {srcps(:,2)};
 compF(session,5) = {srcpc(:,1)};
 compF(session,6) = {srcpc(:,2)};
 compF(session,7) = {srcpi(:,1)};
 compF(session,8) = {srcpi(:,2)};
 
 compF2(session,1) = {srcp2(:,1)};
 compF2(session,2) = {srcp2(:,2)};
 compF2(session,3) = {srcps2(:,1)};
 compF2(session,4) = {srcps2(:,2)};
 compF2(session,5) = {srcpc2(:,1)};
 compF2(session,6) = {srcpc2(:,2)};
 compF2(session,7) = {srcpi2(:,1)};
 compF2(session,8) = {srcpi2(:,2)};
 
 compcF(session,1) = {srcpcf};
 compcF(session,2) = {srcpcs};
 compcF(session,3) = {srcpcc};
 compcF(session,4) = {srcpci};
 srcp=[];srcps=[];srcpc=[];srcpi=[];srcp2=[];srcps2=[];srcpc2=[];srcpi2=[];
 srcpcf=[];srcpcs=[];srcpcc=[];srcpci=[];
end

% save('C:\temp_backup\Major league\Data\behav_regression_session2_5.mat','compF','compF2','compcF')
