# Exercise: Introduction to Data Analysis


# Importing Data ------------------------------------------------------------

# Import data from https://archive.ics.uci.edu/ml/datasets/Auto+MPG
auto <- read.table(...)
colnames(auto) <- c(...)



# Basic Analysis ----------------------------------------------------------

# which kind of attributes?
# 
# summary of data?

# remove NA
auto <- na.omit(auto)
auto$horsepower

# analyse basic statist attributes like mean, median, min, max ...
# nummerical attributes


# car has also categorical attributes
table(auto$carname)
year_table <- table(auto$year)
prop.table(year_table)

# Visual Exploration

# draw different charts

# histogram of ...

# boxplot of ...


# do a scatterplot ( ?pairs ) 

# describe any trends relating weight, fuel efficiency, and number of cylinders. 

# correlation
# round result with 2 digits

#covariance

# do more if you like :)


