#### ROC for Iris data and one vs. all  
library(e1071)
library(caret)
library(ROCR)

# Example Iris Data ----------------------------------------------------------
# The famous Fisher Iris dataset is included in R
# but you should import it from UCI
# http://archive.ics.uci.edu/ml/machine-learning-databases/iris/
# t.url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"
# iris <- read.csv(t.url, header = FALSE, sep = ",", quote = "\"", dec = ".")
# colnames(iris) <- c("Sepal.L","Sepal.W","Petal.L","Petal.W","Class")

data(iris)
#iris

# Spliting data as training and test set. 
# Using createDataPartition() function from caret
set.seed(1711)
inTraining <- createDataPartition(iris$Species, p = .75, list = FALSE)
df_train <- iris[inTraining,]
df_test  <- iris[-inTraining,]

round(prop.table(table(df_train$Species)),2)
round(prop.table(table(df_test$Species)),2)

# Train model
nbmodel <- naiveBayes(Species~., data=df_train)

nbprediction <- predict(nbmodel, df_test[,-5], type= "raw")

# only interested in Virginica
score <- unname(nbprediction[, c("virginica")])


actual_class <- df_test$Species == 'virginica'

# ROCR
pred <- prediction(score, actual_class)
nbperf <- performance(pred, "tpr", "fpr")

nbauc <- performance(pred, "auc")
nbauc <- unlist(slot(nbauc, "y.values"))

plot(nbperf, colorize=FALSE)
legend(0.4,0.3,c(c(paste('AUC is', nbauc))),border="white",cex=1.0, box.col = "white")

