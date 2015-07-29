#Script for testing the effect of the starting tree in the Bayesian inference analysis.

#Loading the functions
sourceDir <- function(path, trace = TRUE, ...) {
    for (nm in list.files(path, pattern = "[.][RrSsQq]$")) {
    if(trace) cat(nm,":")
        source(file.path(path, nm), ...)
        if(trace) cat("\n")
    }
}
sourceDir(path="../Functions/TreeComparisons/")
library(ape)

#Loading the Random tree comparisons
Random51<-read.table("../Data/Tree_Comparisons/RandomTrees/51t_Random.Cmp",header=TRUE)
#Remove RFL
Random51<-Random51[,-7]

#########################
#Loading the treesets
#########################
#Random starting tree to best tree
setwd("../Data/Starting_tree/consensus/Rand_to_best/")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
Rand_to_best<-NTS(tmp, Random51)
setwd('../../../../Analysis/')

#Random starting tree to true tree
setwd("../Data/Starting_tree/consensus/Rand_to_true/")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
Rand_to_true<-NTS(tmp, Random51)
setwd('../../../../Analysis/')

#Random starting tree to best tree
setwd("../Data/Starting_tree/consensus/True_to_best/")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
True_to_best<-NTS(tmp, Random51)
setwd('../../../../Analysis/')

#Random starting tree to true tree
setwd("../Data/Starting_tree/consensus/True_to_true/")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
True_to_true<-NTS(tmp, Random51)
setwd('../../../../Analysis/')

#########################
#Plotting the differences
#########################

#Plotting the results (RF)
quartz(width = 8.3, height = 5.8) #A5 landscape
op<-par(mfrow=c(1,2), bty="l", oma=c(0,0,0,0))
TreeCmp.Plot(True_to_best, "R.F_Cluster", probs=c(95, 50), plot=TRUE, col=palette()[1], lines=TRUE, add=FALSE, shift=0, ylim=c(0,1), save.details=FALSE, xaxis='auto', ylab='Normalised Robinson-Foulds metric', xlab=NULL)
TreeCmp.Plot(Rand_to_best, "R.F_Cluster", probs=c(95, 50), plot=TRUE, col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=c(0,1), save.details=FALSE, xaxis='auto', ylab='Normalised Robinson-Foulds metric', xlab=NULL)
TreeCmp.Plot(True_to_true, "R.F_Cluster", probs=c(95, 50), plot=TRUE, col=palette()[3], lines=TRUE, add=TRUE, shift=0.2, ylim=c(0,1), save.details=FALSE, xaxis='auto', ylab='Normalised Robinson-Foulds metric', xlab=NULL)
TreeCmp.Plot(Rand_to_true, "R.F_Cluster", probs=c(95, 50), plot=TRUE, col=palette()[4], lines=TRUE, add=TRUE, shift=0.3, ylim=c(0,1), save.details=FALSE, xaxis='auto', ylab='Normalised Robinson-Foulds metric', xlab=NULL)
legend(3.8,0.4, legend=c("True tree (start) vs best tree","Random tree (start) vs best tree", "True tree (start) vs true tree", "Random tree (start) vs true tree"), col=palette()[1:4], pch=19, cex=0.7)
#Plotting the results (Tr)
TreeCmp.Plot(True_to_best, "Triples", probs=c(95, 50), plot=TRUE, col=palette()[1], lines=TRUE, add=FALSE, shift=0, ylim=c(-0.5,1), save.details=FALSE, xaxis='auto', ylab='Normalised Triplets metric', xlab=NULL)
abline(h=0, lty=3)
TreeCmp.Plot(Rand_to_best, "Triples", probs=c(95, 50), plot=TRUE, col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=c(-0.5,1), save.details=FALSE, xaxis='auto', ylab='Normalised Triplets metric', xlab=NULL)
TreeCmp.Plot(True_to_true, "Triples", probs=c(95, 50), plot=TRUE, col=palette()[3], lines=TRUE, add=TRUE, shift=0.2, ylim=c(-0.5,1), save.details=FALSE, xaxis='auto', ylab='Normalised Triplets metric', xlab=NULL)
TreeCmp.Plot(Rand_to_true, "Triples", probs=c(95, 50), plot=TRUE, col=palette()[4], lines=TRUE, add=TRUE, shift=0.3, ylim=c(-0.5,1), save.details=FALSE, xaxis='auto', ylab='Normalised Triplets metric', xlab=NULL)
legend(3.8,1, legend=c("True tree (start) vs best tree","Random tree (start) vs best tree", "True tree (start) vs true tree", "Random tree (start) vs true tree"), col=palette()[1:4], pch=19, cex=0.7)
par(op)

#########################
#Measuring the differences (using Bhattacharrya)
#########################

