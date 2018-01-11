rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/output/train_new_orderHistory_hour.rda")
load("data/output/train_new_action_hour.rda")

#merge train_new_aciton and train_new_orderHistory_hour to aciton_orderHistory -------#
# aciton_orderHistory=train_new_action_hour

aciton_orderHistory=NULL
for(userid_i in unique(train_new_orderHistory_hour$userid) ){
  #userid_i=100000000013
  print(userid_i)
  #train_new_orderHistory_hour[train_new_orderHistory_hour$userid==userid_i]$orderid
  for(orderid_i in train_new_orderHistory_hour[train_new_orderHistory_hour$userid==userid_i]$orderid){
    #orderid_i=1000015
    print(orderid_i)
    order_sub=train_new_orderHistory_hour[train_new_orderHistory_hour$userid==userid_i&train_new_orderHistory_hour$orderid==orderid_i]
    action_sub=train_new_action_hour[train_new_action_hour$userid==userid_i&
                                 train_new_action_hour$starttime<order_sub$orderTime&
                                 train_new_action_hour$endtime>order_sub$orderTime,]
    if(nrow(action_sub)>0){
      aciton_orderHistory_sub=merge(action_sub,order_sub,by="userid",all=T)
      aciton_orderHistory=rbind(aciton_orderHistory,aciton_orderHistory_sub)
    }
  }
}

train_aciton_orderHistory=aciton_orderHistory
save(train_aciton_orderHistory, file = "data/output/train_aciton_orderHistory.rda")
load("data/output/train_aciton_orderHistory.rda")
