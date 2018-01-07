## Simple Linear Regression using R
# Source: https://www.kdnuggets.com/2017/10/learn-generalized-linear-models-glm-r.html

#Install Package
install.packages("hydroGOF")
library("hydroGOF")

#Read data from .csv file
data = read.csv("data/Cola.csv", header = T)
head(data)

#Scatter Plot
plot(data, main = "Scatter Plot")

#Fit linear model using OLS
model = lm(Cola ~ Temperature, data)

#Overlay best-fit line on scatter plot
abline(model)

#Calculate RMSE
PredCola = predict(model,data)
RMSE = rmse(PredCola,data$Cola)

## Log-Linear Regression using R

# Tranform the dependent variable
data$LCola = log(data$Cola, base = exp(1))

#Scatter Plot
plot(LCola ~ Temperature, data  = data , main ="Scatter Plot")

#Fit the best line in log-linear model
model1 = lm(LCola ~ Temperature, data)
abline(model1)

#Calculate RMSE
PredCola1 = predict(model1,data)
RMSE = rmse(PredCola1,data$LCola)

## Logistic Regression using R

#Read data from .csv file
data1=read.csv("data/Penalty.csv", header=T)
head(data1)

#Scatter Plot
plot(data1, main ="Scatter Plot")

#Fitting logistic regression 
fit = glm(Outcome ~ Practice, family = binomial(link = "logit"), data=data1)

#Plot probabilities
curve(predict(fit,data.frame(Practice=x),type="resp"),add=TRUE) 
points(data1$Practice,fitted(fit),pch=20)

