rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
userComment_test=fread("data/test/userComment_test.csv",encoding = "UTF-8")
userProfile_test=fread("data/test/userProfile_test.csv",encoding = "UTF-8")

#--------------合并评论数据和用户个人信息--------------------------------#
local_Comment=userComment_test
local_Profile=userProfile_test
#Profile文件中包含所有待预测用户的id，共10076个
test_userProfile_comment=merge(local_Profile,local_Comment,by = "userid",all = T)
save(test_userProfile_comment,file="data/output/test_userProfile_comment.rda")
load("data/output/test_userProfile_comment.rda")
