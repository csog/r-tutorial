library(animation)

## set larger 'interval' if the speed is too fast
ani.options(interval = 2)
par(mar = c(3, 3, 1, 1.5), mgp = c(1.5, 0.5, 0))


#kmeans.ani()
## the kmeans() example; very fast to converge!


x1 = rbind(matrix(rnorm(20, mean=0.5, sd = 0.3), ncol = 2), matrix(rnorm(20, mean = 0.7, sd = 0.3), ncol = 2))
x2 = rbind(matrix(rnorm(20, mean=1.0, sd = 0.5), ncol = 2), matrix(rnorm(20, mean = 1.7, sd = 0.5), ncol = 2))
x3 = rbind(matrix(rnorm(20, mean=2.5, sd = 0.5), ncol = 2), matrix(rnorm(20, mean = 2.7, sd = 0.5), ncol = 2))

x = rbind(x1, x2, x3)
kmeans.ani(x, centers = 3)
