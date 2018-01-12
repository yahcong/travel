rm(list=ls(all=TRUE))

library(data.table)
setwd("F:/DataMining/R/travel")
orderFuture_test = fread("data/test/orderFuture_test.csv",encoding = "UTF-8")
orderFuture_test$userid=as.character(orderFuture_test$userid)

load("data/output/predict_result_orderHistory.rda")
load("data/output/predict_result_action.rda")
load("data/output/predict_result_action_orderHistory.rda")

#采用Hmisc中的包
#对数据集进行描述
library(Hmisc)
describe(predict_result_orderHistory)
describe(predict_result_action)
describe(predict_result_action_orderHistory

str(predict_result_orderHistory)
str(predict_result_action)
str(predict_result_action_orderHistory)

result1=merge(orderFuture_test,predict_result_action[,c(1,16)],by="userid",all.x = T)
length(unique(result1$userid))
result2=merge(orderFuture_test,predict_result_action_orderHistory[,c(1,19)],by="userid",all.x = T)
length(unique(result2$userid))
result3=merge(orderFuture_test,predict_result_orderHistory[,c(1,6)],by="userid",all.x = T)
length(unique(result3$userid))

#对result1，result2，result3的userid去重，predict_type取众数
#local_result=result1
#local_result=result2
#local_result=result3
for(user_i in unique(local_result$userid)){
  print(user_i)
  
  local_result$predict_type[local_result$userid==user_i&!is.na(local_result$predict_type)]=
    names(which.max(table(local_result$predict_type[local_result$userid==user_i&!is.na(local_result$predict_type)])))
  
}
local_result$predict_type=as.factor(local_result$predict_type)
# result1=local_result[!duplicated(local_result),]
# result2=local_result[!duplicated(local_result),]
# result3=local_result[!duplicated(local_result),]

length(which(is.na(result1$predict_type)))
length(which(is.na(result2$predict_type)))
length(which(is.na(result3$predict_type)))

result=result3
result$predict_type[is.na(result$predict_type)]=result2$predict_type[which(is.na(result$predict_type))]
length(which(is.na(result$predict_type)))
result$predict_type[is.na(result$predict_type)]=result1$predict_type[which(is.na(result$predict_type))]
length(which(is.na(result$predict_type)))

merge_Action_ActionOrder_Order=result
save(merge_Action_ActionOrder_Order,file = "data/output/merge_Action_ActionOrder_Order.rda")
load("data/output/merge_Action_ActionOrder_Order.rda")
#仍有540个NA值，即没有被预测到