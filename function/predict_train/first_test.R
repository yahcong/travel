rm(list=ls())
library(data.table)
setwd("F:/DataMining/R/diabetes")
test_set= fread("data/d_test_A_20180102.csv")

#有各个乙肝属性的数据，单独做测试？
test=test_set
colnames(test)[20]<-c("Hepatitis_B")
test_set_Hepatitis_B=test_set[!is.na(test$Hepatitis_B)]
save(test_set_Hepatitis_B,file="data/output/test_set_Hepatitis_B.rda")

local_test=test[,c(1:19,25:41)]

dim(local_test)
#local_test=na.omit(local_test)
dim(local_test)
names(local_test)=c("id","gender","age","date","*Aspartate aminotransferase","*Alanine aminotransferase","*Alkaline phosphatase",
                     "*r-glutamyl converting enzyme","*Total protein","albumin","*globulin","Albumin globulin ratio","Triglycerides",
                     "Total cholesterol","High-density lipoprotein cholesterol","Low-density lipoprotein cholesterol","Urea","Creatinine",
                     "Uric acid","White blood cell count","Red blood cell count","Hemoglobin","Hematocrit","averageVolume redBloodCells",
                     "averageAmount redBloodCellsHemoglobin","Erythrocyte_mean hemoglobinConcentration","RedBloodCell volumeDistribution width",
                     "Platelet count","Average platelet volume","PlateletVolume distribution Width","Thrombocytopenia","Neutrophil%",
                     "Lymphocytes%","Monocytes%","Eosinophil%","Basophil%")
#特征分析
str(local_test)
table(local_test$gender)
#??   男   女 
#1 2283 1655 
local_test=local_test[local_test$gender!="??"]
table(local_test$gender)
#  男   女 
#2283 1655
local_test$gender=as.factor(local_test$gender)

#date
table(local_test$date)
#date都是2017/10，对样本没有多少影响，故去掉date这个属性
new_test <- subset(local_test, select = -date )
save(new_test,file="data/new_test.rda")
load("data/new_test.rda")


correlations<- cor(local_test[,-1],use="everything")
#pairs_data=local_test[,c(10:20)]
#pairs(~.,data=pairs_data,main="Scatterplot Matrix")

#采用Hmisc中的包
#对数据集进行描述
library(Hmisc)
describe(local_test)

#绘制相关系数图
library('corrplot')
local_test_cor=as.data.frame(local_test[30:37])
names(local_test_cor)=c(paste0("x",30:37))
correlations<- cor(local_test_cor)
corrplot(corr = correlations)


#观察数据点之间的距离
#数据标准化
local_test_scaled <- scale(local_test[,c(3:36)])
View(local_test_scaled)
#查看一下标准化后的数据
describe(local_test_scaled)

