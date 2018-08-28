# Generate a sample data.frame to play with
library(splitstackshape)

set.seed(1711)

dat1 <- data.frame(ID = 1:100,
                   A = sample(c("AA", "BB", "CC", "DD", "EE"),
                              100, replace = TRUE),
                   B = rnorm(100), C = abs(round(rnorm(100), digits=1)),
                   D = sample(c("CA", "NY", "TX"), 100, replace = TRUE),
                   E = sample(c("M", "F"), 100, replace = TRUE))

# Let's take a 10\% sample from all -A- groups in dat1
stratified(dat1, "A", .1)

# Let's take a 10\% sample from only "AA" and "BB" groups from -A- in dat1
stratified(dat1, "A", .1, select = list(A = c("AA", "BB")))

# Let's take 5 samples from all -D- groups in dat1,
#   specified by column number
stratified(dat1, group = 5, size = 5)

# Use a two-column strata: -E- and -D-
#   -E- varies more slowly, so it is better to put that first
stratified(dat1, c("E", "D"), size = .15)

# Use a two-column strata (-E- and -D-) but only interested in
#   cases where -E- == "M"
stratified(dat1, c("E", "D"), .15, select = list(E = "M"))

## As above, but where -E- == "M" and -D- == "CA" or "TX"
stratified(dat1, c("E", "D"), .15,
           select = list(E = "M", D = c("CA", "TX")))

# Use a three-column strata: -E-, -D-, and -A-
s.out <- stratified(dat1, c("E", "D", "A"), size = 2)

# Simple Function -------------------
d <- expand.grid(id = 1:1000, stratum = letters[1:5])

p = 0.1

dsample <- data.frame()

system.time(
  for(i in levels(d$stratum)) {
    dsub <- subset(d, d$stratum == i)
    B = ceiling(nrow(dsub) * p)
    dsub <- dsub[sample(1:nrow(dsub), B), ]
    dsample <- rbind(dsample, dsub) 
  }
)

table(d$stratum)

# size per stratum in resulting df is 10 % of original size:
table(dsample$stratum)

