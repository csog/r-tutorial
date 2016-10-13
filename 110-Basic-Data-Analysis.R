#### Lab: Introduction to Data Analysis

# Importing Data ------------------------------------------------------------

# local data
getwd() # working directory
# setwd("path to directory")  # set working directory

?read.csv
salesdata <- read.csv("data/GlobalBike-Salesdata.csv", header = TRUE, sep=";", dec=",", stringsAsFactors = TRUE)
str(salesdata)
head(salesdata)

# Reading and writing XLS and other formats with the package rio

# In R, the fundamental unit of shareable code is the package. 
# A package bundles together code, data, documentation, and tests, 
# and is easy to share with others. 
# As of January 2015, there were over 6,000 packages available on the 
# Comprehensive R Archive Network, or CRAN, the public clearing house for R packages.
# https://cran.r-project.org/
# 
# You install a package  from CRAN with install.packages("x").
# You use them in R with library("x").
# You get help on them with package?x and help(package = "x")

# rio: A Swiss-Army Knife for Data I/O
# https://cran.r-project.org/web/packages/rio/
library("rio")
?import

salesdata2 = import("data/GlobalBike-Salesdata.xls")
str(salesdata2)
str(salesdata)
# Are there differences between salesdata and salesdata2?
rm(salesdata2)

# Importing Data from an URL
# The UC Irvine Machine Learning Repository at http://archive.ics.uci.edu/ml/index.html 
# is a well known repository for data sets
# We will import the data set http://archive.ics.uci.edu/ml/datasets/Auto+MPG

auto <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/car-mpg/auto-mpg.data", 
                   header=FALSE, dec=".", na.strings = "?")
colnames(auto) <- c("mpg", "cylinders", "displacement", "horsepower", 
                    "weight", "acceleration", "model year", "origin", "car name")
str(auto)

# clean 
rm(list = ls())

# Iris Dataset ----------------------------------------------------------

# The famous Fisher Iris dataset is included in R
# but you should import it from UCI
# http://archive.ics.uci.edu/ml/machine-learning-databases/iris/
# 
# iris <- ...
# col.names = c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species"))
# 

?iris
data(iris)

# Basic Analysis ----------------------------------------------------------

# Check the dimensionality
dim(iris)

# Attributes
names(iris)

# data
head(iris)
# or 
iris[1:8,]

#Get Sepal.Length of the first 10 rows
iris[1:10, "Sepal.Length"]


# summary of data
str(iris)
summary(iris)

# Frequency or distribution
table(iris$Species)

# Visual Exploration and Analysis -----------------------------------------------------------------------
# draw a bar plot and a pie chart of table.iris
table.iris <- table(iris$Species)
barplot(table(iris$Species))
pie(table.iris)

# histogram of iris$Sepal.Length
hist(iris$Sepal.Length)

# plot of density
plot(density(iris$Sepal.Length))

# boxplot of Petal.Width vs.Species
boxplot(Sepal.Width~Species, data=iris)
boxplot(Sepal.Length~Species, data=iris)

# plot Petal.Length, Petal.Width and with col=Species
with(iris, plot(Petal.Length, Petal.Width, col=Species, pch=as.numeric(Species)))
with(iris, plot(Sepal.Length, Sepal.Width, col=Species, pch=as.numeric(Species)))

# do a scatterplot ( ?pairs ) with additional 
# parameter bg = c("red", "yellow", "blue")[unclass(iris$Species)]
pairs(iris)
pairs(iris, main = "Fisher and Anderson's Iris Data - 3 species", 
      pch = 21,
      bg = c("red", "yellow", "blue")[unclass(iris$Species)])

# now in 3d
# if you use scatterplot3d the first time you have to install the package 
library(scatterplot3d)
scatterplot3d(iris$Petal.Width, iris$Sepal.Length, iris$Sepal.Width, main = "Fisher and Anderson's Iris Data - 3 species", 
              pch = 21,
              bg = c("red", "yellow", "blue")[unclass(iris$Species)])


# Correlation and Covariance ---------------------------------------------------------------------

# correlation
cor(iris$Sepal.Length, iris$Petal.Length)
cor(iris[,1:4])

#covariance
# round result with 2 digits
cov(iris$Sepal.Length, iris$Petal.Length)
round(cov(iris[,1:4]),2)



# Statistical tests are performed to access the significance of the results; here we
# demonstrate how to use a t-test to determine the statistical differences between
# two samples. In this example, we perform a t.test on the petal width of an iris in
# either the setosa or versicolor species. If we obtain a p-value less than 0.5, we can be
# certain that the petal width between the setosa and versicolor will vary significantly:
t.test(iris$Petal.Width[iris$Species=="setosa"],
       +        iris$Petal.Width[iris$Species=="versicolor"])

# Alternatively, you can perform a correlation test on the sepal length to the sepal
# width of an iris, and then retrieve a correlation score between the two variables.
# The stronger the positive correlation, the closer the value is to 1. The stronger the
# negative correlation, the closer the value is to -1:
cor.test(iris$Sepal.Length, iris$Sepal.Width)

# Use aggregate to calculate the mean of each iris attribute group by the species:
aggregate(x=iris[,1:4],by=list(iris$Species),FUN=mean)

