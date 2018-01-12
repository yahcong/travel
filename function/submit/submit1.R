rm(list=ls(all=TRUE))

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/output/merge_Action_ActionOrder_Order.rda")
#仍有540个NA值，即没有被预测到
merge_Action_ActionOrder_Order$predict_type[is.na(merge_Action_ActionOrder_Order$predict_type)]=0
names(merge_Action_ActionOrder_Order)=c("userid","orderType")

sample = read.csv("data/sample.csv",fileEncoding = "UTF-8")
sample$orderType=merge_Action_ActionOrder_Order$orderType
sample$orderType=as.numeric(levels(sample$orderType)[sample$orderType])
write.csv(sample, file = "data/submit.csv", row.names = FALSE,fileEncoding = "UTF-8",quote=F)
#之后用notepad打开，将双引号全去掉