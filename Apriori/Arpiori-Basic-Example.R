# Apriori
# Apriori is a class algorithm that helps to learn association rules. It works against
# transactions. The algorithm attempts to find subsets that are common within a dataset.
# A minimum threshold must be met in order for the association to be confirmed.
# The concept of support and confidence for apriori is of particular interest. The
# apriori method will return associations of interest from your dataset, such as
# X when we have Y. Support is the percent of transactions containing X and Y.
# Confidence is the percentage of transactions that contain X and also contain Y.
# The default values are 10 percent for support and 80 percent for confidence.

library(arules)    # apriori algorithm
library(arulesViz) # for visualization

# We create manually transactions 
a_list<-list(c("CrestTP","CrestTB"), c("OralBTB"),c("BarbSC"),
             c("ColgateTP","BarbSC"), c("OldSpiceSC"), c("CrestTP","CrestTB"),
             c("Sebamed","SpeickDeoDusch","OldSpiceSC"), c("ColgateTP","SpeickDeoDusch"),
             c("Sebamed","OralBTB"), c("CrestTP","BarbSC"),
             c("Weleda","Dr.Hauschka"),
             c("ColgateTP","GilletteSC"), c("CrestTP","OralBTB"),
             c("Sebamed"), c("Sebamed","SpeickDeoDusch","BarbSC"),
             c("ColgateTP","CrestTB","GilletteSC"),
             c("CrestTP","CrestTB","OldSpiceSC"), c("OralBTB"),
             c("Sebamed","OralBTB","OldSpiceSC"),
             c("Sebamed","NiveaSensitive","OldSpiceSC"),
             c("Weleda","OldSpiceSC"),
             c("Weleda","Dr.Hauschka","NiveaSensitive"),
             c("Weleda","Dr.Hauschka","OldSpiceSC"),
             c("ColgateTP","GilletteSC"), c("OralBTB","OldSpiceSC"))

names(a_list) <- paste("Tr", c(1:25), sep = "")

transactions <- as(a_list, "transactions")

summary(transactions) 

# all
inspect(transactions)
# first five elements
inspect(transactions[1:5])

# examine the frequency of the first three items
# items are stored in the matrix in alphabetical order 
itemFrequency(transactions[, 1:3])

# plot the frequency of items
itemFrequencyPlot(transactions, support = 0.10)
itemFrequencyPlot(transactions, topN = 10)

# a visualization of the sparse matrix for the first ten transactions
image(transactions[1:10])

# visualization of a random sample of 100 transactions
image(sample(transactions, 100))

# Learn rules
?apriori

rules<-apriori(transactions,parameter=list(supp=0.02, conf=0.5, minlen=2, target="rules"))
inspect(head(sort(rules,by="lift"), n=20))

# Package arulesViz supports visualization of association rules with 
# scatter plot, balloon plot, graph, parallel coordinates plot, etc.
rules_vis <- head(sort(rules,by="lift"), n=5) # a selection
inspect(rules_vis)
plot(rules)
plot(rules_vis, method="graph", control=list(type="items"))
plot(rules_vis, method="matrix", control=list(type="items"))

plot(rules_vis, method="matrix", measure="lift", control=list(type="items"))
plot(rules_vis, method="matrix", measure=c("lift", "confidence"), control=list(type="items"))

plot(rules_vis, method="paracoord", control=list(reorder=TRUE))

# try different parameters
rules<-apriori(transactions,parameter=list(supp=0.05, conf=0.5, minlen=2, target="rules"))
inspect(head(sort(rules,by="lift"), n=10))

rules<-apriori(transactions,parameter=list(supp=0.1, conf=0.5, minlen=2, target="rules"))
inspect(head(sort(rules,by="lift"), n=10))

rules<-apriori(transactions,parameter=list(supp=0.1, conf=0.7, minlen=2, target="rules"))
inspect(head(sort(rules,by="lift"), n=10))
