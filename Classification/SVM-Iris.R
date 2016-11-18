#### Support Vector Machine

# Libraries ----------------------------------------------------------
library(caret) # abstraction layer 
library(e1071) # library for SVM
# library(kernlab) another package for SVM


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
table(df_train$Species)
table(df_test$Species)

round(prop.table(table(df_train$Species)),2)
round(prop.table(table(df_test$Species)),2)


# Model with caret library -----------------------------------------------------
# we use caret as 'abstraction layer'
ctrl <- trainControl(method = "cv", 
                     number=10, 
                     savePred=TRUE, 
                     classProb=TRUE)

set.seed(1711)
svm_model1 <- train(Species ~ ., data=df_train, 
                    method = "svmLinear",
                    preProc = c("center","scale"),
                    trControl = ctrl)
svm_model1


# use different train control
ctrl <- trainControl(method = "repeatedcv", # K-fold cross validation w/repeated train/test splits
                     number = 10,           # K value (default 10)
                     repeats = 3)           # number of repetitions for repeatedcv 
set.seed(1711)
svm_model_linear <- train(Species ~ .,
                 data = df_train,
                 method = "svmLinear",
                 tuneLength = 15,  # how many candidate parameter values to evaluate
                 trControl = ctrl,
                 preProc = c("center", "scale"))
svm_model_linear


# radial kernel
grid <- expand.grid(sigma = c(.01, .015, 0.2),
                    C = c(0.75, 0.9, 1, 1.1, 1.25)
)
set.seed(1711)
svm_model_radial <- train(Species ~ .,
                          data = df_train,
                          method = "svmRadial",
                          tuneLength = 15,  # how many candidate parameter values to evaluate
                          trControl = ctrl,
                          tuneGrid = grid,
                          preProc = c("center", "scale"))
svm_model_radial

# linear kernel
set.seed(1711)
svm_model_linear <- train(Species ~ .,
                          data = df_train,
                          method = "svmLinear",
                          tuneLength = 15,  # how many candidate parameter values to evaluate
                          trControl = ctrl,
                          preProc = c("center", "scale"))
svm_model_linear


# Evaluation of caret model ----------------------------------------------------
# error classified? 
# Compare the result of prediction with the class/iris species.

# prediction value, and result class:
svm_predicted1 <- predict(svm_model_radial,newdata = df_test[,-5])
svm_predicted2 <- predict(svm_model_linear,newdata = df_test[,-5])

# Get the confusion matrix to see accuracy value and other parameter values
confusionMatrix(svm_predicted1, df_test$Species )
confusionMatrix(svm_predicted2, df_test$Species )


# Model with e1071 library -----------------------------------------------------
# http://ugrad.stat.ubc.ca/R/library/e1071/html/naiveBayes.html
# By default, the svm() function uses a radial basis function (RBF) to map samples 
# into a higher-dimensional space (the kernel trick). The RBF kernel is often a 
# good choice because it’s a nonlinear mapping that can handle relations between 
# class labels and predictors that are nonlinear.
# When fitting an SVM with the RBF kernel, two parameters can affect the results:
# gamma and cost. Gamma is a kernel parameter that controls the shape of the separating
# hyperplane. Larger values of gamma typically result in a larger number of support
# vectors. Gamma can also be thought of as a parameter that controls how widely 
# training sample “reaches,” with larger values meaning far and smaller values meaning
# close. Gamma must be greater than zero.
# The cost parameter represents the cost of making errors. A large value severely
# penalizes errors and leads to a more complex classification boundary. There will be
# less misclassifications in the training sample, but over-fitting may result in poor predictive
# ability in new samples. Smaller values lead to a flatter classification boundary but
# may result in under-fitting. Like gamma, cost is always positive.


set.seed(1711)
svm_model_elinear <- svm(Species ~., data=df_train, 
                         kernel = 'linear',
                         cross=10, #10-fold cross validation
                         cost=0.1)
# simple call
# svm_model <- svm(Species ~ ., data=df_train)
summary(svm_model_elinear)

# The e1071 library has a built-in tune() function that performs 
# 10-fold cross-validation on the models.
# A different combination of gamma and cost may lead to a more effective model. 
# You can try fitting SVMs by varying parameter values one at a time, but a grid
# search is more efficient. You can specify a range of values for each parameter using
# the tune.svm() function. tune.svm() fits every combination of values and reports on
# the performance of each. An example is given next.

set.seed(1711)
svm_tune <- tune(svm, Species ~., data=df_train,
                 kernel="linear", 
                 ranges=list(cost=10^(-1:2), gamma=c(.005,.01,.1,.2,.5,1,2,5,7,10)))

summary(svm_tune)


svm_model_after_tune <- svm(Species ~ ., data=df_train, 
                            kernel="linear", 
                            cross=10,
                            cost=0.1, 
                            gamma=0.005)
summary(svm_model_after_tune)


# Evaluation of e1071 model ----------------------------------------------------
# Compare the result of prediction with the class/iris species.

# prediction value, and result class:
svm_predicted2 <- predict(svm_model_after_tune,newdata = df_test[,-5])

# Get the confusion matrix to see accuracy value and other parameter values
confusionMatrix(svm_predicted2, df_test$Species )
