clear all; close all; clc;
%%
path = './music3/';
file = dir(path);
data = [];
for i = 3:20
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

%%
[m,n]=size(data); % compute data size
mn=mean(data,2); % compute mean for each row
data=data-repmat(mn,1,n); % subtract mean
[u,s,v]=svd(data,'econ');

plot(diag(s),'ko','Linewidth',[2])

third = n /3; 
plot3(v(1:third,2),v(1:third,3),v(1:third,4),'ko','Linewidth',[2]),hold on 
plot3(v((third+1):2*third,2),v((third+1):2*third,3),v((third+1):2*third,4),'ro','Linewidth',[2]);
plot3(v((2*third+1):end,2),v((2*third+1):end,3),v((2*third+1):end,4),'go','Linewidth',[2]);
xlabel('mode2'),ylabel('mode3'),zlabel('mode4');

%%
knn_result = [];
for j = 1:1000
    
    q1 = randperm(third);
    q2 = randperm(third);
    q3 = randperm(third);

    xbtl = v(1:third,2:4);
    xcpn = v((third+1):(2*third),2:4);
    xlana = v((2*third+1):end,2:4);
    num_train = third*(3/5);
    num_test = third*(2/5);
    xtrain = [xbtl(q1(1:num_train),:); xcpn(q2(1:num_train),:); xlana(q3(1:num_train),:)];
    xtest = [xbtl(q1((num_train+1):end),:); xcpn(q2((num_train+1):end),:); xlana(q3((num_train+1):end),:)];
    ctrain=[ones(num_train,1); 2*ones(num_train,1); 3*ones(num_train,1)];
    ctest=[ones(num_test,1); 2*ones(num_test,1); 3*ones(num_test,1)];
    
    index = knnsearch(xtrain, xtest,'K',3);
    correct = 0;
    for i = 1:length(index)
        knn3 = index(i,:);
        int_pre = [ctrain(knn3(1)) ctrain(knn3(2)) ctrain(knn3(3))];
        pre = mode(int_pre);
        if pre == ctest(i,1)
            correct = correct+1;
        end
    end
    accuracy = correct/length(index);
    knn_result = [knn_result accuracy];
end 
ave_knn_result = mean(knn_result)
var_knn_result = var(knn_result)
%% Naive Bayes supreviese
nb_result = [];
for j = 1:1000
    
    q1 = randperm(third);
    q2 = randperm(third);
    q3 = randperm(third);

    xbtl = v(1:third,2:4);
    xcpn = v((third+1):(2*third),2:4);
    xlana = v((2*third+1):end,2:4);
    num_train = third*(3/5);
    num_test = third*(2/5);
    xtrain = [xbtl(q1(1:num_train),:); xcpn(q2(1:num_train),:); xlana(q3(1:num_train),:)];
    xtest = [xbtl(q1((num_train+1):end),:); xcpn(q2((num_train+1):end),:); xlana(q3((num_train+1):end),:)];
    ctrain=[ones(num_train,1); 2*ones(num_train,1); 3*ones(num_train,1)];
    ctest=[ones(num_test,1); 2*ones(num_test,1); 3*ones(num_test,1)];
    
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
end 
ave_nb_result = mean(nb_result)
var_nb_result = var(nb_result)
%% LDA supervise
lda_result = [];
for j = 1:1000
 
    q1 = randperm(third);
    q2 = randperm(third);
    q3 = randperm(third);

    xbtl = v(1:third,2:4);
    xcpn = v((third+1):(2*third),2:4);
    xlana = v((2*third+1):end,2:4);
    num_train = third*(3/5);
    num_test = third*(2/5);
    xtrain = [xbtl(q1(1:num_train),:); xcpn(q2(1:num_train),:); xlana(q3(1:num_train),:)];
    xtest = [xbtl(q1((num_train+1):end),:); xcpn(q2((num_train+1):end),:); xlana(q3((num_train+1):end),:)];
    ctrain=[ones(num_train,1); 2*ones(num_train,1); 3*ones(num_train,1)];
    ctest=[ones(num_test,1); 2*ones(num_test,1); 3*ones(num_test,1)];
    
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
end 
ave_lda_result = mean(lda_result)
var_lda_result = var(lda_result)