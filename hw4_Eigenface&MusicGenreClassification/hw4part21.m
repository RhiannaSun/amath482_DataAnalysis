clear all; close all; clc;
%%
path = './music1/';
file = dir(path);
data = [];
for i = 3:8
    filename = file(i).name;
    [song, Fs] = audioread(strcat(path,'/',filename));
    song = song(:,1)+song(:,2);
    song = resample(song,20000,Fs);
    Fs=20000;
    parts = [];
    for j = 1:5:125
        five = song(Fs*j:Fs*(j+5),1);
        five_spec = abs(spectrogram(five));
        five_spec = reshape(five_spec,1,16385*8);
        parts = [parts five_spec'];
    end 
    data = [data parts];
end 

[u,s,v]=svd(data-mean(data(:)),'econ');

%plot(diag(s),'ko','Linewidth',[2])
plot3(v(1:50,3),v(1:50,4),v(1:50,5),'ko','Linewidth',[2]),hold on 
plot3(v(51:100,3),v(51:100,4),v(51:100,5),'ro','Linewidth',[2]);
plot3(v(101:150,3),v(101:150,4),v(101:150,5),'go','Linewidth',[2]);
xlabel('mode3'),ylabel('mode4'),zlabel('mode5'),

%%
knn_result = [];
for j = 1:1000
    q1 = randperm(50);
    q2 = randperm(50);
    q3 = randperm(50);

    xbtl = v(1:50,2:4);
    xcpn = v(51:100,2:4);
    xlana = v(101:end,2:4);
    xtrain = [xbtl(q1(1:30),:); xcpn(q2(1:30),:); xlana(q3(1:30),:)];
    xtest = [xbtl(q1(31:end),:); xcpn(q2(31:end),:); xlana(q3(31:end),:)];
    ctrain=[ones(30,1); 2*ones(30,1); 3*ones(30,1)];
    ctest=[ones(20,1); 2*ones(20,1); 3*ones(20,1)];
    
    index = knnsearch(xtrain, xtest,'K',3);
    correct = 0;
    prediction = [];
    for i = 1:length(index)
        knn3 = index(i,:);
        int_pre = [ctrain(knn3(1)) ctrain(knn3(2)) ctrain(knn3(3))];
        pre = mode(int_pre);
        prediction = [prediction pre];
        if pre == ctest(i,1)
            correct = correct+1;
        end
    end
%     subplot(4,1,j);
%     bar(prediction);
    accuracy = correct/length(index);
    knn_result = [knn_result accuracy];
%     title(['accuracy=',num2str(accuracy)]) 
end 
ave_knn_result = mean(knn_result)
var_knn_result = var(knn_result)
% saveas(gcf,'knn1.png')
%% Naive Bayes supreviese
nb_result = [];
for j = 1:1000 
    q1 = randperm(50);
    q2 = randperm(50);
    q3 = randperm(50);

    xbtl = v(1:50,2:4);
    xcpn = v(51:100,2:4);
    xlana = v(101:end,2:4);
    xtrain = [xbtl(q1(1:30),:); xcpn(q2(1:30),:); xlana(q3(1:30),:)];
    xtest = [xbtl(q1(31:end),:); xcpn(q2(31:end),:); xlana(q3(31:end),:)];
    ctrain=[ones(30,1); 2*ones(30,1); 3*ones(30,1)];
    ctest=[ones(20,1); 2*ones(20,1); 3*ones(20,1)];
    
    nb = fitcnb(xtrain,ctrain);
    pre = nb.predict(xtest);
    
    correct = 0;
    times = size(xtest,1);
    for i = 1:times
        if pre(i,1) == ctest(i,1)
            correct = correct+1;
        end 
    end 
    accuracy = correct/times;
    nb_result = [nb_result accuracy];
%     subplot(4,1,j);
%     bar(pre);
%     title(['accuracy=',num2str(accuracy)])
end 
ave_nb_result = mean(nb_result)
var_nb_result = var(nb_result)
% saveas(gcf,'nb1.png')
%% LDA supervise
lda_result = [];
for j = 1:1000 
    q1 = randperm(50);
    q2 = randperm(50);
    q3 = randperm(50);

    xbtl = v(1:50,2:4);
    xcpn = v(51:100,2:4);
    xlana = v(101:end,2:4);
    xtrain = [xbtl(q1(1:30),:); xcpn(q2(1:30),:); xlana(q3(1:30),:)];
    xtest = [xbtl(q1(31:end),:); xcpn(q2(31:end),:); xlana(q3(31:end),:)];
    ctrain=[ones(30,1); 2*ones(30,1); 3*ones(30,1)];
    ctest=[ones(20,1); 2*ones(20,1); 3*ones(20,1)];
    
    pre = classify(xtest,xtrain,ctrain);
    
    correct = 0;
    times = size(xtest,1);
    for i = 1:times
        if pre(i,1) == ctest(i,1)
            correct = correct+1;
        end 
    end 
    accuracy = correct/times;
    lda_result = [lda_result accuracy];
%     subplot(4,1,j);
%     bar(pre); 
%     title(['accuracy=',num2str(accuracy)])
end 
% saveas(gcf,'lda1.png')
ave_lda_result = mean(lda_result)
var_lda_result = var(lda_result)
