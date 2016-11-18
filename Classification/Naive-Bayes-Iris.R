#### Naive Bayes

# Libraries ----------------------------------------------------------
library(caret) #Just a data source for this script but also a very important R package 
library(e1071) #another library for Naive Bayes


# Example Iris Data ----------------------------------------------------------
# The famous Fisher Iris dataset is included in R
# but you should import it from UCI
# http://archive.ics.uci.edu/ml/machine-learning-databases/iris/
# t.url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"
# iris <- read.csv(t.url, header = FALSE, sep = ",", quote = "\"", dec = ".")
# colnames(iris) <- c("Sepal.L","Sepal.W","Petal.L","Petal.W","Class")

data(iris)
#iris


# Model with caret library -----------------------------------------------------
x <- iris[,-5]
y <- iris$Species

# we use caret as 'abstraction layer'
ctrl <- trainControl(method="cv", 10)

set.seed(1711)
model1 <- train(x, y,'nb',trControl=ctrl)
model1

# prediction value, and result class:
predict(model1$finalModel,x)

# Evaluation--------------------------------------------------------------------
# error classified? 
#  compare the result of prediction with the class/iris species.
table(predict(model1$finalModel, x)$class, y, dnn=list("predicted","actual"))


# plot the density 
naive_iris <- NaiveBayes(iris$Species ~ ., data = iris)
plot(naive_iris)

# do a scatterplot ( ?pairs ) with additional 
# parameter bg = c("red", "yellow", "blue")[unclass(iris$Species)]
pairs(iris)
pairs(iris, main = "Fisher and Anderson's Iris Data - 3 species", 
      pch = 21,
      bg = c("red", "yellow", "blue")[unclass(iris$Species)])

# now in 3d
# if you use scatterplot3d the first time you have to install the package 
library(scatterplot3d)
scatterplot3d(iris$Petal.Width, iris$Sepal.Length, iris$Sepal.Width, main = "Fisher and Anderson's Iris Data - 3 species", 
              pch = 21,
              bg = c("red", "yellow", "blue")[unclass(iris$Species)])

# prediction
new_data <- data.frame(5.2, 3.7, 1.1, 1.2)
predict(model1$finalModel,new_data)

# Model with e1071 library -----------------------------------------------------
# http://ugrad.stat.ubc.ca/R/library/e1071/html/naiveBayes.html

set.seed(1711)
model2 <- naiveBayes(x, y, type="raw")

