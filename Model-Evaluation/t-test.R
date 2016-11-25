#### Student's t-test
# Student's t-test is where the test statistic follows a normal distribution (the student's t
# distribution) if the null hypothesis is true. It can be used to determine whether there is a
# difference between two independent datasets. Student's t-test is best used with the problems
# associated with an inference based on small samples.

# Libraries --------------------------------------------------------------------
library(stats)
library(ggplot2)

# Example 1 unpaired------------------------------------------------------------
a <- c(175, 168, 168, 190, 156, 181, 182, 175, 174, 179)
b <- c(185, 169, 173, 173, 188, 186, 175, 174, 179, 180)

c <- c(210, 143, 143, 153, 218, 86, 75, 74, 129, 110)

var.test(a,b)
# We obtained p-value greater than 0.05, then we can assume that the two variances 
# are homogeneous. Indeed we can compare the value of F obtained with the tabulated 
# value of F for alpha = 0.05, degrees of freedom of numerator = 9, and degrees of 
# freedom of denominator = 9, using the function qf(p, df.num, df.den):
qf(0.95, 9, 9)

# Note that the value of F computed is less than the tabulated value of F, which 
# leads us to accept the null hypothesis of homogeneity of variances.
# NOTE: The F distribution has only one tail, so with a confidence level 
# of 95%, p = 0.95. Conversely, the t-distribution has two tails, and in the 
# R's function qt(p, df) we insert a value p = 0975 when you're testing a 
# two-tailed alternative hypothesis.

t.test(a,b, var.equal=TRUE, paired=FALSE)

# We obtained p-value greater than 0.05, then we can conclude that the averages of 
# two groups are significantly similar. Indeed the value of t-computed is less 
# than the tabulated t-value for 18 degrees of freedom, 
# which in R we can calculate:
  
qt(0.975, 18)
# This confirms that we can accept the null hypothesis H0 of equality of the means

# now test a and c
var.test(a,c)
t.test(a,c, var.equal=FALSE, paired=FALSE)
# What does this mean?
t.test(a,c, var.equal=FALSE, paired=FALSE, conf.level=0.99)

# Example 2 Paired t-test-------------------------------------------------------
a <- c(12.9, 13.5, 12.8, 15.6, 17.2, 19.2, 12.6, 15.3, 14.4, 11.3)
b <- c(12.7, 13.6, 12.0, 15.2, 16.8, 20.0, 12.0, 15.9, 16.0, 11.1)

t.test(a,b, paired=TRUE)
# The p-value is greater than 0.05, then we can accept the hypothesis H0 
# of equality of the averages.
qt(0.975, 9)
# t-computed < t-tabulated, so we accept the null hypothesis H0.


a <- c(12.9, 13.5, 12.8, 15.6, 17.2, 19.2, 12.6, 15.3, 14.4, 11.3)
b <- c(12.0, 12.2, 11.2, 13.0, 15.0, 15.8, 12.2, 13.4, 12.9, 11.0)
t.test(a,b, paired=TRUE, alt="less")

# With this syntax we asked R to check whether the mean of the values contained 
# in the vector a is less of the mean of the values contained in the vector b. 
# In response, we obtained a p-value well above 0.05, which leads us to conclude 
# that we can reject the null hypothesis H0 in favor of the alternative hypothesis H1.

# If we had written: t.test (a, b, paired = TRUE, alt = "greater"), we asked R to 
# check whether the mean of the values contained in the vector a is greater than
# the mean of the values contained in the vector b. In light of the previous result, 
# we can suspect that the p-value will be much smaller than 0.05, and in fact:
t.test(a,b, paired=TRUE, alt="greater")


# Example 3 --------------------------------------------------------------------
# Load Data --------------------------------------------------------------------
# Motor Trend Car Road Tests
# The data was extracted from the 1974 Motor Trend US magazine, and comprises fuel 
# consumption and 10 aspects of automobile design and performance for 32 
# automobiles (1973–74 models).
# Format
# A data frame with 32 observations on 11 variables.
# [, 1] 	mpg 	Miles/(US) gallon
# [, 2] 	cyl 	Number of cylinders
# [, 3] 	disp 	Displacement (cu.in.)
# [, 4] 	hp 	Gross horsepower
# [, 5] 	drat Rear axle ratio
# [, 6] 	wt Weight (1000 lbs)
# [, 7] 	qsec	1/4 mile time
# [, 8] 	vs V/S
# [, 9] 	am 	Transmission (0 = automatic, 1 = manual)
# [,10] 	gear Number of forward gears
# [,11] 	carb Number of carburetors

data(mtcars)
str(mtcars)

summary(mtcars$mpg)
table(mtcars$cyl)


stem(mtcars$mpg)
qplot(mtcars$mpg, binwidth=2)


plot(mtcars$cyl, mtcars$mpg)

# t-test -----------------------------------------------------------------------
?t.test

# one sample Student's t-test
# a research question often asked is, "Is the mean of the population different 
# from the null hypothesis?" Thus, in order to test whether the average 
# mpg of automobiles is lower than the overall average mpg, we first use a 
# boxplot to view the differences between populations without making any assumptions.
# Visualize the attribute, mpg, against am using a boxplot
boxplot(mtcars$mpg, mtcars$mpg[mtcars$am==0], ylab = "mpg", 
        names=c("overall","automobile"))
abline(h=mean(mtcars$mpg),lwd=2, col="red")
abline(h=mean(mtcars$mpg[mtcars$am==0]),lwd=2, col="blue")
# From the preceding figure, it is clear that the mean of mpg of automobiles 
# (the blue line) is lower than the average mpg (red line) of the overall population. 
# Then, we apply one sample t-test; the low p-value of 0.003595 (< 0.05) suggests 
# that we should reject the null hypothesis that the mean mpg for
# automobiles is less than the average mpg of the overall population.

# one sample Student's t-test
# perform statistical procedure to validate whether the average mpg of
# automobiles is lower than the average of the overall mpg:
mpg.mu = mean(mtcars$mpg)
mpg_am = mtcars$mpg[mtcars$am == 0]
t.test(mpg_am,mu = mpg.mu)


boxplot(mtcars$mpg~mtcars$am,ylab='mpg',names=c('automatic','manual'))
abline(h=mean(mtcars$mpg[mtcars$am==0]),lwd=2, col="blue")
abline(h=mean(mtcars$mpg[mtcars$am==1]),lwd=2, col="red")
# The preceding figure reveals that the mean mpg of automatic transmission cars is
# lower than the average mpg of manual transmission vehicles

# As a one sample t-test enables us to test whether two means are significantly different,
# a two sample t-test allows us to test whether the means of two independent groups are
# different. Similar to a one sample t-test, we first use a boxplot to see the differences between
# populations and then apply a two-sample t-test. The test results shows the p-value = 0.01374
# (p< 0.05). In other words, the test provides evidence that rejects the null hypothesis, which
# shows the mean mpg of cars with automatic transmission differs from the cars with manual
# transmission.

# Test for Varinacehomgenity
# -> negative
# R uses the Welch t-test instead of the Student's t-test
var.test(mtcars$mpg~mtcars$am)

t.test(mtcars$mpg~mtcars$am)

# Welch's t-test is an adaptation of Student's t-test, that is, it has been 
# derived with the help of Student's t-test and is more reliable when the two 
# samples have unequal variances and unequal sample sizes.

