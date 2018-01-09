rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/output/test_aciton_orderHistory_hour.rda")

predict_result=merge(test_aciton_orderHistory_hour,result,by="userid",all=T)
#------------最后修正,可信度最高行为-------------------#
#检查预测结果中有多少个1
table(predict_result$orderType)

#根据以下两条规则，修正结果
#订单数据中最后一次的orderype->order_n1_Type 是1则future order type一定为1，
#订单数据中第一次的ordertype->order_p1_Type 是1则future order type一定为1
predict_result$orderType[predict_result$order_n1_Type==1]=1
predict_result$orderType[predict_result$order_p1_Type==1]=1
merge()

#检查修正后的结果中有多少个1，看看是否结果有所改变
table(predict_result$orderType)
