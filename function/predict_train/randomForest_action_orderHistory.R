rm(list=ls(all=TRUE))

library(data.table)
setwd("F:/DataMining/R/travel")
orderFuture_train = fread("data/train/orderFuture_train.csv",encoding = "UTF-8")
orderFuture_train$userid=as.character(orderFuture_train$userid)
load("data/output/train_aciton_orderHistory_hour.rda")

#city country continent是从小到大的包含关系(三个属性选择其中一个就可以)，先尝试使用continent
#order_n2_type和order_n2_type的缺失值过多，暂时直接去掉了这两个属性
local_train_aciton_orderHistory=train_aciton_orderHistory_hour[,c(1:13,16:18,21,22)]
local_train_aciton_orderHistory$continent=as.factor(local_train_aciton_orderHistory$continent)

library(mice)
md.pattern(local_train_aciton_orderHistory)

action_orderHistory_future=merge(local_train_aciton_orderHistory,orderFuture_train,by="userid",all.x = T)
action_orderHistory_future$orderType=as.factor(action_orderHistory_future$orderType)
action_orderHistory_future=action_orderHistory_future[,c(2:19)]
library(randomForest)
str(action_orderHistory_future)
md.pattern(action_orderHistory_future)

set.seed(100)
model_randomForest_orderHistory<-randomForest(orderType ~ ., data = action_orderHistory_future,ntree=100)
save(model_randomForest_orderHistory,file="model/model_randomForest_orderHistory.rda")
load("model/model_randomForest_orderHistory.rda")

#predict
model=model_randomForest_orderHistory
predict_result=action_orderHistory_future
predict_result$predict_type=predict(model,predict_result)

library(AUC)
AUC::auc(roc(action_orderHistory_future$orderType,predict_result$predict_type))

library(ROCR)
predict_value=as.numeric(predict_result$predict_type)
true_value=as.numeric(action_orderHistory_future$orderType)

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
cat("retrieved=",retrieved,"\n")  
cat("precision=",precision,"\n")  
cat("recall=",recall,"\n")  
cat("F_measure=",F_measure,"\n")  

#对TPR（True Positive Rate）和FPR（False Positive Rate）的计算：  
TPR=sum(true_value & predict_value)/sum(true_value)#实际上和Recall相等
FPR=(sum(predict_value)-sum(true_value & predict_value))/(length(true_value)-sum(true_value))  
cat(",TPR=",TPR,"\n")  
cat(",FPR=",FPR,"\n")

#模型表现
save(varimpt,file="data/output/varimpt.rda")
summary(model)
model$importance
importance(model)
varImpPlot(model)
#Higher the value of mean decrease accuracy or mean decrease gini score , 
#higher the importance of the variable in the model. 
#Gini指数：基尼指数是一种数据的不纯度的度量方法
#我们把Gini(R)增量最大的属性作为最佳分裂属性。

#?MDSplot 函数用于实现随机森林的可视化
#MDSplot(model_randomForest_orderHistory,orderHistory_future$orderType)

