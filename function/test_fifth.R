rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/new_userProfile_comment_test.rda")

result=new_userProfile_comment_test
#订单数据中最后一次的ordertype是1则future order type一定为1，
result$FutureOrderType[result$orderType==1]=1
#订单数据中第一次的ordertype是1则future order type一定为1
result$FutureOrderType[result$`4orderType`==1]=1
