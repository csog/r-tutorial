# Exercise: Introduction to Data Analysis


# Importing Data ------------------------------------------------------------

# The famouse Iris dataset is included in R
# but you should import it from UCI
# http://archive.ics.uci.edu/ml/machine-learning-databases/iris/
# 
# iris <- ...
# 
# col.names = c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species"))
# 



# Basic Analysis ----------------------------------------------------------

# which kind of attributes?
# summary of data?

# Visual Exploration
table.iris <- table(iris$Species)

# draw a pie chart of table.iris
# ?pie

# histogram of iris$Sepal.Length

# boxplot of Petal.Width vs.Species

# plot Petal.Length, Petal.Width and with col=Species


# do a scatterplot ( ?pairs ) with additional 
# parameter bg = c("red", "yellow", "blue")[unclass(iris$Species)]


# correlation
# round result with 2 digits


#covariance




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


