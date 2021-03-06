clear all; close all; clc;
for i = 1:3
  load(['cam' num2str(i) '_3.mat'])
end

%%
[xlength,ylength,c,length] = size(vidFrames1_3);
loc1_3 = zeros(length,2);
for j = 1:length
    frame = double(rgb2gray(vidFrames1_3(:,:,:,j)));
    frame(1:480,[1:280 400:ylength])=0;
    frame(1:220, 280:400)=0;
    M = max(frame(:));
    [x1,y1] = find(frame >= M * 49 / 50);
    loc1_3(j,1)=mean(y1);
    loc1_3(j,2)=mean(x1);
    
%     imshow(vidFrames1_3(:,:,:,j)); hold on;
%     plot(y1,x1, 'ro'); hold off; drawnow;

%     pcolor(frame), shading interp
%     colormap(gray); drawnow; hold on;
    
end 
%%
[xlength,ylength,c,length] = size(vidFrames2_3);
loc2_3 = zeros(length,2);
for j = 1:length
    frame = double(rgb2gray(vidFrames2_3(:,:,:,j)));
    frame(1:xlength,[1:210 450:ylength])=0;
    frame(1:170, 210:450)=0;
    M = max(frame(:));
    
    [x1,y1] = find(frame >= M * 49 / 50);
    loc2_3(j,1)=mean(y1);
    loc2_3(j,2)=mean(x1);
    
%     imshow(vidFrames2_3(:,:,:,j)); hold on;
%     plot(y1,x1, 'ro'); hold off; drawnow; 
    
%     pcolor(frame), shading interp
%     colormap(gray); drawnow; hold on;
end 
%%
[xlength,ylength,c,length] = size(vidFrames3_3);
loc3_3 = zeros(length,2);
for j = 1:length
    frame = double(rgb2gray(vidFrames3_3(:,:,:,j)));
    frame(1:480,[1:200 480:ylength])=0;
    frame([1:100 350:xlength], 200:500)=0;
    M = max(frame(:));
    [x1,y1] = find(frame >= M * 49 / 50);
    loc3_3(j,1)=mean(x1);
    loc3_3(j,2)=mean(y1);
    
        
%     imshow(vidFrames3_3(:,:,:,j)); hold on;
%     plot(y1,x1, 'ro'); hold off; drawnow; 
    
%     pcolor(frame), shading interp
%     colormap(gray); drawnow; hold on;
end 

%%
x1=loc1_3(:,1);
x2=loc2_3(:,1);
x3=loc3_3(:,1);
y1=loc1_3(:,2);
y2=loc2_3(:,2);
y3=loc3_3(:,2);
% 
% figure()
% plot(y1,'r'), hold on 
% plot(y2,'b')
% plot(y3,'g')

x1=x1((10:size(x1)));
y1=y1((10:size(y1)));

x2=x2((35:size(x2)));
y2=y2((35:size(y2)));
% 
% figure()
% plot(y1,'r'), hold on 
% plot(y2,'b')
% plot(y3,'g')

siz = [size(y1,1) size(y2,1) size(y3,1)];
minisiz = min(siz);
M = [x1(1:minisiz) y1(1:minisiz) x2(1:minisiz) y2(1:minisiz) x3(1:minisiz) y3(1:minisiz)]; 
M = M';
%%
figure()
t=1:minisiz;
subplot(3,1,1)
plot(t,M(1,:),t,M(2,:))
xlabel('t(frames number)'); ylabel('position')
legend('horizontal','vertical','Location','NorthEast')

subplot(3,1,2)
plot(t,M(3,:),t,M(4,:))
xlabel('t(frames number)'); ylabel('position')
legend('horizontal','vertical','Location','NorthEast')

subplot(3,1,3)
plot(t,M(5,:),t,M(6,:))
xlabel('t(frames number)'); ylabel('position')
legend('horizontal','vertical','Location','NorthEast')
saveas(gcf,'signal3.png')
%% Minus average
[m,n]=size(M); % compute data size 
mn=mean(M,2); % compute mean for each row 
M=M-repmat(mn,1,n); % subtract mean

figure()
plot(M(2,:)),hold on
plot(M(4,:))
plot(M(6,:))
saveas(gcf,'avesig3.png')
%%
[u,s,v]=svd(M,'econ');
sig=diag(s)/sum(diag(s));
figure()
plot(linspace(1,6,6),sig,'ko')
set(gca,'Ylim',[0 1],'Fontsize',[14])
xlabel('mode'); ylabel('energy percentage(%)')
saveas(gcf,'diag3.png')

figure()
plot(t,s*v');
title('Case3');
xlabel('t(frames number)'); ylabel('position');
legend('mode1','mode2','mode3','mode4','mode5','mode6');
saveas(gcf,'result3.png')