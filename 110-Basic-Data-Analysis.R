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


# Basic Analysis ----------------------------------------------------------
auto <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/auto-mpg/auto-mpg.data", 
                   header=FALSE, dec=".", na.strings = "?")
colnames(auto) <- c("mpg", "cylinders", "displacement", "horsepower", 
                    "weight", "acceleration", "year", "origin", "carname")
str(auto)

# remove NA
auto <- na.omit(auto)
auto$horsepower

# numerical data
mean(auto$horsepower)
median(auto$horsepower)
sd(auto$horsepower)
var(auto$horsepower)
min(auto$horsepower)
max(auto$horsepower)
range(auto$horsepower)
quantile(auto$horsepower)
# all together
summary(auto$horsepower)


# Boxplot and Histogram
boxplot(auto$horsepower, main="Boxplot of Horse Power", ylab="Horse Power")
hist(auto$horsepower, main="Histogram of Horse Power", xlab="Horse Power")

# Scatterplot
plot(x = auto$horsepower, y = auto$mpg, main = "Horsepower vs. Miles per Galon", 
     xlab = "Horespower", ylab = "MPG", pch=21)

# Basic Scatterplot Matrix
pairs(~mpg+horsepower+weight,data=auto,
      main="Simple Scatterplot Matrix")

# more scatterplot functions in several packages
# # see http://www.statmethods.net/graphs/scatterplot.html


# categorical data
table(auto$carname)
year_table <- table(auto$year)
prop.table(year_table)
