rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
orderHistory_test=fread("data/test/orderHistory_test.csv",encoding = "UTF-8")
orderHistory_train=fread("data/train/orderHistory_train.csv",encoding = "UTF-8")

#——————————————————————————————————————————#
local_orderHistory=orderHistory_train
local_orderHistory$orderTime=as.POSIXct(local_orderHistory$orderTime, origin="1970-01-01 00:00:00")
local_orderHistory$userid=as.character(local_orderHistory$userid)
table(local_orderHistory$continent)
#北美洲 大洋洲   非洲 南美洲   欧洲   亚洲 
#  3432   2628     11      1   2527  12054
# local_orderHistory$continent[local_orderHistory$continent == "北美洲"] = "North America"
# local_orderHistory$continent[local_orderHistory$continent == "大洋洲"] = "Oceania"
# local_orderHistory$continent[local_orderHistory$continent == "非洲"] = "Africa"
# local_orderHistory$continent[local_orderHistory$continent == "南美洲"] = "South America"
# local_orderHistory$continent[local_orderHistory$continent == "欧洲"] = "Europe"
# local_orderHistory$continent[local_orderHistory$continent == "亚洲"] = "Asia"

#--------------------------------------------#
#保留最后一次订单
#new_1orderHistory_test=NULL
new_1orderHistory=NULL
for(userid_i in unique(local_orderHistory$userid)){
  #userid_i=100000001023
  sub=local_orderHistory[local_orderHistory$userid==userid_i,]
  sub=sub[nrow(sub),]
  new_1orderHistory=rbind(new_1orderHistory,sub)
}

#保留倒数第二次的订单
new_2orderHistory=NULL
for(userid_i in unique(local_orderHistory$userid)){
  #userid_i=100000001023
  sub=local_orderHistory[local_orderHistory$userid==userid_i,]
  sub=sub[nrow(sub)-1,]
  new_2orderHistory=rbind(new_2orderHistory,sub)
}
#保留倒数第三次的订单
new_3orderHistory=NULL
for(userid_i in unique(local_orderHistory$userid)){
  #userid_i=100000001023
  sub=local_orderHistory[local_orderHistory$userid==userid_i,]
  sub=sub[nrow(sub)-2,]
  new_3orderHistory=rbind(new_3orderHistory,sub)
}
#保留第一次的订单
new_4orderHistory=NULL
for(userid_i in unique(local_orderHistory$userid)){
  #userid_i=100000001023
  sub=local_orderHistory[local_orderHistory$userid==userid_i,]
  sub=sub[1,]
  new_4orderHistory=rbind(new_4orderHistory,sub)
}
colnames(new_1orderHistory)[4]="order_n1_Type"
colnames(new_2orderHistory)[4]="order_n2_Type"
colnames(new_3orderHistory)[4]="order_n3_Type"
colnames(new_4orderHistory)[4]="order_p1_Type"

new_orderHistory=local_orderHistory[,c(1:3,5:7)]
new_orderHistory=merge(new_orderHistory,new_4orderHistory[,c(1,4)],by="userid",all=T)
new_orderHistory=merge(new_orderHistory,new_1orderHistory[,c(1,4)],by="userid",all=T)
new_orderHistory=merge(new_orderHistory,new_2orderHistory[,c(1,4)],by="userid",all=T)
new_orderHistory=merge(new_orderHistory,new_3orderHistory[,c(1,4)],by="userid",all=T)

train_new_orderHistory=new_orderHistory
save(train_new_orderHistory,file="data/output/train_new_orderHistory.rda")
load("data/output/train_new_orderHistory.rda")

library(lubridate)
train_new_orderHistory_hour=train_new_orderHistory
train_new_orderHistory_hour$order_hour=hour(train_new_orderHistory_hour$orderTime)+minute(train_new_orderHistory_hour$orderTime)%/%30
train_new_orderHistory_hour$order_hour[train_new_orderHistory_hour$order_hour==24]=0
train_new_orderHistory_hour$order_hour=as.factor(train_new_orderHistory_hour$order_hour)

save(train_new_orderHistory_hour, file = "data/output/train_new_orderHistory_hour.rda")
load("data/output/train_new_orderHistory_hour.rda")
