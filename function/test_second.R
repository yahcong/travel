rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/new_action_test.rda")

# orderHistory_test -------------------------------------------
orderHistory_test=fread("data/test/orderHistory_test.csv",encoding = "UTF-8")
orderHistory_test$orderTime=as.POSIXct(orderHistory_test$orderTime, origin="1970-01-01 00:00:00")
orderHistory_test$userid=as.character(orderHistory_test$userid)

levels(orderHistory_test$continent)
table(orderHistory_test$continent)
#北美洲 大洋洲   非洲 南美洲   欧洲   亚洲 
#  3432   2628     11      1   2527  12054 
new_orderHistory=orderHistory_test[,c(1,2,3,4 ,7)]
new_orderHistory$continent[new_orderHistory$continent == "北美洲"] = "North America"
new_orderHistory$continent[new_orderHistory$continent == "大洋洲"] = "Oceania"
new_orderHistory$continent[new_orderHistory$continent == "非洲"] = "Africa"
new_orderHistory$continent[new_orderHistory$continent == "南美洲"] = "South America"
new_orderHistory$continent[new_orderHistory$continent == "欧洲"] = "Europe"
new_orderHistory$continent[new_orderHistory$continent == "亚洲"] = "Asia"
table(new_orderHistory$continent)
levels(new_orderHistory$continent)


#
#merge new_aciton and new_orderHistory to aciton_orderHistory -------------
action_orderHistory=NULL
aciton_orderHistory=new_action_test
aciton_orderHistory$orderTime= NA
aciton_orderHistory$orderTime = as.POSIXct(aciton_orderHistory$orderTime, origin="1970-01-01 00:00:00")
aciton_orderHistory$continent = NA
aciton_orderHistory$orderType = 0


for(userid_i in unique(new_orderHistory$userid) ){
  #userid_i=100000003639
  print(userid_i)
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
aciton_orderHistory_test=aciton_orderHistory
save(aciton_orderHistory_test, file = "data/aciton_orderHistory_test.rda")
