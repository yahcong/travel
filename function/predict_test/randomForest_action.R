rm(list=ls(all=TRUE))

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/output/test_new_action_hour.rda")
#orderFuture_test = fread("data/test/orderFuture_test.csv",encoding = "UTF-8")
#orderFuture_test$userid=as.character(orderFuture_test$userid)

local_action=test_new_action_hour
str(local_action)
library(mice)
md.pattern(local_action)

#predict
#action_future=merge(local_action,orderFuture_test,by="userid",all.x = T)
action_future=local_action
library(randomForest)
load("model/model_randomForest_action.rda")
predict_result_action=action_future
predict_result_action$predict_type=predict(model_randomForest_action,predict_result_action)
save(predict_result_action,file="data/output/predict_result_action.rda")
load("data/output/predict_result_action.rda")