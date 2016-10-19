#### Random Forests

# Libraries ----------------------------------------------------------
library(randomForest)
?randomForest


# Data ----------------------------------------------------------
loc <- "http://archive.ics.uci.edu/ml/machine-learning-databases/"
ds  <- "breast-cancer-wisconsin/breast-cancer-wisconsin.data"
url <- paste(loc, ds, sep="")

breast <- read.table(url, sep=",", header=FALSE, na.strings="?")
names(breast) <- c("ID", "clumpThickness", "sizeUniformity",
                   "shapeUniformity", "maginalAdhesion", 
                   "singleEpithelialCellSize", "bareNuclei", 
                   "blandChromatin", "normalNucleoli", "mitosis", "class")

df <- breast[-1]
df$class <- factor(df$class, levels=c(2,4), 
                   labels=c("benign", "malignant"))

set.seed(1234)
train <- sample(nrow(df), 0.7*nrow(df))
df.train <- df[train,]
df.validate <- df[-train,]
table(df.train$class)
table(df.validate$class)

# Random Forest: Breast Cancer ----------------------------------------------------------
fit.forest <- randomForest(class~., data=df.train,        
                           na.action=na.roughfix,
                           importance=TRUE, ntree=200)             
fit.forest

# importance of attributes
importance(fit.forest, type=2)                          
varImpPlot(fit.forest, n.var = ncol(df.train)-1)

# predict
forest.pred <- predict(fit.forest, df.validate)         
forest.perf <- table(df.validate$class, forest.pred, 
                     dnn=c("Actual", "Predicted"))
forest.perf

# Random Forest: Forensic Glass Fragments ----------------------------------------------------------
library(MASS)
?fgl

## Fit RF with default settings
set.seed(1234)
fit.forest <- randomForest(type ~ ., data = fgl)
fit.forest

## Plot Error vs. nmb. of trees
plot(fit.forest)
## around 200 trees is surely enough

## refit with 200 trees
fit.forest <- randomForest(type ~ ., data = fgl, ntree = 200)

## predict class labels on new observations
## (for simplicity, I take some old observations)
idx <- c(1,73,150,169,181,205)
datNew <- fgl[idx,]
predict(fit.forest, newdata = datNew) ## predicted labels

## Variable Importance
rf.fgl <- randomForest(type ~ ., data = fgl, importance = TRUE, ntree = 200)
varImpPlot(rf.fgl, n.var = ncol(fgl)-1)
rf.fgl

rf.good <- randomForest(type ~ RI + Mg + Al, data = fgl)
rf.good

rf.bad <- randomForest(type ~ Fe + Si + Na, data = fgl)
rf.bad


