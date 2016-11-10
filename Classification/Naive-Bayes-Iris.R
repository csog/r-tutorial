#### Naive Bayes

# Libraries ----------------------------------------------------------
library(caret)					# Just a data source for this script but also a very important R package 


# Example Iris Data ----------------------------------------------------------
# The famous Fisher Iris dataset is included in R
# but you should import it from UCI
# http://archive.ics.uci.edu/ml/machine-learning-databases/iris/
# t.url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"
# iris <- read.csv(t.url, header = FALSE, sep = ",", quote = "\"", dec = ".")
# colnames(iris) <- c("Sepal.L","Sepal.W","Petal.L","Petal.W","Class")

data(iris)
#iris


# Model ------------------------------------------------------------------------
x <- iris[,-5]
y <- iris$Species

# we use caret as 'abstraction layer'
model <- train(x, y,'nb',trControl=trainControl(method='cv',number=10))

model

# prediction value, and result class:
predict(model$finalModel,x)

# Evaluation--------------------------------------------------------------------
# error classified? 
#  compare the result of prediction with the class/iris species.
table(predict(model$finalModel, x)$class, y, dnn=list("predicted","actual"))


# plot the density 
naive_iris <- NaiveBayes(iris$Species ~ ., data = iris)
plot(naive_iris)

# prediction
new_data <- data.frame(5.2, 3.7, 1.1, 1.2)
predict(model$finalModel,new_data)
