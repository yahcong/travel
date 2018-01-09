rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/new_userProfile_comment_train.rda")
load("data/train_tag_score.rda")
#----------------age----#
a=table(new_userProfile_comment_train$age[new_userProfile_comment_train$FutureOrderType==1])
a=as.data.frame(a)
#     00后 60后 70后 80后 90后 
# 5754   14  193  248  320   96 
#主力竟是00后
b=table(new_userProfile_comment_train$age)
b=as.data.frame(b)
#00后  60后  70后  80后  90后 
#35565    85  1061  1308  1667   621 
a$Freq/b$Freq
#[1] 0.1617883 0.1647059 0.1819039 0.1896024 0.1919616 0.1545894
#可以看出00后本身数量就多，占比最多的是80后
table(new_userProfile_comment_train[,c(4,6,13)])
#00后评5分或者不评分
#----------------gender---------#

