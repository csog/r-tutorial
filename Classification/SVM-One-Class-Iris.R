#### Support Vector Machine
# Example for a one-class classification
# you have only positives instances. 
# could happen in the case of predictive maintenance

library(e1071)
library(caret)
library(NLP)
library(tm)

data(iris)

iris$SpeciesClass[iris$Species=="versicolor"] <- "TRUE"
iris$SpeciesClass[iris$Species!="versicolor"] <- "FALSE"
trainPositive<-subset(iris,SpeciesClass=="TRUE")
testnegative<-subset(iris,SpeciesClass=="FALSE")

inTrain<-createDataPartition(1:nrow(trainPositive),p=0.6,list=FALSE)

# we use only positive instances for training!
trainpredictors<-trainPositive[inTrain,1:4]
trainLabels<-trainPositive[inTrain,6]

testPositive<-trainPositive[-inTrain,]
testPosNeg<-rbind(testPositive,testnegative)

testpredictors<-testPosNeg[,1:4]
testLabels<-testPosNeg[,6]

svm.model<-svm(trainpredictors,y=NULL,
               type='one-classification',
               nu=0.10,
               scale=TRUE,
               kernel="radial")

svm.predtrain<-predict(svm.model,trainpredictors)
svm.predtest<-predict(svm.model,testpredictors)

confTrain<-table(Predicted=svm.predtrain,Reference=trainLabels)
confTest<-table(Predicted=svm.predtest,Reference=testLabels)

confusionMatrix(confTest,positive='TRUE')

print(confTrain)
print(confTest)
