rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")

load("data/new_userProfile_comment_train.rda")

#---------------------------------------------------------------------------#
#数据没有改变，只是分析一下future ordertype与 订单中order type的大致关系
#special_orderType=new_userProfile_comment_train
#special_orderType$orderType[is.na(special_orderType$orderType)] = 0
table(new_userProfile_comment_train$FutureOrderType)
#0     1 
#33682  6625 
table(new_userProfile_comment_train$orderType)
#   0    1 
#9165 1472 
table(new_userProfile_comment_train$`4orderType`)
#0    1 
#9579 1058 
special_1orderType=new_userProfile_comment_train[new_userProfile_comment_train$orderType!=
                                                   new_userProfile_comment_train$FutureOrderType]
#订单数据中最后一次的ordertype是1则future order type一定为1，
#但是ordertype是0时则future order type却不一定为0（潜在客户）。
special_2orderType=new_userProfile_comment_train[new_userProfile_comment_train$`4orderType`==0&
                                                   new_userProfile_comment_train$FutureOrderType==1,]
table(special_2orderType$rating)
#1    2    3 3.67    4 4.33    5 
#16    5   15    1   34    1 1204 
#新客户产生自评分为5分的用户
special_3orderType=new_userProfile_comment_train[new_userProfile_comment_train$`4orderType`==1&
                                                   new_userProfile_comment_train$FutureOrderType==0,]
#0个：代表订单数据中第一次的ordertype是1则future order type一定为1,反之不成立
special_4orderType=new_userProfile_comment_train[new_userProfile_comment_train$`4orderType`==1,]
table(special_4orderType$FutureOrderType)
#   1 
# 1058 
table(special_4orderType$orderType)
#   0    1 
# 49 1009 
special_5orderType=new_userProfile_comment_train[new_userProfile_comment_train$orderType==1&
                                                   new_userProfile_comment_train$`4orderType`!=1,]
special_6orderType=new_userProfile_comment_train[new_userProfile_comment_train$orderType!=1&
                                                   new_userProfile_comment_train$`4orderType`==1,]
special_7orderType=new_userProfile_comment_train[new_userProfile_comment_train$orderType!=1&
                                                   new_userProfile_comment_train$`4orderType`!=1&
                                                   new_userProfile_comment_train$`2orderType`!=1&
                                                   new_userProfile_comment_train$`3orderType`!=1&
                                                   new_userProfile_comment_train$FutureOrderType==1,]
special_8orderType=new_userProfile_comment_train[new_userProfile_comment_train$rating==5&
                                                   new_userProfile_comment_train$FutureOrderType==0,]
table(special_7orderType$rating)
#1    3 3.67    4    5 
#3    1    1    3  156 

#---------------------------------------------------------------------------#
#总结：
#第一次ordertype为1，则最后一次大概率也会为1，流失49/个。
#第一次ordertype为0，而最后一次为1，客户增加量共463个。
#订单数据中最后一次的ordertype是1则future order type一定为1，
#订单数据中第一次的ordertype是1则future order type一定为1,反之不成立
#订单中没出现1，而future order type出现1，其大部分数据，评分为5
#预测5分的评分用户，如何才能order type 为1
#---------------------------------------------------------------------------#
predict_type=new_userProfile_comment_train
predict_type$predict_order_type=0
predict_type$predict_order_type[predict_type$orderType==1]=1
predict_type$predict_order_type[predict_type$`4orderType`==1]=1
table(predict$predict_order_type)
#    0     1 
#38835  1472 
table(predict$FutureOrderType)
#0     1 
#33682  6625
a=predict_type[predict_type$FutureOrderType==1&predict_type$predict_order_type!=1,]
table(a$rating)
#   1    2    3 3.67    4 4.33    5 
# 13    4   16    1   29    1 1354 




