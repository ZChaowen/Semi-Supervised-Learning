function [train_features, train_labels, test_features, test_labels] = Data_processing(ahu_data, Total_num, Data, Rand, fault_data, Tr_select)
chosen = [1,20,21,22,24,30,31,32,134];
train=[];
train_data =[]; 
test_data =[];
%Random selection of normal samples
N_data = ahu_data(1:Data,chosen);
n_rowrank = randperm(size(N_data, 1));
N_data = N_data(n_rowrank,:);
train_data = N_data(1:Rand,:);
%Randomly select fault samples
p = Data+1;
F_data = ahu_data(p:Total_num,:);
for i = p:fault_data:30240  
    a = i+(fault_data-1);
    b = Tr_select+1;
    Fn_data = ahu_data(i:a,chosen); 
    f_rowrank = randperm(size(Fn_data,1));  
    Fn_data = Fn_data(f_rowrank,:);
    Fn1_data = Fn_data(b:end,:);
    Fn_data = Fn_data(1:Tr_select,:); 
    train_data = [train_data;Fn_data]; 
    test_data = [test_data;Fn1_data];
end

train_features = train_data(:,2:end);
train_labels = train_data(:,1);
test_features = test_data(:,2:end);
test_labels = test_data(:,1);

%% --------- Normalized processing
[mtrain,ntrain] = size(train_features);
[mtest,ntest] = size(test_features);
dataset = [train_features;test_features];

[dataset_scale,ps] = mapminmax(dataset',0,1);
dataset_scale = dataset_scale';

train_features = dataset_scale(1:mtrain,:);
test_features = dataset_scale(mtrain+1:(mtrain+mtest),:);
