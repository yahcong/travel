rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/output/test_new_orderHistory.rda")
load("data/output/test_new_action.rda")

#merge test_new_aciton and test_new_orderHistory to aciton_orderHistory -------#
# aciton_orderHistory=test_new_action

aciton_orderHistory=NULL
for(userid_i in unique(test_new_orderHistory$userid) ){
  #userid_i=100000000371
  print(userid_i)
  #test_new_orderHistory[test_new_orderHistory$userid==userid_i]$orderid
  for(orderid_i in test_new_orderHistory[test_new_orderHistory$userid==userid_i]$orderid){
    #orderid_i=1000029
    print(orderid_i)
    order_sub=test_new_orderHistory[test_new_orderHistory$userid==userid_i&test_new_orderHistory$orderid==orderid_i]
    action_sub=test_new_action[test_new_action$userid==userid_i&
                                 test_new_action$starttime<order_sub$orderTime&
                                 test_new_action$endtime>order_sub$orderTime,]
    if(nrow(action_sub)>0){
      aciton_orderHistory_sub=merge(action_sub,order_sub,by="userid",all=T)
      aciton_orderHistory=rbind(aciton_orderHistory,aciton_orderHistory_sub)
    }
  }
}

test_aciton_orderHistory=aciton_orderHistory
save(test_aciton_orderHistory, file = "data/output/test_aciton_orderHistory.rda")
load("data/output/test_aciton_orderHistory.rda")
