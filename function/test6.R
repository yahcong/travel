rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/new_action_test.rda")

#可以考虑将一天分为早晨（4：9） 上午（9：12），下午（12：18），晚上（18：22），半夜（23：4）
#保留小时，四舍五入
library(lubridate)
aciton_orderHistory=new_action_test
hour(aciton_orderHistory$starttime[1])+minute(aciton_orderHistory$starttime[1])%/%30
aciton_orderHistory$start_hour=hour(aciton_orderHistory$starttime)+minute(aciton_orderHistory$starttime)%/%30
aciton_orderHistory$end_hour=hour(aciton_orderHistory$endtime)+minute(aciton_orderHistory$endtime)%/%30
#aciton_orderHistory$order_hour=hour(aciton_orderHistory$orderTime)+minute(aciton_orderHistory$orderTime)%/%30

#
new_aciton_test_hour=aciton_orderHistory[,c(1,14,15,4:13)]
save(new_aciton_test_hour, file = "data/new_aciton_test_hour.rda")
