rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")

#评论数据---------------------------------------------------------------------------
#共有5个字段，分别是用户id，订单id，评分，标签，评论内容。
#其中受数据保密性约束，评论内容仅显示一些关键词。 
userComment_test=fread("data/test/userComment_test.csv",encoding = "UTF-8")
#用户个人信息
#数据共有四列，分别是用户id、性别、省份、年龄段。
userProfile_test=fread("data/test/userProfile_test.csv",encoding = "UTF-8")

#userid不用科学计数法
userComment_test$userid=as.character(userComment_test$userid)
userProfile_test$userid=as.character(userProfile_test$userid)

table(userComment_test$userid %in% userProfile_test$userid)
table(userProfile_test$userid %in% userComment_test$userid)

new_userProfile_comment_test=userProfile_test
new_userProfile_comment_test=merge(new_userProfile_comment_test,userComment_test,by = "userid",all = T)

orderHistory_test=fread("data/test/orderHistory_test.csv",encoding = "UTF-8")
orderHistory_test$orderTime=as.POSIXct(orderHistory_test$orderTime, origin="1970-01-01 00:00:00")
orderHistory_test$userid=as.character(orderHistory_test$userid)
orderFuture_test = fread("data/test/orderFuture_test.csv",encoding = "UTF-8")
orderFuture_test$userid=as.character(orderFuture_test$userid)

#保留最后一次订单
new_1orderHistory_test=NULL
for(userid_i in unique(orderHistory_test$userid)){
  #userid_i=100000001023
  sub=orderHistory_test[orderHistory_test$userid==userid_i,]
  sub=sub[nrow(sub),]
  new_1orderHistory_test=rbind(new_1orderHistory_test,sub)
}

#保留倒数第二次的订单
new_2orderHistory_test=NULL
for(userid_i in unique(orderHistory_test$userid)){
  #userid_i=100000001023
  sub=orderHistory_test[orderHistory_test$userid==userid_i,]
  sub=sub[nrow(sub)-1,]
  new_2orderHistory_test=rbind(new_2orderHistory_test,sub)
}
#保留倒数第三次的订单
new_3orderHistory_test=NULL
for(userid_i in unique(orderHistory_test$userid)){
  #userid_i=100000001023
  sub=orderHistory_test[orderHistory_test$userid==userid_i,]
  sub=sub[nrow(sub)-2,]
  new_3orderHistory_test=rbind(new_3orderHistory_test,sub)
}
#保留第一次的订单
new_4orderHistory_test=NULL
for(userid_i in unique(orderHistory_test$userid)){
  #userid_i=100000001023
  sub=orderHistory_test[orderHistory_test$userid==userid_i,]
  sub=sub[1,]
  new_4orderHistory_test=rbind(new_4orderHistory_test,sub)
}

new_userProfile_comment_test=merge(new_userProfile_comment_test,new_1orderHistory_test[,c(1,4)],by = "userid",all = T)
colnames(new_2orderHistory_test)[4]="2orderType"
colnames(new_3orderHistory_test)[4]="3orderType"
colnames(new_4orderHistory_test)[4]="4orderType"

new_userProfile_comment_test=merge(new_userProfile_comment_test,new_2orderHistory_test[,c(1,4)],by = "userid",all = T)
new_userProfile_comment_test=merge(new_userProfile_comment_test,new_3orderHistory_test[,c(1,4)],by = "userid",all = T)
new_userProfile_comment_test=merge(new_userProfile_comment_test,new_4orderHistory_test[,c(1,4)],by = "userid",all = T)

#--------------------------------------------------------------#
#
new_userProfile_comment_test=merge(new_userProfile_comment_test,orderFuture_test,by = "userid",all.y = T)
new_userProfile_comment_test$FutureOrderType= 0
save(new_userProfile_comment_test, file = "data/new_userProfile_comment_test.rda")



