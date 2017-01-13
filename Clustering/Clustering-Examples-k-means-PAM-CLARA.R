# Clustering with k-means, PAM, CLARA and Agglomerative clustering

# k-means with Iris dataset -----------------------------------------------------------------
# install.packages(c("factoextra", "ggplot2", "cluster"))
library(datasets)
library(cluster)  # necessary for PAM, CLARA, Silhouette
library(ggplot2)
library(factoextra) 

head(iris)
ggplot(iris, aes(Petal.Length, Petal.Width, color = Species)) + geom_point()

set.seed(1711)
# nstart = 20 means that R will try 20 different random starting 
# assignments and then select the one with the lowest within cluster variation.
# we only include columns 3 and 4 for computing
irisCluster <- kmeans(iris[,3:4], 3, nstart = 20)
irisCluster

# compare clusters 
table(irisCluster$cluster, iris$Species)

# The function fviz_cluster() [in factoextra] can be easily used to visualize
# clusters. Observations are represented by points in the plot, using 
# principal components if ncol(data) > 2. An ellipse is drawn around each cluster.
fviz_cluster(irisCluster, data = iris[, 3:4])

# plot with standard function
irisCluster$cluster <- as.factor(irisCluster$cluster)
ggplot(iris, aes(Petal.Length, Petal.Width, color = irisCluster$cluster)) + geom_point()


# k-means with Crime statistic --------------------------------------------------------------

# Load the data set
# USArrests contains statistics, in arrests per 100,000 residents for assault, 
# murder, and rape in each of the 50 US states in 1973. It includes also the 
# percent of the population living in urban areas.
data("USArrests")

# Remove any missing value (i.e, NA values for not available)
# That might be present in the data
df <- na.omit(USArrests)
# View the firt 6 rows of the data
head(df, n = 6)

# some descriptive statistic
desc_stats <- data.frame(
  Min = apply(df, 2, min), # minimum
  Med = apply(df, 2, median), # median
  Mean = apply(df, 2, mean), # mean
  SD = apply(df, 2, sd), # Standard deviation
  Max = apply(df, 2, max) # Maximum
)
desc_stats <- round(desc_stats, 1)
head(desc_stats)

# nearly the same result
# first one is easier to recognize 
summary(df)

# Note that the variables have a large different means and variances. 
# This is explained by the fact that the variables are measured in different units; 
# Murder, Rape, and Assault are measured as the number of occurrences per 
# 100 000 people, and UrbanPop is the percentage of the state’s population that 
# lives in an urban area.
# --> They must be standardized (i.e., scaled) to make them comparable.

df <- scale(df)
head(df)

# check ...
summary(df)

desc_stats <- data.frame(
  Min = apply(df, 2, min), # minimum
  Med = apply(df, 2, median), # median
  Mean = apply(df, 2, mean), # mean
  SD = apply(df, 2, sd), # Standard deviation
  Max = apply(df, 2, max) # Maximum
)
desc_stats <- round(desc_stats, 1)
head(desc_stats)

# Determine the number of optimal clusters in the data -------------------------
# How to choose the right number of expected clusters (k)?
# One  simple solution is to compute a clustering algorithm of interest using 
# different values of clusters k. Next, the wss (within sum of square) is drawn
# according to the number of clusters. The location of a bend (knee) in the plot
# is generally considered as an indicator of the appropriate number of clusters.
# We’ll use the function fviz_nbclust() [in factoextra package] which format is:
# fviz_nbclust(x, FUNcluster, method = c("silhouette", "wss"))


set.seed(1711)
fviz_nbclust(df, kmeans, method = "wss") + geom_vline(xintercept = 4, linetype = 2)

# Compute k-means clustering with k = 4
set.seed(1711)
km.res <- kmeans(df, 4, nstart = 25)
print(km.res)

aggregate(USArrests, by=list(cluster=km.res$cluster), mean)

# The function fviz_cluster() [in factoextra] can be easily used to visualize
# clusters. Observations are represented by points in the plot, using 
# principal components if ncol(data) > 2. An ellipse is drawn around each cluster.
fviz_cluster(km.res, data = df)

# PAM: Partitioning Around Medoids ---------------------------------------------
# The use of means implies that k-means clustering is highly sensitive to outliers. 
# This can severely affects the assignment of observations to clusters. 
# A more robust algorithm is provided by PAM algorithm (Partitioning Around Medoids) 
# which is also known as k-medoids clustering.
# 
# pam(x, k)
# x: possible values includes:
#    Numeric data matrix or numeric data frame: each row corresponds to an 
#    observation, and each column corresponds to a variable.
#    Dissimilarity matrix: in this case x is typically the output of daisy() or dist()
# k: The number of clusters


