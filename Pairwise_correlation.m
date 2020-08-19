% pairwise correlation
clear; close all;
load('./\Tot_CPD.mat');
load('./\Tot_fon.mat');
load('./\color_set.mat')
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
unit = 20;st=20;
for i=1:700/unit
    % 20um 단위로
    maw(i) = mean(aw(find(aw(:,4)>st*(i-1)+1 & aw(:,4)<st*(i-1)+unit),3));
    mat(i) = mean(at(find(at(:,4)>st*(i-1)+1 & at(:,4)<st*(i-1)+unit),2));
    mam(i) = mean(am(find(am(:,4)>st*(i-1)+1 & am(:,4)<st*(i-1)+unit),1));
    
    mbw(i) = mean(bw(find(bw(:,4)>st*(i-1)+1 & bw(:,4)<st*(i-1)+unit),3));
    mbt(i) = mean(bt(find(bt(:,4)>st*(i-1)+1 & bt(:,4)<st*(i-1)+unit),2));
    mbm(i) = mean(bm(find(bm(:,4)>st*(i-1)+1 & bm(:,4)<st*(i-1)+unit),1));
    
    mcw(i) = mean(cw(find(cw(:,4)>st*(i-1)+1 & cw(:,4)<st*(i-1)+unit),3));
    mct(i) = mean(ct(find(ct(:,4)>st*(i-1)+1 & ct(:,4)<st*(i-1)+unit),2));
    mcm(i) = mean(cm(find(cm(:,4)>st*(i-1)+1 & cm(:,4)<st*(i-1)+unit),1));
end

for kk=1:13
   for kkk=1:3        
         temp = aaw{kk,kkk};
     for i=1:700/unit
    % 20um 단위로
     tempt(i) = mean(temp(find(temp(:,4)>st*(i-1)+1 & temp(:,4)<st*(i-1)+unit),kkk));   
     end
       maw21(kk,kkk) = {tempt};
     tempt=[];
    end
end
T = 1:20:700;

 
h(1) = axes('Position',axpt(nCol,nRow,1,1,[],wideInterval)); 
 hold on
 scatter(at(:,4),at(:,3),0.1,'MarkerFaceColor',colorGray,'MarkerEdgeColor',colorGray)  
 maw2 = mean(cell2mat(maw21(1:3,1)));saw2 = std(cell2mat(maw21(1:3,1)))/sqrt(3/3);;

 fill([T flip(T)], [mat-(2*saw2), flip(mat+(2*saw2))], ...
             [0 0 0],'LineStyle','none','FaceAlpha',0.2);
          plot(T,mat,  'LineStyle','-', 'LineWidth', 1, 'Color', [0 0 0]);
 set(h(1), 'XLim', [1 700], 'XTick',[0 200 400 600],'YLim', [-0.5 1], 'YTick', [-0.5 0 0.5 1],'FontSize',FontS);
title('Task trace','FontSize', FontM);     


h(2) = axes('Position',axpt(nCol,nRow,1,2,[],wideInterval)); 
 hold on
 scatter(bt(:,4),bt(:,3),0.1,'MarkerFaceColor',colorGray,'MarkerEdgeColor',colorGray)    
  maw2 = mean(cell2mat(maw21(4:8,1)));saw2 = std(cell2mat(maw21(4:8,1)))/sqrt(5/5);

 fill([T flip(T)], [maw2-(2*saw2), flip(maw2+(2*saw2))], ...
             colorlBlue,'LineStyle','none','FaceAlpha',0.2);
          plot(T,maw2,  'LineStyle','-', 'LineWidth', 1, 'Color', colorlBlue);

 set(h(2), 'XLim', [1 700], 'XTick',[0 200 400 600 800],'YLim', [-0.8 1], 'YTick', [-0.5 0 0.5 1],'FontSize',FontS);
 
 h(3) = axes('Position',axpt(nCol,nRow,1,3,[],wideInterval)); 
 hold on
 scatter(ct(:,4),ct(:,3),0.1,'MarkerFaceColor',colorGray,'MarkerEdgeColor',colorGray)    
  maw2 = mean(cell2mat(maw21(9:13,1)));saw2 = std(cell2mat(maw21(9:13,1)))/sqrt(5/5);
 
 fill([T flip(T)], [maw2-(2*saw2), flip(maw2+(2*saw2))], ...
             colorOrange,'LineStyle','none','FaceAlpha',0.2);
         plot(T,maw2,  'LineStyle','-', 'LineWidth', 1, 'Color', colorOrange);
 set(h(3), 'XLim', [1 700], 'XTick',[0 200 400 600 800],'YLim', [-0.8 1], 'YTick', [-0.5 0 0.5 1],'FontSize',FontS);
 xlabel('Distance (um)','FontSize',FontM);
 

