rm(list=ls(all=TRUE))

library(data.table)
setwd("F:/DataMining/R/travel")
load("data/output/orderHistory_future.rda")

local_data=orderHistory_future
str(local_data)
library(mice)
md.pattern(local_data)

#install.packages("Boruta")
library(Boruta)
#在使用Boruta的时候不要使用有缺失值的数据集或极端值检查重要变量。
set.seed(123)
boruta.train <- Boruta(orderType~.-userid, data = local_data, doTrace = 2)
print(boruta.train)
#Boruta对变量数据集中的意义给出了明确的命令。
#No attributes deemed unimportant.

#现在，我们用图表展示Boruta变量的重要性。
#默认情况下，由于缺乏空间，Boruta绘图功能添加属性值到横的X轴会导致所有的属性值都无法显示。
#在这里我把属性添加到直立的X轴。
par(oma=c(2,0,0,0))
plot(boruta.train, xlab = "", xaxt = "n")
lz<-lapply(1:ncol(boruta.train$ImpHistory),function(i)boruta.train$ImpHistory[is.finite(boruta.train$ImpHistory[,i]),i])
names(lz) <- colnames(boruta.train$ImpHistory)
Labels <- sort(sapply(lz,median))
axis(side = 1,las=2,labels = names(Labels),at = 1:ncol(boruta.train$ImpHistory), cex.axis = 0.7)
#蓝色的盒状图对应一个阴影属性的最小、平均和最大Z分数。
#红色、黄色和绿色的盒状图分别代表拒绝、暂定和确认属性的Z分数
#现在我们对实验性属性进行判定。
#实验性属性将通过比较属性的Z分数中位数和最佳阴影属性的Z分数中位数被归类为确认或拒绝
final.boruta <- TentativeRoughFix(boruta.train)
print(final.boruta)
#现在我们要得出结果了。让我们获取确认属性的列表。
getSelectedAttributes(final.boruta, withTentative = F)
#我们将创建一个来自Boruta最终结果的数据框架。
boruta.df <- attStats(final.boruta)
class(boruta.df)
print(boruta.df)
