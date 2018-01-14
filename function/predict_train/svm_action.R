rm(list=ls(all=TRUE))

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/output/action_future.rda")

#训练 模型
library(e1071)
set.seed(100)
model_svm_orderHistory<-svm(orderType ~ ., data = action_future[,c(4:16)],
                            type="C-classification",kernel="radial",cost=10,gamma = 0.1)
model_svm_orderHistory=tune.svm(orderType ~., data = action_future[,c(4:16)], 
                                gamma = 10^(-6:-1), cost = 10^(1:2))


library(klaR)
Bmod <- svmlight(orderType ~ ., data = action_future[,c(4:16)],                  
                 svm.options = "-c 10 -t 2 -g 0.1 -v 0")


save(model_svm_orderHistory,file="model/model_svm_orderHistory.rda")

#预测
predict_result=action_future
predict_result$predict_type=predict(model_svm_orderHistory,predict_result[,c(4:15)])

#结果评估
library(AUC)
AUC::auc(roc(action_future$orderType,predict_result$predict_type))

#模型评估
#plot(model_svm_orderHistory, action_future[,c(2:6)], order_p1_Type ~ order_n1_Type)
summary(model_svm_orderHistory)

