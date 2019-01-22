function [predict, position] = training(train_features_chosen, train_labels_chosen, test_features_chosen, test_labels_chosen, Confidence)
%% ----- Genetic algorithm to find the best parameters
% 
% ga_option.maxgen = 200;
% ga_option.sizepop = 20; 
% ga_option.cbound = [0,2000];
% ga_option.gbound = [0.001,100];
% ga_option.v = 5;
% ga_option.ggap = 0.9;
% 
% [bestacc,bestc,bestg] = gaSVMcgForClass(train_labels_chosen,train_features_chosen,ga_option);
% cmd = ['-c ',num2str(bestc),' -g ',num2str(bestg),' -b ',num2str(1)];
%% --------- Grid search method to find the best parameters
% [bestacc,bestc,bestg] = SVMcgForClass(train_labels_chosen,train_features_chosen,-10,10,-10,1);
% cmd = ['-c ',num2str(bestc),' -g ',num2str(bestg),' -b ',num2str(1)];
%% --------- training
count = 0; 
predict = [];
position = [];

while(1)    
     [te_n,te_m] = size(test_labels_chosen);
     delete = [];
     model = svmtrain(train_labels_chosen,train_features_chosen,'-c 1364.9139 -g 19.7425 -b 1');
%      model = svmtrain(train_labels_chosen,train_features_chosen,cmd);
%      model = svmtrain(train_labels_chosen,train_features_chosen,'-c 10 -g 1 -b 1');
     [predict_label,accuracy,dec_values] = svmpredict(test_labels_chosen,test_features_chosen,model,'-b 1');
     [max_dec_values,index] = max(dec_values,[],2);   %Get the maximum confidence per line
     [n,m] = size(max_dec_values);
%     [Confidence,ac] = optimization(max_dec_values,predict_label,test_labels_chosen);
     for i = 1:te_n
        if  max_dec_values(i) >= Confidence           %Select a sample with a confidence greater than the threshold
                train_features_chosen = [train_features_chosen;test_features_chosen(i,:)];
                train_labels_chosen = [train_labels_chosen;predict_label(i)];
                predict = [predict;predict_label(i)];
                position = [position;test_labels_chosen(i)];
                delete = [delete i];
         end
     end
     a = size(delete,2);
     if(a == 0)
         break;
     end    
     test_features_chosen(delete,:) = [];   %Remove from test set
     test_labels_chosen(delete) = [];       
     count = count+1;
end