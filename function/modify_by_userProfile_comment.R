rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/output/test_userProfile_comment.rda")

predict_result=merge(test_userProfile_comment,result,by="userid",all=T)
#------------最后修正,可信度最高行为-------------------#
#检查预测结果中有多少个1
table(predict_result$orderType)

#-------------------修正------------------------#
#。。。。。#

#检查修正后的结果中有多少个1，看看是否结果有所改变
table(predict_result$orderType)
