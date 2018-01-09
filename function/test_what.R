rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")

load("model/randomForest2.rda")

library(randomForest)
test_action=new_aciton_test_hour
str(test_action)
test_action$predict_type=predict(fit2,test_action)
table(test_action$predict_type)

#-------------------predict----------------------#
load("data/output/new_userProfile_comment_test.rda")
