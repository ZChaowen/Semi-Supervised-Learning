function [Chosen] = SFS(ahu_data, Feature_num, aa, class)
for i=1:Feature_num 
     feature{i}=ahu_data(:,i);   
 end
label =ahu_data(:,1);   %Get class labels
[m n]=size(ahu_data);
chosen=[1,20,21,22,30,31,32,55,125,126,134];   %Selected feature
for ii=1:class
    cs(ii).d=ahu_data(find(label==ii),:);           %17 classes, data for each class
    cs(ii).l=label(find(label==ii));           %17 classes, labels for each class
end

for j=1:aa                             %Selected feature 
    J=zeros([1 n]);
  for i=1:n                          
    [mm nn]=size(chosen);     
    for p=1:nn
        if i==chosen(p)
            J(i)=0; 
            break;
        else 
               J(i)=J(i)-sum(sum((feature{i}-feature{chosen(p)}).^2));
        end
    end
  end
  mi=min(J);
  for i=1:n
      if J(i)==0
           J(i)=mi;
      end
  end
  ma=max(J);
   for i=1:n
      if J(i)==ma
          chosen = [chosen i];
           break;
      end
   end
   [cm,cn]=size(chosen);
   for ww=1:cn
      feature{ww}=ahu_data(:,chosen(ww));
   end
end
Chosen = chosen;