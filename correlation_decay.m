% sFig3,sFig4
clear; close all;

load('./\Tot_CPD.mat');
load('./\Tot_fon.mat');
load('./\color_set.mat')
load('./\center.mat');
load('./\Tot_corr.mat')


nCol = 3;
nRow = 3;
fHandle = figure('PaperUnits','centimeters','PaperPosition',[0 0 17.4 17.4*(2/3)],'Renderer','Painters');

% task, motor 순으로 (corrdat에는 motor, task, whole순으로 coding되어있음)
aw=sortrows(corrdat,3);
at=sortrows(corrdat,2);
am=sortrows(corrdat,1);
bw=sortrows(corrdatd1,3);
bt=sortrows(corrdatd1,2);
bm=sortrows(corrdatd1,1);
cw=sortrows(corrdatd2,3);
ct=sortrows(corrdatd2,2);
cm=sortrows(corrdatd2,1);

for k=1:13
    aaw{k,3} = sortrows(tcorrdat{k},3);
        aaw{k,2} = sortrows(tcorrdat{k},1);
            aaw{k,1} = sortrows(tcorrdat{k},2);
end

unit = 10;st=10;
for i=1:700/unit
    % 10um 단위로
    maw(i) = nanmean(aw(find(aw(:,4)>st*(i-1)+1 & aw(:,4)<st*(i-1)+unit),3));
    mat(i) = nanmean(at(find(at(:,4)>st*(i-1)+1 & at(:,4)<st*(i-1)+unit),2));
    mam(i) = nanmean(am(find(am(:,4)>st*(i-1)+1 & am(:,4)<st*(i-1)+unit),1));
    
    mbw(i) = nanmean(bw(find(bw(:,4)>st*(i-1)+1 & bw(:,4)<st*(i-1)+unit),3));
    mbt(i) = nanmean(bt(find(bt(:,4)>st*(i-1)+1 & bt(:,4)<st*(i-1)+unit),2));
    mbm(i) = nanmean(bm(find(bm(:,4)>st*(i-1)+1 & bm(:,4)<st*(i-1)+unit),1));
    
    mcw(i) = nanmean(cw(find(cw(:,4)>st*(i-1)+1 & cw(:,4)<st*(i-1)+unit),3));
    mct(i) = nanmean(ct(find(ct(:,4)>st*(i-1)+1 & ct(:,4)<st*(i-1)+unit),2));
    mcm(i) = nanmean(cm(find(cm(:,4)>st*(i-1)+1 & cm(:,4)<st*(i-1)+unit),1));
end

unit = 10;st=1;
for kk=1:13
   for kkk=1:3        
         temp = aaw{kk,kkk};
     for i=1:700/st
    % 20um 단위로
     tempt(i) = nanmean(temp(find(temp(:,4)>st*(i-1)+1 & temp(:,4)<st*(i-1)+unit),kkk));   
     end
       maw212(kk,kkk) = {tempt};
     tempt=[];
    end
end

unit = 20;st=1;
for kk=1:13
   for kkk=1:3        
         temp = aaw{kk,kkk};
     for i=1:700/st
    % 20um 단위로
     tempt(i) = nanmean(temp(find(temp(:,4)>st*(i-1)+1 & temp(:,4)<st*(i-1)+unit),kkk));   
     end
       maw21(kk,kkk) = {tempt};
     tempt=[];
    end
end

% unit = 10;st=5;
% for kk=1:13
%    for kkk=1:3        
%          temp = aaw{kk,kkk};
%      for i=1:700/st
%     % 20um 단위로
%      tempt(i) = nanmean(temp(find(temp(:,4)>st*(i-1)+1 & temp(:,4)<st*(i-1)+unit),kkk));   
%      end
%        maw5(kk,kkk) = {tempt};
%      tempt=[];
%     end
% end

% figure

% figure
% hold on
% for k=4:8
%     plot(maw212{k,1})
% end
% figure
% hold on
% for k=9:13
%     plot(maw212{k,1})
% end

maw21 = maw212;

T = 1:10:700;
T = 1:1:700;
% T = 1:2:700;


trial =1;
for kk=trial
h(1) = axes('Position',axpt(nCol,nRow,1,1,[],wideInterval)); 
 hold on
