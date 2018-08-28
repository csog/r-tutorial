#### Lab: Introduction to R
# Keys: 
# Strg+Return -> execute current line
# Strg+Alt B -> execute code from beginning to current line
# Strg+Alt R -> execute all code

# Basic Commands ----
?help

# Expressions and Assignments
2 * 17
11 * 16

# mathematical functions, such as sqrt, exp, and log. For example
log2(1024)
?log

# Assignment Operator / Zuweisungspfeil
# <- and = are nearly the same
# The operators <- and = assign into the environment in which they are evaluated.
# The operator <- can be used anywhere, whereas the operator = is only allowed at
# the top level (e.g., in the complete expression typed at the command prompt) or
# as one of the subexpressions in a braced list of expressions.
x <- 4
x + x ^ 2
x <- y <-z <- 17
x
y
z
# but ...
x = y <- z <- 17
x <- y <- z = 17
x <- y = z <- 17

# Example with functions
median(x = 1:10)
x

median(x <- 1:10)
x

# Vector ----------------------------------------------------------
# all elements have to be of  the same element type
# The function c, which is short for catenate or concatenate
# can be used to create vectors from scalars or other vectors:
x <- c(1, 3, 2, 5)
x

x <- c(1, 6, 2)
x

# test
x == 2
x > 2

2 * x

y = c(1, 4, 3)

length(x)
length(y)
x + y

# R operations are vectorized.
# If x is a vector, then log(x) is a vector with the logs of the elements of x.
x <- c(2, 4, 8, 16)
x
log2(x)


# other vector functions
x <- 10:20
x

# sequence
seq(0, 1, 0.1)

# rep for repeat or replicate.
# For example rep(3,4) replicates the number three four times.
# The first argument can be a vector, so rep(x,3) replicates the entire vector x three times.
# If both arguments are vectors of the same size, then each element of the first vector is
# replicated the number or times indicated by the corresponding element in the second vector.
rep(1:3, 2)
rep(1:3, c(2, 2, 2))


# all objects are stored in the working memory
# show objects
ls()

# delete objects
rm(x, y)
ls()
rm(list = ls())
ls()

# Matrix ----------------------------------------------------------
?matrix

# matrix
m = matrix(data = c(1, 2, 3, 4),
           nrow = 2,
           ncol = 2)
m

m = matrix(1:12, 3, 4)
m

m = matrix(c(1, 2, 3, 4), 2, 2)
matrix(c(1, 2, 3, 4), 2, 2, byrow = TRUE)

sqrt(m)
m ^ 2


# Indexing Data
m = matrix(1:16, 4, 4)
m

m[2, 3] # row 2, column 3

m[c(1, 3), c(2, 4)] # row 1 and 3, column 2 and 4
m[1:3, 2:4]
m[1:2, ] # row 1 and 2 and all columns
m[, 1:2] # all rows and column 1 and 2
m[1, ]   # only row 1
m[-c(1, 3), ] # everything, but not row 1 and 3
m[-c(1, 3), -c(1, 3, 4)]
dim(m)


# List ----------------------------------------------------------
# elements can be of different types
person = list(name = "Kim", age = 24, city = "Seoul")
person$name
person$age
person[1]
person[[1]]


# Data Frame ----------------------------------------------------------
# A data frame is essentially a rectangular array containing the values of one or more variables
# for a set of units. The frame also contains the names of the variables,
# the names of the observations, and information about the nature of the variables,
# including whether they are numerical or categorical.

name = c("Kim", "Joe", "Sascha")
age = c(24, 27, 31)
city = c("Seoul", "Frankfurt", "Basel")
df = data.frame(name, age, city)       # df is a data frame


df

df[1]
df[1,]
df[2, 2]
df[2:3]
df$name
df[-1]

# build in data set as data frame
mtcars

# The following commands are useful for viewing aspects of a data frame.
head(mtcars)     # prints the first few rows
tail(mtcars)     # prints the last few rows
names(mtcars)    # see the variable names
str(mtcars)      # check the variable types
rownames(mtcars) # view row names (numbers, if you haven't assigned names)
is.data.frame(mtcars)           # TRUE or FALSE
ncol(mtcars)                    # number of columns in data frame
nrow(mtcars)                    # number of rows
names(mtcars)[1] <- c("quad")   # change 1st variable name to quad
rownames(mtcars)                # optional row names

# Obtain a subset of a data frame
mydata <- mtcars[, c(2, 3)]   # data frame containing columns 2 and 3 only
mydata

mydata <- mtcars[, -1]       # data frame leaving out first column
mydata

mydata <- mtcars[1:3, 1:2]    # extract first 3 rows and first 2 columns
mydata

# shwo data sets
data()

# clear
rm(list = ls())

# Factors -----------------------------------------------------------------
# factors are variables in R which take on a limited number of different values;
# such variables are often refered to as categorical variables.

data <- c(1, 2, 2, 3, 1, 2, 3, 3, 1, 2, 3, 3, 1)
is.numeric(data)
is.factor(data)

fdata <- factor(data)
fdata
is.numeric(fdata)
is.factor(fdata)

# change labels
# To convert the default factor fdata to roman numerals,
# we use the assignment form of the levels function:

levels(fdata) = c('I', 'II', 'III')
fdata

# Factors represent a very efficient way to store character values,
# because each unique character value is stored only once, and
# the data itself is stored as a vector of integers. Because of this,
# read.table will automatically convert character variables to factors.

mons <-
  c(
    "March","April","January","November","January","September","October","September",
    "November","August","January","November","November","February","May","August",
    "July","December","August","August","September","November","February","April"
  )
table(mons)
# Strings automatically converted to factors!

mons <-
  factor(mons,levels = c("January","February","March",
      "April","May","June","July","August","September","October","November","December"),
    ordered = TRUE
  )
table(mons)

# analyze data frame persons
df
str(df)

# Strings are automatically converted to factors!
# to change bevaiour
df = data.frame(name, age, city, stringsAsFactors = FALSE)
df
str(df)

# clear
rm(list = ls())

# Apply -------------------------------------------------------------------
# Question: How can I use a loop to […insert task here…] ?
# Answer: Don’t. Use one of the apply functions.
# 

# apply family
# The structure of the apply() function is:
# apply(X, MARGIN, FUN, ...)
# X an array, including a matrix.
# MARGIN a vector giving the subscripts which the function will be applied over. 
#        E.g., for a matrix 1 indicates rows, 2 indicates columns, 
#       c(1, 2) indicates rows and columns. Where X has named dimnames, it can be a character vector selecting dimension names.
# FUN the function to be applied
# 
# apply can be used to apply a function to a matrix.
# lapply is similar to apply, but it takes a list as an input, and returns a list as the output.
# sapply is the same as lapply, but returns a vector instead of a list.
# more information at https://www.datacamp.com/community/tutorials/r-tutorial-apply-family

data <- matrix(c(1:10, 21:30), nrow = 5, ncol = 4)
data

# use the apply function to find the mean of each row
apply(data, 1, mean)

# sum up for each column
apply(data, 2, sum)

# Multipy all values by 10
data
apply(data,1:2,function(x) 10 * x)

# function
myfunction <- function(x) {100*x}
apply(data,1:2,myfunction)

# lapply and sapply
data <- list(x = 1:5, y = 6:10, z = 11:15)
data

lapply(data, FUN = median)
sapply(data, FUN = median)
