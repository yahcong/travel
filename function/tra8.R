rm(list=ls())

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/new_userProfile_comment_train.rda")
load("data/train_tag_score.rda")

train=merge(train_tag_score[,c(1,6)],new_userProfile_comment_train[,c(1:4,6,9:13)],by = "userid",all = T)

#check NA
library(mice)
md.pattern(train)
train$gender[train$gender==""]="unknow"
train$province[train$province==""]="unknow"
train$age[train$age==""]="unknow"
train$orderType[is.na(train$orderType)]="no_order"
train$`4orderType`[is.na(train$`4orderType`)]="no_order"
train$`3orderType`[is.na(train$`3orderType`)]="no_order"
train$`2orderType`[is.na(train$`2orderType`)]="no_order"
train$rating[is.na(train$rating)]="no_rating"

colnames(train)[8] <- "order_type2"
colnames(train)[9] <- "order_type3"
colnames(train)[10] <- "order_type4"

#md.pattern(train)

#-------------------------------------------------------------#
load("data/new_aciton_orderHistory.rda")
orderFuture_train = fread("data/trainingset/orderFuture_train.csv",encoding = "UTF-8")
orderFuture_train$userid=as.character(orderFuture_train$userid)

#
train_action_noorder=new_aciton_orderHistory[,c()]
#有tag和无tag的分别处理
#没有历史订单，但是futuretype为1的共有3747个
#对于没有历史订单的是否应该单独处理？
table(new_userProfile_comment_train$FutureOrderType[is.na(new_userProfile_comment_train$orderType)])
#0     1 
#25923  3747
#合并new_aciton_orderHistory和orderFuture_train
aciton_orderHistory_Future=new_aciton_orderHistory
aciton_orderHistory_Future$Future_type=NA
for(user_i in unique(orderFuture_train$userid)){
  print(user_i)
  aciton_orderHistory_Future$Future_type[aciton_orderHistory_Future$uesrid==user_i]=
    orderFuture_train$orderType[orderFuture_train$userid==user_i]
}
save(aciton_orderHistory_Future,file="data/aciton_orderHistory_Future.rda")
#train_action_order代表有订单历史的action数据
#train_action代表不考虑订单的action数据
#---------------first-----------------------------------------------#
train_action_order=aciton_orderHistory_Future[!is.na(aciton_orderHistory_Future$start_order_time),]
dim(train_action_order)
str(train_action_order)
md.pattern(train_action_order)
train_action_order$Future_type=as.factor(train_action_order$Future_type)
train_action_order$continent=as.factor(train_action_order$continent)
train_action_order$orderType=as.factor(train_action_order$orderType)
train_action_order$uesrid=as.character(train_action_order$uesrid)
train_action_order$length_time=as.numeric(train_action_order$length_time)
train_action_order$start_order_time=as.numeric(train_action_order$start_order_time)

fit=randomForest(Future_type ~ ., data = train_action_order)
save(fit,file="model/randomForest.rda")
#load("model/randomForest.rda")
test_action_order=train_action_order
test_action_order$predict_type=predict(fit,test_action_order)

#--------------second-----------------------------------------------#
train_action=aciton_orderHistory_Future[,c(1:3,5,7:15,18)]
dim(train_action)
str(train_action)
md.pattern(train_action)
train_action$Future_type=as.factor(train_action$Future_type)
train_action$uesrid=as.character(train_action$uesrid)
train_action$length_time=as.numeric(train_action$length_time)
fit2=randomForest(Future_type ~ ., data = train_action,ntree=500)
save(fit2,file="model/randomForest2.rda")
#load("model/randomForest2.rda")
test_action=train_action[,c(1:13)]
test_action$predict_type=predict(fit2,test_action)
str(test_action)
library(AUC)
AUC::auc(roc(train_action$Future_type,test_action$predict_type))

