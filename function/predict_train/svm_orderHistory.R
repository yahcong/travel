rm(list=ls(all=TRUE))

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/output/orderHistory_future.rda")

#训练 模型
library(e1071)
model_svm_orderHistory<-svm(orderType ~ ., data = orderHistory_future[,c(2:6)])
save(model_svm_orderHistory,file="model/model_svm_orderHistory.rda")
load("model/model_svm_orderHistory.rda")
#预测
predict_result=orderHistory_future
predict_result$predict_type=predict(model_svm_orderHistory,predict_result[,c(2:5)])

#结果评估
library(AUC)
AUC::auc(roc(predict_result$orderType,predict_result$predict_type))
FP=predict_result[predict_result$orderType==0&predict_result$predict_type==1,]
FN=predict_result[predict_result$orderType==1&predict_result$predict_type==0,]
#FP个数为0，FN个数为3557

#将预测值作于属性再训练
model_svm_orderHistory2<-svm(orderType ~ ., data = predict_result[,c(2:7)])
predict_result2=predict_result
predict_result2$predict_type2=predict(model_svm_orderHistory2,predict_result2[,c(2,3,4,5,7)])
#结果评估
library(AUC)
AUC::auc(roc(predict_result2$orderType,predict_result2$predict_type2))
FP=predict_result[predict_result2$orderType==0&predict_result2$predict_type2==1,]
FN=predict_result[predict_result2$orderType==1&predict_result2$predict_type2==0,]
#没有改变


#模型评估
#plot(model_svm_orderHistory, orderHistory_future[,c(2:6)], order_p1_Type ~ order_n1_Type)
summary(model_svm_orderHistory)