# Load data
data("USArrests")
# Scale the data and compute pam with k = 4
pam.res <- pam(scale(USArrests), 4)

# Medoids
pam.res$medoids

# CLuster vectors
head(pam.res$cluster)

# The result can be plotted using the function clusplot() [in cluster package]
clusplot(pam.res, main = "Cluster plot, k = 4", color = TRUE)

# or with fviz as you know
fviz_cluster(pam.res)

# raw a silhouette plot as follow:
plot(silhouette(pam.res),  col = 2:5)

# Silhouette Plot shows for each cluster:
#   The number of elements (nj) per cluster. Each horizontal line corresponds to an element. 
#     The length of the lines corresponds to silhouette width (Si), which is the 
#     means similarity of each element to its own cluster minus the mean similarity 
#     to the next most similar cluster
#   The average silhouette width
# 
# Observations with a large Si (almost 1) are very well clustered, a small Si 
# (around 0) means that the observation lies between two clusters, and observations 
# with a negative Si are probably placed in the wrong cluster.

# An alternative to draw silhouette plot is to use the function fviz_silhouette() [in factoextra]:
fviz_silhouette(silhouette(pam.res))

# It can be seen that some samples have a negative silhouette. This means that 
# they are not in the right cluster. We can find the name of these samples and 
# determine the clusters they are closer, as follow:
# Compute silhouette
sil <- silhouette(pam.res)[, 1:3]

# Objects with negative silhouette
neg_sil_index <- which(sil[, 'sil_width'] < 0)
sil[neg_sil_index, , drop = FALSE]


# CLARA: Clustering Large Applications---------------------------------------------------------------
# Note that, for large datasets, pam() may need too much memory or too much 
# computation time. In this case, the function clara() is preferable.
# CLARA is a partitioning method used to deal with much larger data sets 
# (more than several thousand observations) in order to reduce 
# computing time and RAM storage problem.

# The algorithm is as follow:
# 1. Split randomly the data sets in multiple subsets with fixed size
# 2. Compute PAM algorithm on each subset and choose the corresponding k 
#    representative objects (medoids). Assign each observation of the entire
#    dataset to the nearest medoid.
# 3. Calculate the mean (or the sum) of the dissimilarities of the observations
#    to their closest medoid. This is used as a measure of the goodness of the clustering.
# 4. Retain the sub-dataset for which the mean (or sum) is minimal. A further 
#    analysis is carried out on the final partition.

# The function clara() [in cluster package] can be used:
#   
#   clara(x, k, samples = 5)
# 
# x: a numeric data matrix or data frame, each row corresponds to an observation, and each column corresponds to a variable.
# k: the number of cluster
# samples: number of samples to be drawn from the dataset. Default value is 5 but it’s recommended a much larger value.

set.seed(1711)
# Generate 500 objects, divided into 2 clusters.
# rnorm(n, mean, sd)
x <- rbind(cbind(rnorm(2000,0,14), rnorm(2000,0,14)),
           cbind(rnorm(3000,50,14), rnorm(3000,50,14)))
head(x)

# Compute clara
clarax <- clara(x, 2, samples=100)
# Cluster plot
fviz_cluster(clarax, stand = FALSE, geom = "point",
             pointsize = 1)

# Silhouette plot
plot(silhouette(clarax),  col = 2:3, main = "Silhouette plot") 

# The output of the function clara() includes the following components:
# medoids: Objects that represent clusters
# clustering: a vector containing the cluster number of each object
# sample: labels or case numbers of the observations in the best sample, 
#          that is, the sample used by the clara algorithm for the final partition.

# Medoids
clarax$medoids

# Agglomerative clustering -----------------------------------------------------
library(MVA) # for data
?pottery

## Scale data
potsData <- pottery[, colnames(pottery) != "kiln"]
pots <- scale(potsData, center = FALSE, scale = TRUE)

## euclidean distance matrix
dp <- dist(pots) 

## Apply agglomerative clutstering using complete linkage
cc <- hclust(dp, method = "complete")

## Investigate result
plot(cc)

## Split into 3 groups
grps <- cutree(cc, k = 3)
grps

## Silhouette Plot from package "cluster"
plot(silhouette(grps, dp))

# Ward’s method says that the distance between two clusters, A and B, is how
# much the sum of squares will increase when we merge them
cward <- hclust(dp, method = "ward.D")
plot(cward)
