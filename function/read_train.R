rm(list=ls())
library(data.table)
setwd("F:/DataMining/R/travel")

#read data---------------------------------------------------------------
#提交样例
sample=fread("data/sample.csv",encoding = "UTF-8")
#用户行为信息,数据共有三列，分别是用户id，行为类型，发生时间。
#行为类型一共有9个，其中1是唤醒app；2~4是浏览产品，无先后关系；
#5~9则是有先后关系的，从填写表单到提交订单再到最后支付。
action_train = fread("data/trainingset/action_train.csv",encoding = "UTF-8")
#待预测订单的数据
#对于train，有两列，分别是用户id和订单类型。供参赛者训练模型使用。
#其中1表示购买了精品旅游服务，0表示未购买精品旅游服务（包括普通旅游服务和未下订单）。
#对于test，只有一列用户id，是待预测的用户列表。
orderFuture_train = fread("data/trainingset/orderFuture_train.csv",encoding = "UTF-8")
#用户历史订单数据
#数据分别是用户id，订单id，订单时间，订单类型，旅游城市，国家，大陆。
#其中1表示购买了精品旅游服务，0表示普通旅游服务.
#注意：一个用户可能会有多个订单，需要预测的是用户最近一次订单的类型；
#此文件给到的订单记录都是在“被预测订单”之前的记录信息！同一时刻可能有多个订单，属于父订单和子订单的关系。
orderHistory_train=fread("data/trainingset/orderHistory_train.csv",encoding = "UTF-8")
#评论数据
#共有5个字段，分别是用户id，订单id，评分，标签，评论内容。
#其中受数据保密性约束，评论内容仅显示一些关键词。 
userComment_train=fread("data/trainingset/userComment_train.csv",encoding = "UTF-8")
#用户个人信息
#数据共有四列，分别是用户id、性别、省份、年龄段。
userProfile_train=fread("data/trainingset/userProfile_train.csv",encoding = "UTF-8")

# Time stamp to date
action_train$actionTime=as.POSIXct(action_train$actionTime, origin="1970-01-01 00:00:00")
orderHistory_train$orderTime=as.POSIXct(orderHistory_train$orderTime, origin="1970-01-01 00:00:00")

#userid不用科学计数法
action_train$userid=as.character(action_train$userid)
sample$userid=as.character(sample$userid)
orderFuture_train$userid=as.character(orderFuture_train$userid)
orderHistory_train$userid=as.character(orderHistory_train$userid)
userComment_train$userid=as.character(userComment_train$userid)
userProfile_train$userid=as.character(userProfile_train$userid)