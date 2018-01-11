rm(list=ls(all=TRUE))

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/output/test_aciton_orderHistory_hour.rda")
#orderFuture_test = fread("data/test/orderFuture_test.csv",encoding = "UTF-8")
#orderFuture_test$userid=as.character(orderFuture_test$userid)

#city country continent是从小到大的包含关系(三个属性选择其中一个就可以)，先尝试使用continent
#order_n2_type和order_n2_type的缺失值过多，暂时直接去掉了这两个属性
local_test_aciton_orderHistory=test_aciton_orderHistory_hour[,c(1:13,16:18,21,22)]
local_test_aciton_orderHistory$continent=as.factor(local_test_aciton_orderHistory$continent)
library(mice)
md.pattern(local_test_aciton_orderHistory)

#predict
#action_orderHistory_future=merge(local_test_aciton_orderHistory,orderFuture_test,by="userid",all.x = T)
action_orderHistory_future=local_test_aciton_orderHistory
library(randomForest)
load("model/model_randomForest_orderHistory.rda")
predict_result_action_orderHistory=action_orderHistory_future
predict_result_action_orderHistory$predict_type=predict(model_randomForest_orderHistory,predict_result_action_orderHistory)
save(predict_result_action_orderHistory,file="data/output/predict_result_action_orderHistory.rda")
load("data/output/predict_result_action_orderHistory.rda")