h(1) = axes('Position',axpt(nCol,nRow,2,1,[],wideInterval)); 
 hold on
 scatter(am(:,4),am(:,2),0.1,'MarkerFaceColor',colorGray,'MarkerEdgeColor',colorGray)    
  maw2 = mean(cell2mat(maw21(1:3,2)));saw2 = std(cell2mat(maw21(1:3,2)))/sqrt(3/3);;

 fill([T flip(T)], [mam-(2*saw2), flip(mam+(2*saw2))], ...
             [0 0 0],'LineStyle','none','FaceAlpha',0.2);
          plot(T,mam,  'LineStyle','-', 'LineWidth', 1, 'Color', [0 0 0]);
 set(h(1), 'XLim', [1 700], 'XTick',[0 200 400 600],'YLim', [-0.5 1], 'YTick', [-0.5 0 0.5 1],'FontSize',FontS);
title('Task trace','FontSize', FontM);     


h(2) = axes('Position',axpt(nCol,nRow,2,2,[],wideInterval)); 
 hold on
 scatter(bm(:,4),bm(:,2),0.1,'MarkerFaceColor',colorGray,'MarkerEdgeColor',colorGray)    
  maw2 = mean(cell2mat(maw21(4:8,2)));saw2 = std(cell2mat(maw21(4:8,2)))/sqrt(5/5);
 
 fill([T flip(T)], [maw2-(2*saw2), flip(maw2+(2*saw2))], ...
             colorlBlue,'LineStyle','none','FaceAlpha',0.2);
         plot(T,maw2,  'LineStyle','-', 'LineWidth', 1, 'Color', colorlBlue);
 set(h(2), 'XLim', [1 700], 'XTick',[0 200 400 600 800],'YLim', [-0.8 1], 'YTick', [-0.5 0 0.5 1],'FontSize',FontS);
 
 h(3) = axes('Position',axpt(nCol,nRow,2,3,[],wideInterval)); 
 hold on
 scatter(cm(:,4),cm(:,2),0.1,'MarkerFaceColor',colorGray,'MarkerEdgeColor',colorGray)    
 maw2 = mean(cell2mat(maw21(9:13,2)));saw2 = std(cell2mat(maw21(9:13,2)))/sqrt(5/5);
 
 fill([T flip(T)], [maw2-(2*saw2), flip(maw2+(2*saw2))], ...
             colorOrange,'LineStyle','none','FaceAlpha',0.2);
         plot(T,maw2,  'LineStyle','-', 'LineWidth', 1, 'Color', colorOrange);
 set(h(3), 'XLim', [1 700], 'XTick',[0 200 400 600 800],'YLim', [-0.8 1], 'YTick', [-0.5 0 0.5 1],'FontSize',FontS);
 xlabel('Distance (um)','FontSize',FontM);
 
 
 %% motor
  
h(1) = axes('Position',axpt(nCol,nRow,3,1,[],wideInterval)); 
 hold on
 scatter(aw(:,4),aw(:,2),0.1,'MarkerFaceColor',colorGray,'MarkerEdgeColor',colorGray)    
  maw2 = mean(cell2mat(maw21(1:3,3)));saw2 = std(cell2mat(maw21(1:3,3)))/sqrt(3/3);;
 
 fill([T flip(T)], [maw-(2*saw2), flip(maw+(2*saw2))], ...
             [0 0 0],'LineStyle','none','FaceAlpha',0.2);
         plot(T,maw,  'LineStyle','-', 'LineWidth', 1, 'Color', [0 0 0]);
 set(h(1), 'XLim', [1 700], 'XTick',[0 200 400 600],'YLim', [-0.5 1], 'YTick', [-0.5 0 0.5 1],'FontSize',FontS);
title('Task trace','FontSize', FontM);     


h(2) = axes('Position',axpt(nCol,nRow,3,2,[],wideInterval)); 
 hold on
 scatter(bw(:,4),bw(:,2),0.1,'MarkerFaceColor',colorGray,'MarkerEdgeColor',colorGray)    
  maw2 = mean(cell2mat(maw21(4:8,3)));saw2 = std(cell2mat(maw21(4:8,3)))/sqrt(5/5);
 
 fill([T flip(T)], [maw2-(2*saw2), flip(maw2+(2*saw2))], ...
             colorlBlue,'LineStyle','none','FaceAlpha',0.2);
         plot(T,maw2,  'LineStyle','-', 'LineWidth', 1, 'Color', colorlBlue);
 set(h(2), 'XLim', [1 700], 'XTick',[0 200 400 600 800],'YLim', [-0.8 1], 'YTick', [-0.5 0 0.5 1],'FontSize',FontS);
 
 h(3) = axes('Position',axpt(nCol,nRow,3,3,[],wideInterval)); 
 hold on
 scatter(cw(:,4),cw(:,2),0.1,'MarkerFaceColor',colorGray,'MarkerEdgeColor',colorGray)    
 maw2 = mean(cell2mat(maw21(9:13,3)));saw2 = std(cell2mat(maw21(9:13,3)))/sqrt(5/5);

 fill([T flip(T)], [maw2-(2*saw2), flip(maw2+(2*saw2))], ...
             colorOrange,'LineStyle','none','FaceAlpha',0.2);
          plot(T,maw2,  'LineStyle','-', 'LineWidth', 1, 'Color', colorOrange);
 set(h(3), 'XLim', [1 700], 'XTick',[0 200 400 600 800],'YLim', [-0.8 1], 'YTick', [-0.5 0 0.5 1],'FontSize',FontS);
 xlabel('Distance (um)','FontSize',FontM);