rm(list=ls())
library(data.table)
setwd("F:/DataMining/R/travel")
action_train = fread("data/train/action_train.csv",encoding = "UTF-8")
local_action=action_train

#------------以下可包装为函数，local_action为输入变量，test_new_action为输出-----#
local_action$actionTime=as.POSIXct(local_action$actionTime, origin="1970-01-01 00:00:00")
local_action$userid=as.character(local_action$userid)

#去掉id数只出现1~2次的
userid_s=table(local_action$userid)
userid_s=as.data.frame(userid_s)
userid_s=userid_s[userid_s$Freq>2,]
dim(local_action)
local_action=local_action[local_action$userid %in% userid_s$Var1,]
dim(local_action)
library(plyr)
new_action=NULL
type_lecels=c("1","2","3","4","5","6","7","8","9")
for(id in unique(local_action$userid)){
  print(id)
  #id=100000000371
  action_sub=local_action[local_action$userid==id,]
  start_time=1
  for(i in seq(2,length(action_sub$actionTime))){
    #print(i)
    len_time=as.numeric(difftime(action_sub$actionTime[i],
                                 action_sub$actionTime[i-1],units = c("hours")))
    #若时间间隔大于4days，判为新一次
    if(len_time>96 | i==length(action_sub$actionTime)){
      new_action_test=NULL
      sub=action_sub[i:start_time,]
      type_table=as.data.frame(table(sub$actionType))
      
      new_action_test$uesrid=id
      new_action_test$starttime=action_sub$actionTime[start_time]
      new_action_test$endtime=action_sub$actionTime[i-1]
      new_action_test$length_time=round(difftime(action_sub$actionTime[i-1],
                                                 action_sub$actionTime[start_time],units = c("hours")),3)
      new_action_test=as.data.frame(new_action_test)
      for(typei in type_lecels){
        #print(typei)
        if(typei %in% type_table$Var1){
          new_action_test$type=type_table$Freq[type_table$Var1==typei]
        } else
          new_action_test$type=0
        new_action_test <- rename(new_action_test,c(type = paste0("x",typei))) 
      }
      new_action=rbind(new_action,new_action_test)
      start_time=i
    }
  }
}
dim(new_action)
new_action=new_action[new_action$length_time!=0,]
train_new_action=new_action
save(train_new_action, file = "data/output/train_new_action.rda")
load("data/output/train_new_action.rda")

#colnames(train_new_action)[1]="userid"
#str(train_new_action)
#train_new_action$length_time=as.numeric(train_new_action$length_time)
#train_new_action$userid=as.character(train_new_action$userid)

library(lubridate)
train_new_action_hour=train_new_action
train_new_action_hour$start_hour=hour(train_new_action_hour$starttime)+minute(train_new_action_hour$starttime)%/%30
train_new_action_hour$end_hour=hour(train_new_action_hour$endtime)+minute(train_new_action_hour$endtime)%/%30
save(train_new_action_hour, file = "data/output/train_new_action_hour.rda")
load("data/output/train_new_action_hour.rda")
