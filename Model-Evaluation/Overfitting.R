### Data and model fitting
set.seed(1721)

n <- 30
x <- sort(runif(n, -2, 2))
y <- 3*x^5 + x^4+ 5*x^2 + 0.5*x + 20 # a 5 polynomial model

err <- rnorm(n, sd=10)
ye <- y + err
df <- data.frame(x, ye)
nterm <- c(1,2,3,5,7,9,20)

# png("model_fit~terms.png", width=5, height=4, units="in", res=400, type="cairo")
par(mar=c(4,4,1,1))
plot(ye~x, df, ylab="y")


for(i in seq(nterm)){
  fit <- lm(ye ~ poly(x, degree=nterm[i]), data=df)
  newdat <- data.frame(x=seq(min(df$x), max(df$x),,100))
  plot(ye~x, df, ylab="y")
  lines(newdat$x, predict(fit, newdat), col="blue")
  legend("top", y = 20, title=paste("Grad des Polynoms: ", nterm[i]), legend="",bty="n", lty=0)
}




# PAL <- colorRampPalette(c("blue", "cyan", "yellow", "red"))
# COLS <- PAL(length(nterm))
# for(i in seq(nterm)){
#   fit <- lm(ye ~ poly(x, degree=nterm[i]), data=df)
#   newdat <- data.frame(x=seq(min(df$x), max(df$x),,100))
#   lines(newdat$x, predict(fit, newdat), col=COLS[i])
# }
# legend("topleft", legend=paste0(nterm, c("", "", "*", "", "", "")), title="polynomial degrees", bty="n", col=COLS, lty=1)
# dev.off()


### Term significance
fit <- lm(ye ~ poly(x, degree=5), data=df)
summary(fit)


### Error as a function of model complexity
set.seed(1721)
n <- 50
x <- sort(runif(n, -2, 2))
y <- 3*x^3 + 5*x^2 + 0.5*x + 20 # a 3 polynomial model

nterm <- seq(12)
perms <- 500
frac.train <- 0.5 #training fraction of data
run <- data.frame(n, nterm, train.err=NaN, cv.err=NaN)
run

err <- rnorm(n, sd=3)
ye <- y + err
df <- data.frame(x, ye)


n <- 30
x <- sort(runif(n, -2, 2))
y <- 3*x^5 + x^4+ 5*x^2 + 0.5*x + 20 # a 5 polynomial model
nterm <- c(1,2,3,5,7,9,10)

perms <- 500
frac.train <- 0.5 #training fraction of data
run <- data.frame(n, nterm, train.err=NaN, cv.err=NaN)
run

err <- rnorm(n, sd=10)
ye <- y + err
df <- data.frame(x, ye)



for(i in seq(nrow(run))){
  pred.train <- matrix(NaN, nrow=nrow(df), ncol=perms)
  pred.valid <- matrix(NaN, nrow=nrow(df), ncol=perms)
  for(j in seq(perms)){
    train <- sample(nrow(df), nrow(df)*frac.train)
    valid <- seq(nrow(df))[-train]
    dftrain <- df[train,]
    dfvalid <- df[valid,]
    fit <- lm(ye ~ poly(x, degree=run$nterm[i]), data=dftrain)
    pred.train[train,j] <- predict(fit)
    pred.valid[valid,j] <- predict(fit, dfvalid)
  }
  run$train.err[i] <- mean(abs(df$ye - pred.train), na.rm=TRUE) # sqrt(mean((df$ye - pred.train)^2, na.rm=TRUE))
  run$cv.err[i] <- mean(abs(df$ye - pred.valid), na.rm=TRUE) # sqrt(mean((df$ye - pred.valid)^2, na.rm=TRUE))
  print(i)
}

#png("error~complexity.png", width=5, height=4, units="in", res=400, type="cairo")
par(mar=c(4,4,1,1))
ylim <- range(run$train.err, run$cv.err)
plot(run$nterm, run$train.err, log="y", col=1, t="o", ylim=ylim, xlab="Model complexity [polynomial degrees]", ylab="Mean absolute error [MAE]")
lines(run$nterm, run$cv.err, col=2, t="o")
#abline(v=3, lty=2, col=8)
#abline(h=mean(abs(err)), lty=2, col=8)
legend("top", legend=c("Training error", "Cross-validation error"), bty="n", col=1:2, lty=1, pch=1)
#dev.off()
#


### Error as a function of data size
set.seed(1111)
n <- round(exp(seq(log(50), log(500),, 10)))
nterm <- 7
perms <- 500
frac.train <- 0.5 #training fraction of data
run <- data.frame(n, nterm, train.err=NaN, cv.err=NaN)
run
x <- sort(runif(max(n), -2, 2))
y <- 3*x^3 + 5*x^2 + 0.5*x + 20 # a 3 polynomial model
err <- rnorm(max(n), sd=3)
ye <- y + err
DF <- data.frame(x, ye)

for(i in seq(nrow(run))){
  df <- DF[1:run$n[i],]
  pred.train <- matrix(NaN, nrow=nrow(df), ncol=perms)
  pred.valid <- matrix(NaN, nrow=nrow(df), ncol=perms)
  for(j in seq(perms)){
    train <- sample(nrow(df), nrow(df)*frac.train)
    valid <- seq(nrow(df))[-train]
    dftrain <- df[train,]
    dfvalid <- df[valid,]
    fit <- lm(ye ~ poly(x, degree=run$nterm[i]), data=dftrain)
    pred.train[train,j] <- predict(fit)
    pred.valid[valid,j] <- predict(fit, dfvalid)
  }
  run$train.err[i] <- mean(abs(df$ye - pred.train), na.rm=TRUE) # sqrt(mean((df$ye - pred.train)^2, na.rm=TRUE))
  run$cv.err[i] <- mean(abs(df$ye - pred.valid), na.rm=TRUE) # sqrt(mean((df$ye - pred.valid)^2, na.rm=TRUE))
  print(i)
}

#png(paste0("error~data_size_", paste0(nterm, "term"), ".png"), width=5, height=4, units="in", res=400, type="cairo")
par(mar=c(4,4,1,1))
ylim <- range(run$train.err, run$cv.err)
plot(run$n, run$train.err, log="xy", col=1, t="o", ylim=ylim, xlab="Data size [n]", ylab="Mean absolute error [MAE]")
lines(run$n, run$cv.err, col=2, t="o")
abline(h=mean(abs(err)), lty=2, col=8)
legend("bottomright", legend=paste0("No. of polynomial degrees = ", nterm), bty="n")
legend("top", legend=c("Training error", "Cross-validation error"), bty="n", col=1:2, lty=1, pch=1)
#dev.off()

