rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")

#评论数据---------------------------------------------------------------------------
#共有5个字段，分别是用户id，订单id，评分，标签，评论内容。
#其中受数据保密性约束，评论内容仅显示一些关键词。 
userComment_train=fread("data/trainingset/userComment_train.csv",encoding = "UTF-8")
#用户个人信息
#数据共有四列，分别是用户id、性别、省份、年龄段。
userProfile_train=fread("data/trainingset/userProfile_train.csv",encoding = "UTF-8")

#userid不用科学计数法
userComment_train$userid=as.character(userComment_train$userid)
userProfile_train$userid=as.character(userProfile_train$userid)

table(userComment_train$userid %in% userProfile_train$userid)
table(userProfile_train$userid %in% userComment_train$userid)

new_userProfile_comment_train=userProfile_train
new_userProfile_comment_train=merge(new_userProfile_comment_train,userComment_train,by = "userid",all = T)

orderHistory_train=fread("data/trainingset/orderHistory_train.csv",encoding = "UTF-8")
orderHistory_train$orderTime=as.POSIXct(orderHistory_train$orderTime, origin="1970-01-01 00:00:00")
orderHistory_train$userid=as.character(orderHistory_train$userid)
orderFuture_train = fread("data/trainingset/orderFuture_train.csv",encoding = "UTF-8")
orderFuture_train$userid=as.character(orderFuture_train$userid)

#保留最后一次订单
new_1orderHistory_train=NULL
for(userid_i in unique(orderHistory_train$userid)){
  #userid_i=100000001023
  sub=orderHistory_train[orderHistory_train$userid==userid_i,]
  sub=sub[nrow(sub),]
  new_1orderHistory_train=rbind(new_1orderHistory_train,sub)
}

#保留倒数第二次的订单
new_2orderHistory_train=NULL
for(userid_i in unique(orderHistory_train$userid)){
  #userid_i=100000001023
  sub=orderHistory_train[orderHistory_train$userid==userid_i,]
  sub=sub[nrow(sub)-1,]
  new_2orderHistory_train=rbind(new_2orderHistory_train,sub)
}
#保留倒数第三次的订单
new_3orderHistory_train=NULL
for(userid_i in unique(orderHistory_train$userid)){
  #userid_i=100000001023
  sub=orderHistory_train[orderHistory_train$userid==userid_i,]
  sub=sub[nrow(sub)-2,]
  new_3orderHistory_train=rbind(new_3orderHistory_train,sub)
}
#保留第一次的订单
new_4orderHistory_train=NULL
for(userid_i in unique(orderHistory_train$userid)){
  #userid_i=100000001023
  sub=orderHistory_train[orderHistory_train$userid==userid_i,]
  sub=sub[1,]
  new_4orderHistory_train=rbind(new_4orderHistory_train,sub)
}

new_userProfile_comment_train=merge(new_userProfile_comment_train,new_1orderHistory_train[,c(1,4)],by = "userid",all = T)
colnames(new_2orderHistory_train)[4]="2orderType"
colnames(new_3orderHistory_train)[4]="3orderType"
colnames(new_4orderHistory_train)[4]="4orderType"

new_userProfile_comment_train=merge(new_userProfile_comment_train,new_2orderHistory_train[,c(1,4)],by = "userid",all = T)
new_userProfile_comment_train=merge(new_userProfile_comment_train,new_3orderHistory_train[,c(1,4)],by = "userid",all = T)
new_userProfile_comment_train=merge(new_userProfile_comment_train,new_4orderHistory_train[,c(1,4)],by = "userid",all = T)

names(orderFuture_train)[2]="FutureOrderType"
new_userProfile_comment_train=merge(new_userProfile_comment_train,orderFuture_train,by = "userid",all = T)
save(new_userProfile_comment_train, file = "data/new_userProfile_comment_train.rda")



