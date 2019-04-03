clear all; close all; clc;
%%
M=[];
for i = 1:39
    if i<10
        file_name = strcat('CroppedYale/yaleB0',num2str(i),'/');
    else
        file_name = strcat('CroppedYale/yaleB',num2str(i),'/');
    end
    file = dir(file_name);
    
    for j = 1:length(file)
        if file(j).bytes>0
            data = imread(strcat(file_name,'/',file(j).name));
            data_col = reshape(data,[],1);
            M = [M data_col];
        end
    end
end
M=double(M);
%%
% [m,n]=size(M); % compute data size
% mn=mean(M,2); % compute mean for each row
% M=M-repmat(mn,1,n); % subtract mean
    
[u1,s1,v1]=svd(M-mean(M(:)),'econ'); % perform the SVD
%%
% plot(diag(s),'ko','Linewidth',[2]);
% set(gca,'Xlim',[0,50]);
energy1=diag(s1)/sum(diag(s1));
figure()
plot(energy1,'ko')
set(gca,'Xlim',[1,50])
xlabel('mode'); ylabel('energy percentage(%)')
saveas(gcf,'mode1.png')
%%
figure()
for i=1:9
    subplot(3,3,i)
    face1 = reshape(u1(:,i),192,168);
    pcolor(flipud(face1)), shading interp, colormap(gray);
    title(['eigenface',num2str(i)])
end
saveas(gcf,'eigenface1.png')
%%
for j = 1:2400
    if sum(energy1(1:j))>0.9
        break
    end 
end 
%%
u1_new = u1(:,1:j);
s1_new = s1(1:j,1:j);
v1_new = v1(:,1:j);

new1 = u1_new*s1_new*v1_new';


%% Uncropped
path = 'UncroppedYale/yalefaces/';
file = dir(path);
M2=[];
for i = 1:length(file)
    if file(i).bytes > 0 
        filename = file(i).name;
        data = imread(strcat(path,filename));
        data_col = reshape(data,[],1);
        M2 = [M2 data_col];
    end 
end
M2 = double(M2);
%%
[m,n]=size(M2); % compute data size
mn=mean(M2,2); % compute mean for each row
M2=M2-repmat(mn,1,n); % subtract mean
    
[u2,s2,v2]=svd(M2-mean(M2(:)),'econ'); % perform the SVD
% plot(diag(s),'ko','Linewidth',[2]);
% set(gca,'Xlim',[0,50]);
energy2=diag(s2)/sum(diag(s2));
%%
figure()
plot(energy2,'ko')
set(gca,'Xlim',[1,50])
xlabel('mode'); ylabel('energy percentage(%)')
saveas(gcf,'mode2.png')
%%
figure()
for i=1:9
    subplot(3,3,i)
    face1 = reshape(u2(:,i),243,320);
    pcolor(flipud(face1)), shading interp, colormap(gray);
    title(['eigenface',num2str(i)])
end
saveas(gcf,'eigenface2.png')
%%
for rank2 = 1:2400
    if sum(energy2(1:rank2))>0.9
        break
    end 
end 
%%
u2_new = u2(:,1:rank2);
s2_new = s2(1:rank2,1:rank2);
v2_new = v2(:,1:rank2);

new2 = u2_new*s2_new*v2_new';
%%
figure()
subplot(2,2,1)
face_old1=reshape(M(:,1),192,168); % pull out modes 
pcolor(flipud(face_old1)), shading interp, colormap(gray);
title('first image in original cropped data')
subplot(2,2,2)
face_new1=reshape(new1(:,1),192,168); % pull out modes 
pcolor(flipud(face_new1)), shading interp, colormap(gray);
title('first image in compressed cropped data')
subplot(2,2,3)
face_old2=reshape(M2(:,14),243,320); % pull out modes 
pcolor(flipud(face_old2)), shading interp, colormap(gray);
title('14th image in original uncropped data')
subplot(2,2,4)
face_new2=reshape(new2(:,14),243,320); % pull out modes 
pcolor(flipud(face_new2)), shading interp, colormap(gray);
title('14th image in compressed uncropped data')
saveas(gcf,'result.png')