hold on
for k=1:3
    plot(T,maw21{k,kk})
end
 set(h(1), 'XLim', [2 552], 'XTick',[2:100:652],'XTickLabel',[0:100:600],'YLim', [-0.1 0.55], 'YTick',  [-0.1:0.1:0.6],'FontSize',FontS);
 ylabel('Mean correlation coefficient','FontSize',FontM);
 xlabel('Distance (um)','FontSize',FontM);

 h(1) = axes('Position',axpt(nCol,nRow,2,1,[],wideInterval)); 
 hold on
for k=4:8
    plot(T,maw21{k,kk})
end
 set(h(1), 'XLim', [2 552], 'XTick',[2:100:652],'XTickLabel',[0:100:600],'YLim', [-0.1 0.4], 'YTick',  [-0.1:0.1:0.6],'FontSize',FontS);
 xlabel('Distance (um)','FontSize',FontM);
 
  h(1) = axes('Position',axpt(nCol,nRow,3,1,[],wideInterval)); 
 hold on
for k=9:13
    plot(T,maw21{k,kk})
end
 set(h(1), 'XLim', [2 552], 'XTick',[2:100:652],'XTickLabel',[0:100:600],'YLim', [-0.1 0.55], 'YTick',  [-0.1:0.1:0.6],'FontSize',FontS);
 xlabel('Distance (um)','FontSize',FontM);
end

h(1) = axes('Position',axpt(nCol,nRow,1,2,[],wideInterval)); 

 
tbl = table(T',  maw212{2,trial}');
% tbl = tbl(2:50,:)
modelfun = @(b,x) b(1) * exp(-b(2)*x(:, 1)) + b(3);  
beta0 = [11, 0.1, 6]; % Guess values to start with.  Just make your best guess.
% Now the next line is where the actual model computation is done.
mdl = fitnlm(tbl, modelfun, beta0);
coefficients = mdl.Coefficients{:, 'Estimate'}
% Create smoothed/regressed data using the model:
yFitted = coefficients(1) * exp(-coefficients(2)*T) + coefficients(3);
% Now we're done and we can plot the smooth model as a red line going through the noisy blue markers.
hold on;
% plot(T, yFitted, 'LineStyle','-', 'LineWidth',1, 'Color', colorRed);
p1 = 300; p2 = 400;
% p1 = 150; p2 = 200;
pl = mean(maw212{3,trial}(p1:p2));
% ind = aaw{2,trial}(:,4) < 500 & aaw{2,trial}(:,4) > 300;
% pl = mean(aaw{2,trial}(ind,1));
smd = smoothdata(maw212{3,trial},'gaussian',50);
tconst = find(smd<=pl);tconst = tconst(1);
plot(T,smd,'LineStyle','-', 'LineWidth',1,'Color', colorGray);
% plot(T,maw212{2,trial},'LineStyle','-', 'LineWidth',1,'Color', colorGray);
plot([-1000 2000],[pl pl],'-', 'LineWidth', 1, 'Color', [0.6 0.6 0.6]);
% tconst = (1/coefficients(2))*5 ;
plot([tconst tconst],[-1 2],'-', 'LineWidth', 1, 'Color', [0 0 0]);

% dif = (yFitted - maw212{2,trial});
% difind = (find(dif == max(dif),2))*st;
% difind = find(maw212{2,trial} == min(maw212{2,trial}));
% plot([difind difind],[-1 2],'-', 'LineWidth', 1, 'Color', colorPurple);
 set(h(1), 'XLim', [2 552], 'XTick',[2:100:652],'XTickLabel',[0:100:600],'YLim', [-0.1 0.5], 'YTick',  [-0.1:0.1:0.6],'FontSize',FontS);
 ylabel('Mean correlation coefficient','FontSize',FontM);
 xlabel('Distance (um)','FontSize',FontM);
 
 
 s = 4
 h(1) = axes('Position',axpt(nCol,nRow,2,2,[],wideInterval)); 

 
 tbl = table(T',  maw212{s,trial}');
