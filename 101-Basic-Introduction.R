#### Lab: Introduction to R
# Keys: Strg+Return -> execute current line

## Basic Commands
?help

## Expressions and Assignments
2*17
11*16

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
x + x^2
x <- y <- z <- 17
x
y
z
# but ...
x <- y <- z = 17
x <- y = z <- 17

# Example with functions
median(x = 1:10)
x
## Error: object 'x' not found
# In this case, x is declared within the scope of the function, so it does not exist in the user workspace.

median(x <- 1:10)
x
## [1]  1  2  3  4  5  6  7  8  9 10

# In this case, x is declared in the user workspace, 
# so you can use it after the function call has been completed.


# Vector 
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

2*x

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
rep(1:3, c(2,2,2))




# all objects are stored in the working memory
# show objects
ls()

# delete objects
rm(x, y)
ls()
rm(list = ls())
ls()

# Matrix 
?matrix

# matrix
m = matrix(data = c(1, 2, 3, 4), nrow = 2, ncol = 2)
m

m = matrix(1:12, 3, 4)
m

m = matrix(c(1, 2, 3, 4), 2, 2)
matrix(c(1, 2, 3, 4), 2, 2, byrow = TRUE)

sqrt(m)
m^2



# Indexing Data
m = matrix(1:16, 4, 4)
m

m[2, 3]
m[c(1, 3), c(2, 4)]
m[1:3, 2:4]
m[1:2, ]
m[, 1:2]
m[1, ]
m[-c(1, 3), ]
m[-c(1, 3), -c(1, 3, 4)]
dim(m)


# Lists
# elements can be of different types
person = list(name="Kim", age=24, city="Seoul")
person$name
person$age
person[1]
person[[1]]


# Data Frame
# A data frame is essentially a rectangular array containing the values of one or more variables 
# for a set of units. The frame also contains the names of the variables, 
# the names of the observations, and information about the nature of the variables, 
# including whether they are numerical or categorical.

name = c("Kim", "Joe", "Sascha")
age = c(24, 27,31)
city = c("Seoul", "Frankfurt", "Basel")
df = data.frame(name, age, city)       # df is a data frame


df

df[1]
df[1,]
df[2,2]
df[2:3]
df$name


# buil in data set as data frame
mtcars
head(mtcars)

