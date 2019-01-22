clear;
clc;
load 'AHU.mat';
total_num = size(AHU,1);        %Sum of samples
feature_num = size(AHU,2);      %Number of features
Con = 0.5;              %Confidence threshold                                                                                                                                              5
data = 21600;                     %Number of normal samples
rand = 8000;
Fault_data = 1440;              %Number of fault samples per type
% start = 2;
A = 2;
Class = 7;
AC = [];
%% ---------------SFS  
%Chosen = SFS(AHU, feature_num, Class, A);
for i = 5:5:55
    tr_select = i;                 %Number of fault samples selected for each type
%% -------- Feature import
    [Train_features_chosen, Train_labels_chosen, Test_features_chosen, Test_labels_chosen] = Data_processing(AHU, total_num, data, rand, Fault_data, tr_select);

%% --------- training
    [predict, position] = training(Train_features_chosen, Train_labels_chosen, Test_features_chosen, Test_labels_chosen, Con);
%% -------------- Calculation accuracy
    time = 0;
    compare = size(predict);              %Compare is the number of predicted labels
    for i = 1:compare
        if(position(i) == predict(i))
            time = time+1;                %Time is the actual class number of tags
        end
    end
    S = time/compare(:,1);
    AC = [AC S];
end
fprintf('===========================>>>>>>>>>>')
fprintf('\n')
[~,ac_size] = size(AC);
for i = 1:ac_size
    fprintf('Accuracy')
    fprintf(num2str(i))
    fprintf(' = %d ', AC(i))
    fprintf('\n')
end