modelfun = @(b,x) b(1) * exp(-b(2)*x(:, 1)) + b(3);  
beta0 = [11, 0.1, 6]; % Guess values to start with.  Just make your best guess.
% Now the next line is where the actual model computation is done.
mdl = fitnlm(tbl, modelfun, beta0);
coefficients = mdl.Coefficients{:, 'Estimate'}
% Create smoothed/regressed data using the model:
yFitted = coefficients(1) * exp(-coefficients(2)*T) + coefficients(3);
% Now we're done and we can plot the smooth model as a red line going through the noisy blue markers.
hold on;
% plot(T, yFitted, 'LineStyle','-', 'LineWidth',1, 'Color', colorRed);
p1 = 300; p2 = 400;
% p1 = 150; p2 = 200;
pl = mean(maw212{s,trial}(p1:p2));
% ind = aaw{2,trial}(:,4) < 500 & aaw{2,trial}(:,4) > 300;
% pl = mean(aaw{2,trial}(ind,1));
smd = smoothdata(maw212{s,trial},'gaussian',50);
tconst = find(smd<=pl);tconst = tconst(1);
plot(T,smd,  'LineStyle','-', 'LineWidth',1,'Color', colorlBlue);
plot([-1000 2000],[pl pl],'-', 'LineWidth', 1, 'Color', [0.6 0.6 0.6]);

% tconst = (1/coefficients(2))*5;
plot([tconst tconst],[-1 2],'-', 'LineWidth', 1, 'Color', [0 0 0]);
dif = (yFitted - maw212{s,trial});
dif = dif(5:40);
difind = (find(dif == max(dif))+3)*st;
% mm = smd(1:400);
% difind = find(smd == min(mm)); difind=difind(1);
% plot([difind difind],[-1 2],'-', 'LineWidth', 1, 'Color', colorPurple);
set(h(1), 'XLim', [2 552], 'XTick',[2:100:652],'XTickLabel',[0:100:600],'YLim', [-0.1 0.3], 'YTick',  [-0.1:0.1:0.6],'FontSize',FontS);
 xlabel('Distance (um)','FontSize',FontM);
 
  h(1) = axes('Position',axpt(nCol,nRow,3,2,[],wideInterval)); 

 
 tbl = table(T',  maw212{12,trial}');

modelfun = @(b,x) b(1) * exp(-b(2)*x(:, 1)) + b(3);  
beta0 = [11, 0.1, 6]; % Guess values to start with.  Just make your best guess.
% Now the next line is where the actual model computation is done.
mdl = fitnlm(tbl, modelfun, beta0);
coefficients = mdl.Coefficients{:, 'Estimate'}
% Create smoothed/regressed data using the model:
yFitted = coefficients(1) * exp(-coefficients(2)*T) + coefficients(3);
% Now we're done and we can plot the smooth model as a red line going through the noisy blue markers.
hold on;
% plot(T, yFitted, 'LineStyle','-', 'LineWidth',1, 'Color', colorRed);
p1 = 300; p2 = 400;
% p1 = 150; p2 = 200;
pl = mean(maw212{12,trial}(p1:p2));
% ind = aaw{12,trial}(:,4) < 500 & aaw{12,trial}(:,4) > 300;
% pl = mean(aaw{12,trial}(ind,1));
smd = smoothdata(maw212{12,trial},'gaussian',50);
tconst = find(maw212{12,trial}<=pl);tconst = tconst(1);
plot(T,smd,  'LineStyle','-', 'LineWidth',1,'Color', colorOrange);
plot([-1000 2000],[pl pl],'-', 'LineWidth', 1, 'Color', [0.6 0.6 0.6]);

% tconst = (1/coefficients(2))*5;
plot([tconst tconst],[-1 2],'-', 'LineWidth', 1, 'Color', [0 0 0]);
% dif = (yFitted - maw212{12,trial});
% dif = dif(5:40);
% difind = (find(dif == max(dif))+3)*st;
% mm = smd(1:400);
% difind = find(smd == min(mm));difind=difind(1);
% plot([difind difind],[-1 2],'-', 'LineWidth', 1, 'Color', colorPurple);
 set(h(1), 'XLim', [2 552], 'XTick',[2:100:652],'XTickLabel',[0:100:600],'YLim', [-0.1 0.4], 'YTick',  [-0.1:0.1:0.6],'FontSize',FontS);
 xlabel('Distance (um)','FontSize',FontM);
 
 for t=1:3
for k=1:13    
    % Convert X and Y into a table, which is the form fitnlm() likes the input data to be in.
