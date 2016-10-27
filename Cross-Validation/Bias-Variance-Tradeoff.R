#### Example for Bias-Variance-Problem
# see also Example for Cross Validation

# Libraries --------------------------------------------------------------------
require(splines)


# Generate the training and test samples ---------------------------------------
seed <- 1711
set.seed(seed)

# Function to generate data
gen_data <- function(n, beta, sigma_eps) {
  eps <- rnorm(n, 0, sigma_eps)
  x <- sort(runif(n, 0, 100))
  X <- cbind(1, poly(x, degree = (length(beta) - 1), raw = TRUE))
  y <- as.numeric(X %*% beta + eps)
  
  return(data.frame(x = x, y = y))
}

# Fit the models ---------------------------------------------------------------

# Parameter
n_rep <- 100
n_df <- 30
df <- 1:n_df
beta <- c(5, -0.1, 0.004, -3e-05)
n_train <- 50
n_test <- 10000
sigma_eps <- 0.5

# simulate 100 training sets each of size 50 from a polynomial regression model 
# for each fit a sequence of cubic spline models with degrees of freedom from 1 to 30.
xy <- res <- list()
xy_test <- gen_data(n_test, beta, sigma_eps)

# 100 training sets
for (i in 1:n_rep) {
  # size 50 = n_train
  xy[[i]] <- gen_data(n_train, beta, sigma_eps)
  x <- xy[[i]][, "x"]
  y <- xy[[i]][, "y"]
  # fit a sequence of cubic spline models with degrees of freedom from 1 to 30
  res[[i]] <- apply(t(df), 2, function(degf) lm(y ~ ns(x, df = degf)))
}


# Plot sample  data ------------------------------------------------------------
# plot shows the first simulated training sample together with three fitted models 
# corresponding to cubic splines with 1 (green line), 4 (orange line) and 25 (blue line) 
# degrees of freedom
x <- xy[[1]]$x
X <- cbind(1, poly(x, degree = (length(beta) - 1), raw = TRUE))
y <- xy[[1]]$y
plot(y ~ x, col = "gray", lwd = 2)
lines(x, X %*% beta, lwd = 3, col = "black")
lines(x, fitted(res[[1]][[1]]), lwd = 3, col = "palegreen3")
lines(x, fitted(res[[1]][[4]]), lwd = 3, col = "darkorange")
lines(x, fitted(res[[1]][[25]]), lwd = 3, col = "steelblue")
legend(x = "topleft", legend = c("True function", "Linear fit (df = 1)", "Best model (df = 4)",
                                 "Overfitted model (df = 25)"), lwd = rep(3, 4), col = c("black", "palegreen3",
                                                                                         "darkorange", "steelblue"), text.width = 32, cex = 0.85)


# Compute the training and test errors for each model --------------------------
pred <- list()
mse <- te <- matrix(NA, nrow = n_df, ncol = n_rep)
for (i in 1:n_rep) {
  mse[, i] <- sapply(res[[i]], function(obj) deviance(obj)/nobs(obj))
  pred[[i]] <- mapply(function(obj, degf) predict(obj, data.frame(x = xy_test$x)),
                      res[[i]], df)
  te[, i] <- sapply(as.list(data.frame(pred[[i]])), function(y_hat) mean((xy_test$y -
                                                                            y_hat)^2))
}

# Compute the average training and test errors
av_mse <- rowMeans(mse)
av_te <- rowMeans(te)

# Plot the errors ----------------------------------------------------------
plot(df, av_mse, type = "l", lwd = 2, col = gray(0.4), ylab = "Prediction error",
     xlab = "Flexibilty (spline's degrees of freedom [log scaled])", ylim = c(0,
                                                                              1), log = "x")
abline(h = sigma_eps, lty = 2, lwd = 0.5)
for (i in 1:n_rep) {
  lines(df, te[, i], col = "lightpink")
}
for (i in 1:n_rep) {
  lines(df, mse[, i], col = gray(0.8))
}
lines(df, av_mse, lwd = 2, col = gray(0.4))
lines(df, av_te, lwd = 2, col = "darkred")
points(df[1], av_mse[1], col = "palegreen3", pch = 17, cex = 1.5)
points(df[1], av_te[1], col = "palegreen3", pch = 17, cex = 1.5)
points(df[which.min(av_te)], av_mse[which.min(av_te)], col = "darkorange", pch = 16,
       cex = 1.5)
points(df[which.min(av_te)], av_te[which.min(av_te)], col = "darkorange", pch = 16,
       cex = 1.5)
points(df[25], av_mse[25], col = "steelblue", pch = 15, cex = 1.5)
points(df[25], av_te[25], col = "steelblue", pch = 15, cex = 1.5)
legend(x = "top", legend = c("Training error", "Test error"), lwd = rep(2, 2),
       col = c(gray(0.4), "darkred"), text.width = 0.3, cex = 0.85)

# One can see that the training errors decrease monotonically as the model gets more complicated 
# (and less smooth). On the other side, even if the test error initially decreases, from a certain flexibility 
# level on it starts increasing again. The change point occurs in correspondence of the orange model, that is, 
# the model that provides a good compromise between bias and variance. The reason why the test error 
# starts increasing for degrees of freedom larger than 3 or 4 is the so called overfitting problem. 
# Overfitting is the tendency of a model to adapt too well to the training data, at the expense of 
# generalization to previously unseen data points. 
# In other words, an overfitted model fits the noise in the data rather than the actual underlying 
# relationships among the variables. 
# Overfitting usually occurs when a model is unnecessarily complex.
# 
# It is possible to show that the (expected) test error for a given observation in the test set can be 
# decomposed into the sum of three components, namely
# Expected Test Error = (Model Bias)^2 + Model Variance + Irreducible Noise
# which is known as the bias-variance decomposition.

# The last term is the data generating process variance. This term is unavoidable because we live in 
# a noisy stochastic world, where even the best ideal model has non-zero error. 
# The first term originates from the difficulty to catch the correct functional form of the relationship 
# that links the dependent and independent variables (sometimes it is also called the approximation bias). 
# The second term is due to the fact that we estimate our models using only a limited amount of data. 
# Fortunately, this terms gets closer and closer to zero as long as we collect more and more training data. 
# Typically, the more complex (i.e., flexible) we make the model, the lower the bias but the higher the variance.
# This general phenomenon is known as the bias-variance trade-off, and the challenge is to find a model 
# which provides a good compromise between these two issues.
# 
# Clearly, the situation illustrated above is only ideal, because in practice:
# We do not know the true model that generates the data. Indeed, our models are typically more or 
# less mis-specified. We do only have a limited amount of data.
# 
# One way to overcome these hurdles and approximate the search for the optimal model is 
# to use the cross-validation approach.
