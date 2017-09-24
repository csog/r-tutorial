## Example: Predicting Medical Expenses ----
# libraries
# more informative scatterplot matrix
library(psych)

x <- c(1.1, 2.1, 3.1, 4.1,5.1,6.1,7.6,8.1,9.1,10.1,11.1,13.1,13.1,14.1,15.1,
       16.1,17.1,18.1,19.1,18.1,21.1,22.1,23.1,24.6,25.1,26.1,27.1,29,29.1,30.1)
y <- c(1, 4,10,16,25,36,52,64,81,100,121,138,169,196,225,256,289,324,361,400,441,
       484,529,574,625,676,729,789,841,900)

xy.data <- data.frame(x,y)


plot(x, y, col="blue", main="Example Graph")
grid(nx = 12, ny = 12, col = "lightgray", lty = "dotted", lwd = par("lwd"), equilogs = TRUE)
       
# To create a model, we can use the lm() function. You should pass as parameter 
# the equation you think might suit your data. Here we are actually "guessing"
#  which model better fits to the data.
my_model_linear <- lm(y ~ x)
my_model_linear

# In the example above we are creating first a model y=x.
# Of course, you might want to test other alternatives:
my_model <- lm(y ~ poly(x, 2))
my_model

# Or
my_model_degree_20 <- lm(y ~ poly(x, 20))


# To visually check how your model  fit your data, you can plot your x values
# against the model values you created. Here we use the lines() method to do that:
  
lines(x, predict(lm(y ~ poly(x, 2))))
plot(my_model)

# This is going to give you a bunch of information like the residuals against 
# the fitted values. 
# You can also use a t.test()  to see if the two groups (real versus modeled values) 
# are similar. This test is going to compare their means, assuming they both 
# are under a normal distribution.

t.test(y, predict(my_model))

# predict new data
my_pred <- predict(my_model, data.frame(x = c(31.1)))


## Step 2: Exploring and preparing the data ----
insurance <- read.csv("data/insurance.csv", stringsAsFactors = TRUE)
str(insurance)

# summarize the charges variable
summary(insurance$charges)

# histogram of insurance charges
hist(insurance$charges)

# table of region
table(insurance$region)

# exploring relationships among features: correlation matrix
cor(insurance[c("age", "bmi", "children", "charges")])

# visualing relationships among features: scatterplot matrix
pairs(insurance[c("age", "bmi", "children", "charges")])

# more informative scatterplot matrix with psych
pairs.panels(insurance[c("age", "bmi", "children", "charges")])

## Step 3: Training a model on the data ----
ins_model <- lm(charges ~ age + children + bmi + sex + smoker + region,
                data = insurance)
ins_model <- lm(charges ~ ., data = insurance) # this is equivalent to above

# see the estimated beta coefficients
ins_model

## Step 4: Evaluating model performance ----
# see more detail about the estimated beta coefficients
summary(ins_model)

## Step 5: Improving model performance ----

# add a higher-order "age" term
insurance$age2 <- insurance$age^2

# add an indicator for BMI >= 30
insurance$bmi30 <- ifelse(insurance$bmi >= 30, 1, 0)

# create final model
ins_model2 <- lm(charges ~ age + age2 + children + bmi + sex +
                   bmi30*smoker + region, data = insurance)

summary(ins_model2)


## ------------------------------------------------------------------
# Source: https://datascienceplus.com/linear-regression-from-scratch-in-r/
library(MASS)
str(Boston)

# Linear regression typically takes the form
# y = βX + ϵ
# where ‘y’ is a vector of the response variable, ‘X’ is the matrix of our feature
#  variables (sometimes called the ‘design’ matrix), and β is a vector of parameters 
#  that we want to estimate. ϵ is the error term; it represents features that affect
#  the response, but are not explicitly included in our model.

# the response variable is the median home value in thousands of US dollars: ‘medv’:
y <- Boston$medv

# We’ll need our ‘X’ or ‘design’ matrix of the input features. 
# We can do this with the as.matrix() function, grabbing all the variables 
# except ‘medv’ from the Boston data frame. 
# We’ll also need to add a column of ones to our X matrix for the intercept term.

# Matrix of feature variables from Boston
X <- as.matrix(Boston[-ncol(Boston)])

# vector of ones with same length as rows in Boston
int <- rep(1, length(y))

# Add intercept column to X
X <- cbind(int, X)


# Now that we have our response vector and our ‘X’ matrix, we can use them to solve 
# for the parameters using the following closed form solution:
# β=(X^T X)^−1 X^T y

# We can implement this in R using our ‘X’ matrix and ‘y’ vector. 
# The %*%  operator is simply matrix multiplication. 
# The t() function takes the transpose of a matrix, and solve() calculates 
# the inverse of any (invertible) matrix.

# Implement closed-form solution
betas <- solve(t(X) %*% X) %*% t(X) %*% y

# Round for easier viewing
betas <- round(betas, 2)

print(betas)

# Now let’s verify that these results are in fact correct. We want to compare our 
# results to those produced by the lm()  function. Most of you will already know how to do this.

# Linear regression model
lm.mod <- lm(medv ~ ., data=Boston)

# Round for easier viewing
lm.betas <- round(lm.mod$coefficients, 2)

# Create data.frame of results
results <- data.frame(our.results=betas, lm.results=lm.betas)

print(results)
