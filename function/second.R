rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/new_action.rda")

# orderHistory_train -------------------------------------------
orderHistory_train=fread("data/trainingset/orderHistory_train.csv",encoding = "UTF-8")
orderHistory_train$orderTime=as.POSIXct(orderHistory_train$orderTime, origin="1970-01-01 00:00:00")
orderHistory_train$userid=as.character(orderHistory_train$userid)

levels(orderHistory_train$continent)
table(orderHistory_train$continent)
#北美洲 大洋洲   非洲 南美洲   欧洲   亚洲 
#  3432   2628     11      1   2527  12054 
new_orderHistory=orderHistory_train[,c(1,2,3,4 ,7)]
new_orderHistory$continent[new_orderHistory$continent == "北美洲"] = "North America"
new_orderHistory$continent[new_orderHistory$continent == "大洋洲"] = "Oceania"
new_orderHistory$continent[new_orderHistory$continent == "非洲"] = "Africa"
new_orderHistory$continent[new_orderHistory$continent == "南美洲"] = "South America"
new_orderHistory$continent[new_orderHistory$continent == "欧洲"] = "Europe"
new_orderHistory$continent[new_orderHistory$continent == "亚洲"] = "Asia"
table(new_orderHistory$continent)
levels(new_orderHistory$continent)

#merge new_aciton and new_orderHistory to aciton_orderHistory -------------
action_orderHistory=NULL
aciton_orderHistory=new_action
aciton_orderHistory$orderTime= NA
aciton_orderHistory$orderTime = as.POSIXct(aciton_orderHistory$orderTime, origin="1970-01-01 00:00:00")
aciton_orderHistory$continent = NA
aciton_orderHistory$orderType = 0


for(userid_i in unique(new_orderHistory$userid) ){
  #userid_i=100000003639
  print(userid_i)
  if(userid_i %in% unique(aciton_orderHistory$uesrid))
  {
    for(orderid_i in new_orderHistory[new_orderHistory$userid==userid_i]$orderid){
      #orderid_i=1000202
      #print(orderid_i)
      order=new_orderHistory[new_orderHistory$userid==userid_i&new_orderHistory$orderid==orderid_i]
      if(nrow(aciton_orderHistory[aciton_orderHistory$uesrid==userid_i&
                                  +                             aciton_orderHistory$starttime<order$orderTime&
                                  +                             aciton_orderHistory$endtime>order$orderTime,])>0){
        aciton_orderHistory[aciton_orderHistory$uesrid==userid_i&
                              aciton_orderHistory$starttime<order$orderTime&
                              aciton_orderHistory$endtime>order$orderTime,]$continent=order$continent
        aciton_orderHistory[aciton_orderHistory$uesrid==userid_i&
                              aciton_orderHistory$starttime<order$orderTime&
                              aciton_orderHistory$endtime>order$orderTime,]$orderType=order$orderType
        aciton_orderHistory[aciton_orderHistory$uesrid==userid_i&
                              aciton_orderHistory$starttime<order$orderTime&
                              aciton_orderHistory$endtime>order$orderTime,]$orderTime=order$orderTime
      }
    }
  }
}

save(aciton_orderHistory, file = "data/aciton_orderHistory.rda")

#aciton_orderHistory$continent = as.factor(aciton_orderHistory$continent)
#aciton_orderHistory$orderType = as.factor(aciton_orderHistory$orderType)

#第一个if应该可以删除，保留第二个if就可以