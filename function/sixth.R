rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/new_userProfile_comment_train.rda")

#--------------------------------------------------------#
#train=new_userProfile_comment_train[new_userProfile_comment_train$rating==5,]
#train=train[train$orderType!=1&train$`4orderType`!=1,]
train=new_userProfile_comment_train
# train$predict_order_type=0
# train$predict_order_type[train$orderType==1]=1
# train$predict_order_type[train$`4orderType`==1]=1

# train$comment_score = 0
# train$tags_score = 0
# table(train$tags!="")
# table(train$commentsKeyWords!="")
# train$tags_score[train$tags!=""]=1
# train$comment_score[train$commentsKeyWords!=""]=1
# 
# table(train$comment_score[train$FutureOrderType!=0])
# 
# table(train$tags_score[train$FutureOrderType!=0])

#train$predict_order_type[train$tags_score==1&train$comment_score==1]=1
#table(train$predict_order_type!=train$FutureOrderType)

tag_train=table(unlist(strsplit(train$tags,"[|]")))
tag_train=as.data.frame(tag_train)
#全部共48种词，5分评论共17种词
#对于ordertype和4ordertype都不是1的五分用户，看看各个词的出现和futuretype的关系，对各个词打分
#train_tag_score=train[train$orderType!=1&train$`4orderType`!=1,]
train_tag_score=train[,c(1,4,6,7,13)]
tag_train$score=NA
for(tag_i in tag_train$Var1){
  #tag_i="车辆物资齐全"
  sub=train_tag_score[which(sapply(tag_i,regexpr,train_tag_score$tags)>0),]
  tag_train$score[tag_train$Var1==tag_i]=sum(sub$FutureOrderType==1)/nrow(sub)
}
#词典分数
save(tag_train,file = "data/tag_train.rda")
#------------------------------------------------------#
#评论分数统计
train_tag_score$tag_score=0
for(tag_i in tag_train$Var1){
  #tag_i="车辆物资齐全"
  print(tag_i)
  train_tag_score$tag_score[][which(sapply(tag_i,regexpr,train_tag_score$tags)>0)]=
    train_tag_score$tag_score[][which(sapply(tag_i,regexpr,train_tag_score$tags)>0)]+
    tag_train$score[tag_train$Var1==tag_i]
}
save(train_tag_score,file = "data/train_tag_score.rda")


#要点：如何对评论词进行评分？(tag_train$score)
#目前评分方法是含有该词且future type=1的数目除以含有该词的总条目
#