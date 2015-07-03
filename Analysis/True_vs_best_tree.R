#Script for testing the effect of missing data on tree topology.
setwd('Analysis/')

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
#-----------------------
#ML chains
#-----------------------
#Best trees
setwd("../Data/Tree_Comparisons/True_trees/ML/besttree")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
ML_besttrees<-NTS(tmp, Random51)
setwd('../../../../../Analysis/')

#Bootstraps
#setwd("../Data/Tree_Comparisons/ML/bootstraps")
#tmp<-TreeCmp.Read('Chain', verbose=TRUE)
#ML_bootstraps<-NTS(tmp, Random51[-7])
#setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')

#-----------------------
#Bayesian chains
#-----------------------
#Consensus
setwd("../Data/Tree_Comparisons/True_trees/Bayesian/consensus")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
Bayesian_contrees<-NTS(tmp, Random51)
setwd('../../../../../Analysis/')

#Treesets
#setwd("../Data/Tree_Comparisons/WithRFL/Bayesian/treesets")
#tmp<-TreeCmp.Read('Chain', verbose=TRUE)
#Bayesian_treesets<-NTS(tmp, Random51)
#setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')


#########################
#Saving the data
#########################
#save(ML_besttrees, file="../Data/R_data/TreeCmp-TRUE-ML_bestrees.Rda")
#save(ML_bootstraps, file="../Data/R_data/TreeCmp-TRUE-ML_bootstraps.Rda")
#save(Bayesian_contrees, file="../Data/R_data/TreeCmp-TRUE-Bayesian_contrees.Rda")
#save(Bayesian_treesets, file="../Data/R_data/TreeCmp-TRUE-Bayesian_treesets.Rda")

#Quick load
load("../Data/R_data/TreeCmp-TRUE-ML_bestrees.Rda")
#load("../Data/R_data/TreeCmp-TRUE-ML_bootstraps.Rda")
load("../Data/R_data/TreeCmp-TRUE-Bayesian_contrees.Rda")
#load("../Data/R_data/TreeCmp-TRUE-Bayesian_treesets.Rda")

#Setting up the parameters
par_ML<-c(1,26,51,76,101)
par_MF<-c(1,6,11,16,21)
par_MC<-c(1:5)
par_MLMF<-c(1,6,11,16,21, 26,31,36,41,46, 51,56,61,66,71, 76,81,86,91,96, 101,106,111,116,121)
par_MLMC<-c(1:5, 26:30, 51:55, 76:80, 101:105)
par_MFMC<-c(1:25)
par_MLMFMC<-c(1:125)

#########################
#Comparing the true trees vs the best trees
#########################
Best_trees_ML<-ML_besttrees[1] ; class(Best_trees_ML) <- class(ML_besttrees)
Best_trees_Bayesian<-Bayesian_contrees[1] ; class(Best_trees_Bayesian) <- class(Bayesian_contrees)

op<-par(mfrow=c(2,2),bty="l")
hdr.den(ML_besttrees[[1]]$R.F_Cluster, prob=c(50, 95), xlab="Normalised Robinson-Foulds metric", main="Maximum Likelihood")
hdr.den(Best_trees_Bayesian[[1]]$R.F_Cluster, prob=c(50, 95), xlab="Normalised Robinson-Foulds metric", main="Bayesian Inference", ylab="")
hdr.den(ML_besttrees[[1]]$Triples, prob=c(50, 95), xlab="Normalised Triplets metric", main="")
hdr.den(Best_trees_Bayesian[[1]]$Triples, prob=c(50, 95), xlab="Normalised Triplets metric", main="", ylab="")
par(op)

#########################
#Comparing the true trees vs all the trees
#########################

#data parameters setup
data.sets<-c("ML_besttrees","Bayesian_contrees")
metrics<-c("R.F_Cluster","Triples")

global.TreeCmp.plot( data.sets , par_MLMFMC, metrics, col=c('black', 'grey'), las=2, probs=c(95, 50), ylim=c(0,1,-0.5,0.5), xaxis=NULL, las=2, xlab=NULL, shift=0.5, format='A5', col.grad=c("white", "black")) 

#Why are the Bayesian trees getting better? Maybe because of the level of dissimilarity between the best and the true tree.
#As the best tree is fairly different from the true tree in RF, when the Bayesian consensus tree loses data, it becomes more of a unresolved tree.
#Therefore, the difference between the clades in the true tree and the missing data trees (politomies) are more similar than the one between the best tree.
#One can argue that then polytomical trees are shittier but it's probably wrong: an unresolved node (equivalent to a NA) is better than a wrongly resolved node (equivalent to a false positive)

#The idea is that the way the Bayesian topology is built is fundamently different than the likelihood one.
#I likelihood, a single topology is calculated: that's the most likely one (i.e. the equation as a finite number of solutions).
#Then the bootstrap is meant to show a posteriori (and the world is important here) the strength of our hypothesis (i.e. this is the best solution) to bootstrapping (i.e. quicking the data and checking the recovery rate).
#On the other hand, in Bayesian, a set of good topologies is calculated (i.e. there is an infinite solutions to the equation).
#Then the topology is built a posteriori (again, I emphasize that, in ML the support for the solution (topology) is built a posteriori (kind of ad hoc) as in Bayesian, solution is build a posteriori (from a distribution of solutions)).
#This makes it more likely for the ML method to just pick the wrong topology knowing the data (that is more and more wrong when data is lacking) and then to try to support it a posteriori.
#In the Bayesian case, it is more likely that the topology will be unresolved as the data is lacking and therefore being still robust clade conservation wise (but shit wild taxa wild).