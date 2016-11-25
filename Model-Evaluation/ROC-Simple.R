#### A small introduction to the ROCR package
# See https://hopstat.wordpress.com/2014/12/19/a-small-introduction-to-the-rocr-package/

library(ROCR)
data(ROCR.simple)
str(ROCR.simple)
head(cbind(ROCR.simple$predictions, ROCR.simple$labels), 5)

pred <- prediction(ROCR.simple$predictions,ROCR.simple$labels)
class(pred)
slotNames(pred)

# Plot ROC
# At every cutoff, the TPR and FPR are calculated and plotted. The smoother 
# the graph, the more cutoffs the predictions have.
# You see gains in sensitivity (true positive rate, > 80%), trading off a 
# false positive rate (1- specificity), up until about 15% FPR. After an FPR 
# of 15%, we don't see significant gains in TPR for a tradeoff of increased FPR.
roc.perf = performance(pred, measure = "tpr", x.measure = "fpr")
plot(roc.perf)
abline(a=0, b= 1)

# multiple sets of prediction and labels
# ROCR.hiv dataset shows how this works if more than one set of predictions and labels are supplied.

data(ROCR.hiv)
manypred = prediction(ROCR.hiv$hiv.nn$predictions, ROCR.hiv$hiv.nn$labels)
sn = slotNames(pred)
sapply(sn, function(x) length(slot(manypred, x)))

sapply(sn, function(x) class(slot(manypred, x)))

roc.perf = performance(manypred, measure = "tpr", x.measure = "fpr")
plot(roc.perf)
abline(a=0, b= 1)
