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

auto <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/auto-mpg/auto-mpg.data", 
                   header=FALSE, dec=".", na.strings = "?")
colnames(auto) <- c("mpg", "cylinders", "displacement", "horsepower", 
                    "weight", "acceleration", "model year", "origin", "car name")
str(auto)

# clean 
rm(list = ls())

# Basic Analysis ----------------------------------------------------------

# we use Sales Data (complete)
salesdata <- read.csv("data/GlobalBike-Salesdata-complete.csv", header = TRUE, sep=";", dec=",", stringsAsFactors = TRUE)
str(salesdata)
head(salesdata)

salesdata.dim <- salesdata[,4:11]
salesdata.kpi <- salesdata[,12:15]
salesdata.date <- salesdata[,1:3]

summary(salesdata.kpi)