tbl = table(T',  maw212{k,t}');
% Define the model as Y = a + exp(-b*x)
% Note how this "x" of modelfun is related to big X and big Y.
% x((:, 1) is actually X and x(:, 2) is actually Y - the first and second columns of the table.
modelfun = @(b,x) b(1) * exp(-b(2)*x(:, 1)) + b(3);  
beta0 = [11, 0.1, 6]; % Guess values to start with.  Just make your best guess.
% Now the next line is where the actual model computation is done.
mdl = fitnlm(tbl, modelfun, beta0);
% Now the model creation is done and the coefficients have been determined.
% YAY!!!!

% Extract the coefficient values from the the model object.
% The actual coefficients are in the "Estimate" column of the "Coefficients" table that's part of the mode.
coefficients = mdl.Coefficients{:, 'Estimate'}
% Create smoothed/regressed data using the model:
yFitted = coefficients(1) * exp(-coefficients(2)*T) + coefficients(3);
% Now we're done and we can plot the smooth model as a red line going through the noisy blue markers.
% hold on;
% plot(T(2:50), yFitted, 'r-', 'LineWidth', 1);
% grid on;
% title('Exponential Regression with fitnlm()', 'FontSize', FontM);
% xlabel('X', 'FontSize', FontM);
% ylabel('Y', 'FontSize', FontM);
% legendHandle = legend('Noisy Y', 'Fitted Y', 'Location', 'north');
% legendHandle.FontSize = 30;
% formulaString = sprintf('Y = %.3f * exp(-%.3f * X) + %.3f', coefficients(1), coefficients(2), coefficients(3))
% text(7, 11, formulaString, 'FontSize', 25, 'FontWeight', 'bold');

% dif = (yFitted - maw212{k,t});
% dif = dif(5:40);
% difind = (find(dif == max(dif))+3)*st;
% 
% tbl=[];
% tconst(k,t) = 1/coefficients(2);
% difind2 (k,t) = difind; difind=[];


p1 = 300; p2 = 400;
% p1 = 150; p2 = 200;
pl = mean(maw212{k,t}(p1:p2));
% ind = aaw{k,t}(:,4) < 500 & aaw{k,t}(:,4) > 300;
% pl = mean(aaw{k,t}(ind,1));
smd = smoothdata(maw212{k,t},'gaussian',50);
tconst = find(smd<=pl);tconst = tconst(1);
tconst = find(maw212{k,t}<=pl);tconst = tconst(1);
tconst2(k,t) = tconst;
% mm = smd(1:400);
% difind = find(smd == min(mm));difind=difind(1);
% difind2(k,t) = difind;
end
 end
% tconst = tconst*5;

 h(1) = axes('Position',axpt(nCol,nRow,1:2,3,[],wideInterval)); 
 hold on
 wtconst = tconst2(1:3,trial);
 dtconst = tconst2(4:8,trial);
 atconst = tconst2(9:13,trial); 

b=bar(1,mean(wtconst),'FaceColor',colorGray,'Barwidth',0.7);
errorbar(1,mean(wtconst),std(wtconst)/sqrt(3),'Color',[0 0 0],'LineWidth', 1.5);
plot(1,wtconst,'LineStyle','-','Marker','.','MarkerSize',10,'Color',[0.6 0.6 0.6]);
b=bar(2,mean(dtconst),'FaceColor',colorlBlue,'Barwidth',0.7);
errorbar(2,mean(dtconst),std(dtconst)/sqrt(5),'Color',[0 0 0],'LineWidth', 1.5);
plot(2,dtconst,'LineStyle','-','Marker','.','MarkerSize',10,'Color',colorllBlue);
b=bar(3,mean(atconst),'FaceColor',colorOrange,'Barwidth',0.7);
errorbar(3,mean(atconst),std(atconst)/sqrt(5),'Color',[0 0 0],'LineWidth', 1.5);
plot(3,atconst,'LineStyle','-','Marker','.','MarkerSize',10,'Color',colorYellow);
set(h(1),'XLim',[0.5 3.5],'XTick',1:3,'XTickLabel',{'WT','D1R','A2a'},'Ylim',[0 280],'YTick',[0:40:280],'FontSize',FontM);
 ylabel('Distance of plateau','FontSize',FontM);

