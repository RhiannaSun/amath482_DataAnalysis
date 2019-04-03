clear all; close all; clc;

video = VideoReader('gou.mp4');
data = [];
while hasFrame(video)
    ori_frame = readFrame(video);
    frame = imresize(ori_frame,0.5);
    bw = double(rgb2gray(frame));
%     pcolor(flipud(bw)), shading interp
%     colormap(gray); drawnow; hold on;
    frame_data = reshape(bw,[],1);
    data = [data frame_data];
end 
%%
X1 = data(:,1:end-1);
X2 = data(:,2:end);
[u,s,v]=svd(X1,'econ');
energy = diag(s)/sum(diag(s));
plot(energy,'ko');
set(gca,'Xlim',[1 20]);
xlabel('mode');ylabel('energy(percentage)');
saveas(gcf,'wangqiuenergy.png');

%%
r=1;
ur = u(:,1:r);
sr = s(1:r,1:r);
vr = v(:,1:r);
Altilde = ur'*X2*vr\sr;
[W,D]=eig(Altilde);
phi = X2*vr/sr*W;
lamda = diag(D);
omega = log(lamda);
% figure()
% plot(omega,'.'),hold on;
% refline([0 0]);
% line([0 0],[2,-2]);
[a,ind]=sort(abs(omega));
%%
x1 = data(:,1);
b = phi\x1;
time_dynamics = zeros(r,size(data,2));
t = linspace(1,1,size(data,2));
n_omega = 1;
total_bg = 0;
for i = 1:n_omega
    for j = 1:size(data,2)
        time_dynamics(:,j) = (b.*exp(omega(ind(i))*t(j)));
    end
    bg_dmd = phi*time_dynamics;
    total_bg = total_bg + bg_dmd;
end 
bg =  abs(total_bg);

fg = data - bg;
%%
resi = fg;
resi(resi>0) = 0;
fg_new = fg - resi;

%%
for i = 1:size(data,2)
    frame_dmd = data(:,i);
    frame_dmd_reshape = reshape(frame_dmd,size(bw,1),size(bw,2));
    pcolor(flipud(frame_dmd_reshape)), shading interp
    axis off;
    colormap(gray); drawnow; hold on;
    if i == 110
        saveas(gcf,'wangqiu.png')
    end 
end 

