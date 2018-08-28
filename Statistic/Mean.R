set.seed(1711)

#t.werte <- c(0,10,11) # m¨ogliche Werte von X
#t.sim <- sample(t.werte, 1000, replace=TRUE) # X simulieren

# Datasets mit gleichem Lageparameter
dataset1 <- rnorm(n=1000, m=40, sd=10)
#dataset2 <- rnorm(n=1000, m=60, sd=10)
dataset2 <- dataset1 + 20

#par(mfrow=c(2,1)) # Grafiken untereinander

hist(dataset1, breaks=seq(0,100,by=5), main="Dataset 1, mean=40, sd=10", col="grey")
hist(dataset2, breaks=seq(0,100,by=5), main="Dataset 2, mean=60, sd=10", col="grey")


# Datasets mit unterschiedlicher Streuung
dataset3 <- rnorm(n=1000, m=50, sd=5)
dataset4 <- rnorm(n=1000, m=50, sd=15)

hist(dataset3, breaks=seq(0,100,by=5), main="Dataset 3, mean=50, sd=5", col="grey")
hist(dataset4, breaks=seq(-10,120,by=5), main="Dataset 4, mean=50, sd=15", col="grey")
