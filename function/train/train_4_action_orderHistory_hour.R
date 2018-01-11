rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/output/train_aciton_orderHistory.rda")

local_action_orderHistory=train_aciton_orderHistory
#----------------------本地变量local_action_orderHistory--------------#
local_action_orderHistory$start_order_time=round(difftime(local_action_orderHistory$orderTime,
                                                          local_action_orderHistory$starttime,units = c("hours")),3)
local_action_orderHistory$start_order_time=as.numeric(local_action_orderHistory$start_order_time)
#可以考虑将一天分为早晨（4：9） 上午（9：12），下午（12：18），晚上（18：22），半夜（23：4）
#保留小时，四舍五入
library(lubridate)
#hour(local_action_orderHistory$starttime[1])+minute(local_action_orderHistory$starttime[1])%/%30

local_action_orderHistory$start_hour=hour(local_action_orderHistory$starttime)+minute(local_action_orderHistory$starttime)%/%30
local_action_orderHistory$end_hour=hour(local_action_orderHistory$endtime)+minute(local_action_orderHistory$endtime)%/%30
local_action_orderHistory$order_hour=hour(local_action_orderHistory$orderTime)+minute(local_action_orderHistory$orderTime)%/%30

train_aciton_orderHistory_hour=local_action_orderHistory[,c(1,14,15,4:13,18:26)]
save(train_aciton_orderHistory_hour, file = "data/output/train_aciton_orderHistory_hour.rda")
load("data/output/train_aciton_orderHistory_hour.rda")
