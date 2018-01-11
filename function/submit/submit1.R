rm(list=ls(all=TRUE))

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/output/merge_Action_ActionOrder_Order.rda")
#仍有540个NA值，即没有被预测到
merge_Action_ActionOrder_Order$predict_type[is.na(merge_Action_ActionOrder_Order$predict_type)]=0
names(merge_Action_ActionOrder_Order)=c("userid","orderType")
merge_Action_ActionOrder_Order$userid=as.numeric(merge_Action_ActionOrder_Order$userid)
write.csv(merge_Action_ActionOrder_Order, file = "data/merge_Action_ActionOrder_Order.csv",
          row.names = FALSE,fileEncoding = "UTF-8")

options(scipen = 200)
orderFuture_test = fread("data/test/orderFuture_test.csv",encoding = "UTF-8")
orderFuture_test$orderType=merge_Action_ActionOrder_Order$orderType

write.csv(orderFuture_test, file = "data/orderFuture_test.csv", row.names = FALSE,fileEncoding = "UTF-8")
orderFuture_test = fread("data/orderFuture_test.csv",encoding = "UTF-8")
