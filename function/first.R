rm(list=ls())
library(data.table)
setwd("F:/DataMining/R/travel")

#read data---------------------------------------------------------------
#用户行为信息,数据共有三列，分别是用户id，行为类型，发生时间。
#行为类型一共有9个，其中1是唤醒app；2~4是浏览产品，无先后关系；
#5~9则是有先后关系的，从填写表单到提交订单再到最后支付。
action_train = fread("data/trainingset/action_train.csv",encoding = "UTF-8")

# Time stamp to date
action_train$actionTime=as.POSIXct(action_train$actionTime, origin="1970-01-01 00:00:00")

#userid不用科学计数法,转为字符
action_train$userid=as.character(action_train$userid)
# analysis action_train  ---------------------------------------------------
#查看数据的结构
#str(action_train)
#行为共有九种
#levels(as.factor(action_train$actionType))
#对action_train数据集进行描述
#library(Hmisc)
#describe(action_train)
#查看数据分布
#table(orderFuture_train$orderType)
# 0     1 
#33682  6625 
#数据不平衡

#去掉id数只出现1~2次的
userid_s=table(action_train$userid)
userid_s=as.data.frame(userid_s)
userid_s=userid_s[userid_s$Freq>2,]
dim(action_train)
action_train=action_train[action_train$userid %in% userid_s$Var1,]
dim(action_train)
#第一步，对action_train聚类
#聚类，本质上是识别数据点在数据空间的（距离）结构
#聚类，无监督学习的代名词
#以用户每一次的整体使用记录为一条数据构建新的数据结构
#包含userid#type1_num#type2_num#type3_num#type4_num#type5_num...type9_num
#length_time#考虑是否加入订单类型（是否购买精品旅游）
#1计算时间差，选取合适的时间长度为两次使用的时间间隔
library(plyr)

new_action=NULL
type_lecels=c("1","2","3","4","5","6","7","8","9")
for(id in unique(action_train$userid)){
  print(id)
  #id=100000000013
  action_train_sub=action_train[action_train$userid==id,]
  start_time=1
  #times_i用于记录时间分段的位置，测试用，可省略
  times_i=1
  for(i in seq(2,length(action_train_sub$actionTime))){
    #print(i)
    len_time=as.numeric(difftime(action_train_sub$actionTime[i],
                          action_train_sub$actionTime[i-1],units = c("hours")))
    #若时间间隔大于4days，判为新一次
    if(len_time>96 | i==length(action_train_sub$actionTime)){
      new_action_train=NULL
      times_i=rbind(times_i,i)
      sub=action_train_sub[i:start_time,]
      type_table=as.data.frame(table(sub$actionType))

      new_action_train$uesrid=id
      new_action_train$starttime=action_train_sub$actionTime[start_time]
      new_action_train$endtime=action_train_sub$actionTime[i-1]
      new_action_train$length_time=round(difftime(action_train_sub$actionTime[i-1],
                                                       action_train_sub$actionTime[start_time],units = c("hours")),3)
      new_action_train=as.data.frame(new_action_train)
      for(typei in type_lecels){
        #print(typei)
        if(typei %in% type_table$Var1){
          new_action_train$type=type_table$Freq[type_table$Var1==typei]
        } else
          new_action_train$type=0
        new_action_train <- rename(new_action_train,c(type = paste0("x",typei))) 
      }
      new_action=rbind(new_action,new_action_train)
      start_time=i
    }
  }
}
dim(new_action)
new_action=new_action[new_action$length_time!=0,]
#save(new_action, file = "data/new_action.rda")

