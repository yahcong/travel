rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/new_aciton_test_hour.rda")
load("model/randomForest2.rda")
test_action=new_aciton_test_hour
str(test_action)
#test_action$Future_type=as.factor(test_action$Future_type)
test_action$uesrid=as.character(test_action$uesrid)
test_action$length_time=as.numeric(test_action$length_time)

test_action$predict_type=predict(fit2,test_action)
str(test_action)
library(AUC)
AUC::auc(roc(train_action$Future_type,test_action$predict_type))
