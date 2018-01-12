rm(list=ls(all=TRUE))

library(data.table)
setwd("F:/DataMining/R/travel")
orderFuture_train = fread("data/train/orderFuture_train.csv",encoding = "UTF-8")
load("data/output/train_new_orderHistory_hour.rda")

#order_n2_type和order_n2_type的缺失值过多，直接去掉了这两个属性
#city country continent是从小到大的包含关系(三个属性选择其中一个就可以)，先尝试使用continent
#continent有六种，country有51种.city有205种
#字符带来的NAs？
local_orderHistory=train_new_orderHistory_hour[,c(1,6,7,8,11)]
#local_orderHistory=as.data.frame(local_orderHistory)
local_orderHistory$continent=as.factor(local_orderHistory$continent)

orderFuture_train$userid=as.character(orderFuture_train$userid)
str(local_orderHistory)
str(orderFuture_train)
library(mice)
md.pattern(local_orderHistory)

orderHistory_future=merge(local_orderHistory,orderFuture_train,by="userid",all.x = T)
orderHistory_future$orderType=as.factor(orderHistory_future$orderType)
library(randomForest)
str(orderHistory_future)
md.pattern(orderHistory_future)

#有缺失值，故可以用能处理缺失值的randomForest包party
library(party)
set.seed(42)

#构建决策树
orderHistory_ctree<-ctree(orderType ~.,data=orderHistory_future)
save(orderHistory_ctree,file="data/output/orderHistory_ctree.rda")
#构建完的决策树图
plot(orderHistory_ctree)
#决策树案例拟合图
plot(orderHistory_ctree, type="simple")

#随机森林randomForest
names(orderHistory_future)
#[1] "userid"     "orderid"    "orderTime"  "continent"  "order_hour" "orderType"
model_randomForest_orderHistory<-randomForest(orderType ~ ., data = orderHistory_future[,c(2:6)],ntree=100)
save(model_randomForest_orderHistory,file="model/model_randomForest_orderHistory.rda")
load("model/model_randomForest_orderHistory.rda")                

#predict
predict_result=orderHistory_future
#cforest的模型会出现错误
#Error in OOB && is.null(newdata) : invalid 'x' type in 'x && y'
#predict_result$predict_type=predict(model_randomForest_orderHistory,predict_result)
predict_result$predict_type=predict(model_randomForest_orderHistory,predict_result)
library(AUC)
AUC::auc(roc(orderHistory_future$orderType,predict_result$predict_type))

#-------Model evaluation-----------3
library(ROCR)
predict_value=as.numeric(predict_result$predict_type)
true_value=as.numeric(orderHistory_future$orderType)
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
cat("model_randomForest_orderHistory retrieved=",retrieved,"\n")  
cat("model_randomForest_orderHistory precision=",precision,"\n")  
cat("model_randomForest_orderHistory recall=",recall,"\n")  
cat("model_randomForest_orderHistory F_measure=",F_measure,"\n")  

#对TPR（True Positive Rate）和FPR（False Positive Rate）的计算：  
TPR=sum(true_value & predict_value)/sum(true_value)#实际上和Recall相等
FPR=(sum(predict_value)-sum(true_value & predict_value))/(length(true_value)-sum(true_value))  
cat("model_randomForest_action TPR=",TPR,"\n")  
cat("model_randomForest_action FPR=",FPR,"\n")

#模型表现
varimpt<-data.frame(varimp(model_randomForest_orderHistory))  
save(varimpt,file="data/output/varimpt.rda")
summary(model_randomForest_orderHistory)
model_randomForest_orderHistory$importance
importance(model_randomForest_orderHistory)
varImpPlot(model_randomForest_orderHistory)
#Higher the value of mean decrease accuracy or mean decrease gini score , 
#higher the importance of the variable in the model. 
#Gini指数：基尼指数是一种数据的不纯度的度量方法
#我们把Gini(R)增量最大的属性作为最佳分裂属性。

#?MDSplot 函数用于实现随机森林的可视化
#MDSplot(model_randomForest_orderHistory,orderHistory_future$orderType)

