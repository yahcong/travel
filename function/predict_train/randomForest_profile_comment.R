rm(list=ls(all=TRUE))

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/output/train_userProfile_comment.rda")
orderFuture_train = fread("data/train/orderFuture_train.csv",encoding = "UTF-8")
