rm(list=ls(all=TRUE))

library(data.table)
setwd("F:/DataMining/R/travel")
orderFuture_train = fread("data/train/orderFuture_train.csv",encoding = "UTF-8")
load("data/output/train_new_action_hour.rda")

local_action=train_new_action_hour
str(local_action)
library(mice)
md.pattern(local_action)
orderFuture_train$userid=as.character(orderFuture_train$userid)
action_future=merge(local_action,orderFuture_train,by="userid",all.x = T)
action_future$orderType=as.factor(action_future$orderType)
library(randomForest)
str(action_future)
md.pattern(action_future)

#train
set.seed(100)
model_randomForest_action=randomForest(orderType ~ ., data = action_future,importance=TRUE,ntree=100)
save(model_randomForest_action,file="model/model_randomForest_action.rda")
load("model/model_randomForest_action.rda")

#predict
predict_result=action_future
predict_result$predict_type=predict(model_randomForest_action,predict_result)
library(AUC)
AUC::auc(roc(action_future$orderType,predict_result$predict_type))

#-------Model evaluation-----------3
library(ROCR)
predict_value=as.numeric(predict_result$predict_type)
true_value=as.numeric(action_future$orderType)
perf = prediction(predict_value,true_value)
#1. Area under curve
auc = performance(perf, "auc")
#2. True Positive and Negative Rate
pred = performance(perf, "tpr","fpr")
print(auc)
print(pred)
#3. Plot the ROC curve
plot(pred,main="ROC Curve for Random Forest",col=2,lwd=2)
abline(a=0,b=1,lwd=2,lty=2,col="gray")

retrieved=sum(predict_value)  
precision=sum(true_value & predict_value)/retrieved  
recall=sum(predict_value & true_value)/sum(true_value)  
F_measure=2*precision*recall/(precision+recall)#计算Recall，Precision和F-measure  
cat("model_randomForest_action retrieved=",retrieved,"\n")  
cat("model_randomForest_action precision=",precision,"\n")  
cat("model_randomForest_action recall=",recall,"\n")  
cat("model_randomForest_action F_measure=",F_measure,"\n")  

#对TPR（True Positive Rate）和FPR（False Positive Rate）的计算：  
TPR=sum(true_value & predict_value)/sum(true_value)#实际上和Recall相等
FPR=(sum(predict_value)-sum(true_value & predict_value))/(length(true_value)-sum(true_value))  
cat("model_randomForest_action TPR=",TPR,"\n")  
cat("model_randomForest_action FPR=",FPR,"\n")  

#模型表现
summary(model_randomForest_action)
model_randomForest_action$importance
importance(model_randomForest_action)
varImpPlot(model_randomForest_action)
#Higher the value of mean decrease accuracy or mean decrease gini score , 
#higher the importance of the variable in the model. 
#Gini指数：基尼指数是一种数据的不纯度的度量方法
#我们把Gini(R)增量最大的属性作为最佳分裂属性。


#?MDSplot 函数用于实现随机森林的可视化
#MDSplot(model_randomForest_action,action_future$orderType)
