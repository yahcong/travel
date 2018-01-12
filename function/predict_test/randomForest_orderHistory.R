rm(list=ls(all=TRUE))

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/output/test_new_orderHistory_hour.rda")
#orderFuture_test = fread("data/test/orderFuture_test.csv",encoding = "UTF-8")
#orderFuture_test$userid=as.character(orderFuture_test$userid)


#order_n2_type和order_n2_type的缺失值过多，直接去掉了这两个属性
#city country continent是从小到大的包含关系(三个属性选择其中一个就可以)，先尝试使用continent
#continent有六种，country有51种.city有205种
#字符带来的NAs？
local_orderHistory=test_new_orderHistory_hour[,c(1,6,7,8,11)]
local_orderHistory$continent=as.factor(local_orderHistory$continent)
str(local_orderHistory)
library(mice)
md.pattern(local_orderHistory)

#predict
#随机森林randomForest
library(randomForest)
load("model/model_randomForest_orderHistory.rda")                                
predict_result_orderHistory=local_orderHistory
predict_result_orderHistory$predict_type=predict(model_randomForest_orderHistory,
                                                 predict_result_orderHistory[,c(2:5)])
save(predict_result_orderHistory,file="data/output/predict_result_orderHistory.rda")
load("data/output/predict_result_orderHistory.rda")

table(predict_result_orderHistory$predict_type[predict_result_orderHistory$order_p1_Type==1])
#0   1 
#0 333 
table(predict_result_orderHistory$predict_type[predict_result_orderHistory$order_n1_Type==1])
#0   1 
#0 800 

