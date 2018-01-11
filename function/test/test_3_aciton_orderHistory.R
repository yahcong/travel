rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/output/test_new_orderHistory_hour.rda")
load("data/output/test_new_action_hour.rda")

#merge test_new_aciton and test_new_orderHistory_hour to aciton_orderHistory -------#
# aciton_orderHistory=test_new_action_hour

aciton_orderHistory=NULL
for(userid_i in unique(test_new_orderHistory_hour$userid) ){
  #userid_i=100000000371
  print(userid_i)
  #test_new_orderHistory_hour[test_new_orderHistory_hour$userid==userid_i]$orderid
  for(orderid_i in test_new_orderHistory_hour[test_new_orderHistory_hour$userid==userid_i]$orderid){
    #orderid_i=1000029
    print(orderid_i)
    order_sub=test_new_orderHistory_hour[test_new_orderHistory_hour$userid==userid_i&test_new_orderHistory_hour$orderid==orderid_i]
    action_sub=test_new_action_hour[test_new_action_hour$userid==userid_i&
                                 test_new_action_hour$starttime<order_sub$orderTime&
                                 test_new_action_hour$endtime>order_sub$orderTime,]
    if(nrow(action_sub)>0){
      aciton_orderHistory_sub=merge(action_sub,order_sub,by="userid",all=T)
      aciton_orderHistory=rbind(aciton_orderHistory,aciton_orderHistory_sub)
    }
  }
}

test_aciton_orderHistory=aciton_orderHistory
save(test_aciton_orderHistory, file = "data/output/test_aciton_orderHistory.rda")
load("data/output/test_aciton_orderHistory.rda")
