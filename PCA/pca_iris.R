# PCA for Iris dataset

data(iris)
data_iris <- iris[1:4]
str(iris) 
summary(iris[1:4])
pairs(data_iris,main="Iris Data", pch=19, col=as.numeric(iris$Species)+1)
mtext("Type of iris species: red-> setosa; green-> versicolor; blue-> virginica", 1, line=3.7,cex=.8)

# To examine variability of all numeric variables
sapply(data_iris,var)
range(sapply(iris[1:4],var))

# maybe this range of variability is big in this context.
# Thus, we will use the correlation matrix
# For this, we must standardize our variables with scale() function:
data_iris_stand <- as.data.frame(scale(iris[,1:4]))
sapply(data_iris_stand, sd) #now, standard deviations are 1

# Calculating the covariance matrix
Cov_data <- cov(data_iris_stand )

# Find out the eigenvectors and eigenvalues using the covariance matrix
Eigen_data <- eigen(Cov_data)


# We have calculated the Eigen values from the data. We will now look at the PCA function princomp() 
# which automatically calculates these values.
# Using the inbuilt function
# cor a logical value indicating whether the calculation should use the correlation matrix or the covariance matrix. 
# The correlation matrix can only be used if there are no constant variables.
PCA_data <- princomp(data_iris_stand, cor="False")

# Let’s now compare the output variances
Eigen_data$values
PCA_data$sdev^2

# There is a slight difference due to squaring in PCA_data but the outputs are more or less similar. 
# We can also compare the eigenvectors of both models.
# compare the eigenvectors of both models.
PCA_data$loadings[,1:4]
Eigen_data$vectors
# the same values

# To know the importance of the first component, we can view the summary of the model.
summary(PCA_data)

# From the Proportion of Variance, we see that the first component has an importance of 72.9% in 
# predicting the class while the second principal component has an importance of 2.2% and so on. 
# This means that using just the first component instead of all the 4 features will make our 
# model accuracy to be about 92.5% while we use only one-fourth of the entire set of features.
# If we want the higher accuracy, we can take the first two components together and obtain a cumulative 
# accuracy. We can also understand how our features are transformed by using the biplot function on our model.
biplot (PCA_data)


### The same with prcomp

#Apply the prcomp() function to calculate the principal components:
#If we use prcomp() function, we indicate 'scale=TRUE' to use correlation matrix
pca_data2 <- prcomp(iris.stand, scale=FALSE)
#it is just the same that: prcomp(iris[,1:4],scale=T) and prcomp(iris.stand)
#similar with princomp(): princomp(iris.stand, cor=T)
pca_data2
summary(pca_data2)
#This gives us the standard deviation of each component, and the proportion of variance explained by each component.
#The standard deviation is stored in (see 'str(pca)'):
pca$sdev

#plot of variance of each PCA.
#It will be useful to decide how many principal components should be retained.
screeplot(pca, type="lines",col=3)
#From this plot and from the values of the ‘Cumulative Proportion of Variance’ (in summary(pca)) 
#we can conclude that retaining 2 components would give us enough information, 
#as we can see that the first two principal components account for over 95% of the variation in the original data.

#The loadings for the principal components are stored in:
pca$rotation # with princomp(): pca$loadings


# This means that the first two principal component is a linear combination of the variables:

# PC1 = 0.521*Z_1 - 0.269*Z_2 + 0.580*Z_3 + 0.564*Z_4
#
# PC2 = -0.377*Z_1 - 0.923*Z_2 - 0.024*Z_3 - 0.066*Z_4
# where Z_1, \ldots, Z_4 are the standardization of original variables.

# The weights of the PC1 are similar except the associate to Sepal.Width variable that is negative. 
# This component discriminate on one side the Sepal.Width and on the other side the rest of variables (see biplot).  
# This one principal component accounts for over 72% of the variability in the data.
# All weights on the second principal component are negative. Thus the PC2 might seem considered as an overall size measurement.
# When the iris has larger sepal and petal values than average, the PC2 will be smaller than average. 
# This component explain the 23% of the variability.
#
# The following figure show the first two components and the observations on the same diagram, 
# which helps to interpret the factorial axes while looking at observations location.

#biplot of first two principal components
biplot(pca,cex=0.8)
abline(h = 0, v = 0, lty = 2, col = 8)

