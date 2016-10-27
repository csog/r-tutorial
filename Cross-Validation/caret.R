#### Cross Validation with caret package
# more info at http://topepo.github.io/caret/model-training-and-tuning.html

# Libraries --------------------------------------------------------------------
library(caret)
library(klaR)
library(gbm)
library(mlbench) # we use data of this library data

# Data -------------------------------------------------------------------------
# load data Sonar
# Classification problem
data(Sonar)
str(Sonar[, 1:10])

# createDataPartition can be used to create a stratified random sample of 
# the data into training and test sets:
 
#?createDataPartition

inTraining <- createDataPartition(Sonar$Class, p = .75, list = FALSE)
training <- Sonar[ inTraining,]
testing  <- Sonar[-inTraining,]

# parameters for training ------------------------------------------------------
fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 10,
  ## repeated ten times
  repeats = 10)

# CART tree with parameter fitControl ------------------------------------------
set.seed(1711) 
tree <- train(Class ~ ., data = training,
                 method = "rpart",
                 trControl = fitControl)

#result
tree

# Stochastic Gradient Boosting -------------------------------------------------
# another model
# 
# In gradient boosting machines, or simply, GBMs, the learning procedure 
# consecutively fits new models to provide a more accurate estimate of the 
# response variable. The principle idea behind this algorithm is to construct 
# the new base-learners to be maximally correlated with the negative gradient 
# of the loss function, associated with the whole ensemble. The loss functions 
# applied can be arbitrary, but to give a better intuition, if the error function 
# is the classic squared-error loss, the learning procedure would result in 
# consecutive error-fitting. In general, the choice of the loss function is up 
# to the researcher, with both a rich variety of loss functions derived so far 
# and with the possibility of implementing one's own task-specific loss.
set.seed(1711) 
gbmFit1 <- train(Class ~ ., data = training,
                 method = "gbm",
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 verbose = FALSE)
gbmFit1



# Alternate Tuning Grids -------------------------------------------------------
#
# The tuning parameter grid can be specified by the user. The argument tuneGrid 
# can take a data frame with columns for each tuning parameter. The column names 
# should be the same as the fitting function’s arguments. For the previously 
# mentioned example, the names would be gamma and lambda. train will tune 
# the model over each combination of values in the rows.
# For the boosted tree model, we can fix the learning rate and evaluate more 
# than three values of n.trees:

gbmGrid <-  expand.grid(interaction.depth = c(1, 5, 9),
                        n.trees = (1:30)*50,
                        shrinkage = 0.1,
                        n.minobsinnode = 20)

nrow(gbmGrid)

set.seed(1711)
gbmFit2 <- train(Class ~ ., data = training,
                 method = "gbm",
                 trControl = fitControl,
                 verbose = FALSE,
                 ## Now specify the exact models
                 ## to evaluate:
                 tuneGrid = gbmGrid)
gbmFit2


# The plot function can be used to examine the relationship between the 
# estimates of performance and the tuning parameters. For example, a simple 
# invokation of the function shows the results for the first performance measure:
  
trellis.par.set(caretTheme())
plot(gbmFit2)
# using ggplot2 for visualization
ggplot(gbmFit2)  

# other metrics
trellis.par.set(caretTheme())
plot(gbmFit2, metric = "Kappa")



# Do the same with Iris data set -----------------------------------------------
# load the iris dataset
data(iris)

# k-fold Cross Validation 

# define training control
# k-fold Cross Validation 
fitControl <- trainControl(method="cv", number=10)

# fix the parameters of the algorithm
grid <- expand.grid( .winnow = c(TRUE,FALSE), .trials=c(1,5,10,15,20), .model="tree" )

# train the model
set.seed(1711) 
model <- train(Species~., data=iris, trControl=fitControl, tuneGrid=grid, 
               method="C5.0", verbose=FALSE)

# summarize results
print(model)


# Repeated k-fold Cross Validation 
# define training control
fitControl <- trainControl(method="repeatedcv", number=10, repeats=3)

# train the model
set.seed(1711) 
model2 <- train(Species~., data=iris, trControl=fitControl, tuneGrid=grid, 
               method="C5.0", verbose=FALSE)

# summarize results
print(model2)
