rm(list=ls(all=TRUE))

library(data.table)
setwd("F:/DataMining/R/travel")
userProfile_train=fread("data/train/userProfile_train.csv",encoding = "UTF-8")
load("data/output/train_new_orderHistory_hour.rda")

userProfile_train$userid=as.character(userProfile_train$userid)
train_new_orderHistory_hour_profile=merge(train_new_orderHistory_hour,userProfile_train[,c(1,3)],by="userid",all.x = T)
