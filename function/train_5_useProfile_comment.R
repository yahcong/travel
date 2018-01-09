rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
userComment_train=fread("data/train/userComment_train.csv",encoding = "UTF-8")
userProfile_train=fread("data/train/userProfile_train.csv",encoding = "UTF-8")

#--------------合并评论数据和用户个人信息--------------------------------#
local_Comment=userComment_train
local_Profile=userProfile_train
#Profile文件中包含所有待预测用户的id，共10076个
train_userProfile_comment=merge(local_Profile,local_Comment,by = "userid",all = T)
save(train_userProfile_comment,file="data/output/train_userProfile_comment.rda")
load("data/output/train_userProfile_comment.rda")