bhatt.coeff(True_to_best$L00F00C00$R.F_Cluster, Rand_to_best$L00F00C00$R.F_Cluster)
bhatt.coeff(True_to_best$L10F10C10$R.F_Cluster, Rand_to_best$L10F10C10$R.F_Cluster)
bhatt.coeff(True_to_best$L25F25C25$R.F_Cluster, Rand_to_best$L25F25C25$R.F_Cluster)
bhatt.coeff(True_to_best$L50F50C50$R.F_Cluster, Rand_to_best$L50F50C50$R.F_Cluster)
bhatt.coeff(True_to_best$L75F75C75$R.F_Cluster, Rand_to_best$L75F75C75$R.F_Cluster)


#########################
#Measuring the differences (anova)
#########################

#Preparing the data
#Comparisons to best tree
True_RF<-c(True_to_best[[1]][[4]])
True_Tr<-c(True_to_best[[1]][[6]])
Rand_RF<-c(Rand_to_best[[1]][[4]], mean(Rand_to_best[[2]][[4]])) #One value is missing
Rand_Tr<-c(Rand_to_best[[1]][[6]], mean(Rand_to_best[[2]][[6]])) #One value is missing
for (tree in 2:length(True_to_best)) {
    True_RF<-c(True_RF, True_to_best[[tree]][[4]])
    True_Tr<-c(True_Tr, True_to_best[[tree]][[6]])
    Rand_RF<-c(Rand_RF, Rand_to_best[[tree]][[4]])
    Rand_Tr<-c(Rand_Tr, Rand_to_best[[tree]][[6]])
}
trees<-c(rep("0", 20),rep("10", 20),rep("25", 20),rep("50", 20),rep("75", 20))
best_RF_test<-data.frame("RF"=c(True_RF, Rand_RF), "starting"=as.factor(c(rep("true", 100), rep("rand", 100))), "miss.data"=rep(trees,2))
best_Tr_test<-data.frame("Tr"=c(True_Tr, Rand_Tr), "starting"=as.factor(c(rep("true", 100), rep("rand", 100))), "miss.data"=rep(trees,2))
#Comparisons to best true

True_RF<-c(True_to_true[[1]][[4]])
True_Tr<-c(True_to_true[[1]][[6]])
Rand_RF<-c(Rand_to_true[[1]][[4]], mean(Rand_to_true[[2]][[4]])) #One value is missing
Rand_Tr<-c(Rand_to_true[[1]][[6]], mean(Rand_to_true[[2]][[6]])) #One value is missing
for (tree in 2:length(True_to_true)) {
    True_RF<-c(True_RF, True_to_true[[tree]][[4]])
    True_Tr<-c(True_Tr, True_to_true[[tree]][[6]])
    Rand_RF<-c(Rand_RF, Rand_to_true[[tree]][[4]])
    Rand_Tr<-c(Rand_Tr, Rand_to_true[[tree]][[6]])
}
true_RF_test<-data.frame("RF"=c(True_RF, Rand_RF), "starting"=as.factor(c(rep("true", 100), rep("rand", 100))), "miss.data"=rep(trees,2))
true_Tr_test<-data.frame("Tr"=c(True_Tr, Rand_Tr), "starting"=as.factor(c(rep("true", 100), rep("rand", 100))), "miss.data"=rep(trees,2))






#Running the tests
library(xtable)
library(lme4)
#General effect
best_RF<-(summary(lm(RF~starting, data=best_RF_test)))
best_Tr<-(summary(lm(Tr~starting, data=best_Tr_test)))
true_RF<-(summary(lm(RF~starting, data=true_RF_test)))
true_Tr<-(summary(lm(Tr~starting, data=true_Tr_test)))

tmp1<-rbind(best_RF[[4]], best_Tr[[4]],true_RF[[4]], true_Tr[[4]])
comp<-c(rep("best",4),rep("true",4))
metric<-rep(c(rep("RF",2),rep("Tr",2)),2)
tmp2<-matrix(data=c(comp, metric, rownames(tmp)), nrow=8, byrow=FALSE)
tmp3<-cbind(tmp2, tmp1)
rownames(tmp3)<-NULL ; colnames(tmp3)[1:3]<-c("Comparison", "metric", "term")
xtable(as.data.frame(tmp3), digit=3) # Digit problem


#Nested effect
xtable(summary(lmList(RF~starting | miss.data, data=best_RF_test))[[4]][,,2])
xtable(summary(lmList(Tr~starting | miss.data, data=best_Tr_test))[[4]][,,2])
xtable(summary(lmList(RF~starting | miss.data, data=true_RF_test))[[4]][,,2])
xtable(summary(lmList(Tr~starting | miss.data, data=true_Tr_test))[[4]][,,2])



