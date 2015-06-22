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
#Random26<-read.table("../Data/Tree_Comparisons/RandomTrees/26t_Random.Cmp",header=TRUE)
#Random25<-read.table("../Data/Tree_Comparisons/RandomTrees/25t_Random.Cmp",header=TRUE)

#Loading the treesets

#ML chains

#Best trees
setwd("../Data/Tree_Comparisons/WithRFL/ML/besttree")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
ML_besttrees<-NTS(tmp, Random51)
setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')

#Bootstraps
setwd("../Data/Tree_Comparisons/ML/bootstraps")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
ML_bootstraps<-NTS(tmp, Random51[-7])
setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')

#Bayesian chains

#Consensus
setwd("../Data/Tree_Comparisons/WithRFL/Bayesian/consensus")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
Bayesian_contrees<-NTS(tmp, Random51)
setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')

#Treesets
setwd("../Data/Tree_Comparisons/WithRFL/Bayesian/treesets")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
Bayesian_treesets<-NTS(tmp, Random51)
setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')

#Isolating the parameters per chains
par_ML<-c(1,26,51,76,101)
par_MF<-c(1,6,11,16,21)
par_MC<-c(1:5)
par_MLMF<-c(1,6,11,16,21, 26,31,36,41,46, 51,56,61,66,71, 76,81,86,91,96, 101,106,111,116,121)
par_MLMC<-c(1:5, 26:30, 51:55, 76:80, 101:105)
par_MFMC<-c(1:25)
par_MLMFMC<-c(1:125)

#Plots

#Setting the metric
metric="RFL"
#metric="R.F_Cluster"
#metric="Triples"
#colour figures palette("default")
#BW figures  
#palette(c("black", "gray50"))
#fix ylim
ylim=c(0,1)



###################
#Global trends plots [single]
###################
op<-par(mfrow=c(3,1))
par<-par_MLMFMC
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
#ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
#Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)

#Setting the RF plot
metric="R.F_Cluster"
main="Global trend with RF [single]"
#ML plot
TreeCmp.Plot( ML_best , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
legend(1,0.8, c("ML", "Bayesian"), pch=19, col=palette()[1:2])

#Setting the Triples plot
metric="Triples"
main="Global trend with Triples [single]"
#ML plot
TreeCmp.Plot( ML_best , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)

#Setting the RF plot
metric="RFL"
main="Global trend with RFL [single]"
#ML plot
TreeCmp.Plot( ML_best , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)

par(op)


###################
#Global trends plots [treeset]
###################
op<-par(mfrow=c(3,1))
par<-par_MLMFMC
#ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
#Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)

#Setting the RF plot
metric="R.F_Cluster"
main="Global trend with RF [treeset]"
#ML plot
TreeCmp.Plot( ML_boot , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
legend(1,0.8, c("ML", "Bayesian"), pch=19, col=palette()[1:2])

#Setting the Triples plot
metric="Triples"
main="Global trend with Triples [treeset]"
#ML plot
TreeCmp.Plot( ML_boot , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)

#Setting the RF plot
metric="RFL"
main="Global trend with RFL [treeset]"
#ML plot
#TreeCmp.Plot( ML_boot , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, main=main, ylim=ylim)

par(op)




###################
#Parameters per metric in ML and Bayesian [single]
###################

#Parameters
par<-par_ML
main="Missing Living [single]"
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
#ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
#Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)

op<-par(mfrow=c(3,3))
#Setting the ML plot
metric="R.F_Cluster"
par<-par_ML
main="Missing Living [single]"
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
#ML plot
TreeCmp.Plot( ML_best , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
legend(1,0.8, c("ML", "Bayesian"), pch=19, col=palette()[1:2])

#Setting the ML plot
metric="Triples"
par<-par_ML
main="Missing Living [single]"
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
#ML plot
TreeCmp.Plot( ML_best , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)

#Setting the ML plot
metric="RFL"
par<-par_ML
main="Missing Living [single]"
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
#ML plot
TreeCmp.Plot( ML_best , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)

#Setting the MF plot
metric="R.F_Cluster"
par<-par_MF
main="Missing Fossil [single]"
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
#ML plot
TreeCmp.Plot( ML_best , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)

#Setting the MF plot
metric="Triples"
par<-par_MF
main="Missing Fossil [single]"
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
#ML plot
TreeCmp.Plot( ML_best , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)

#Setting the MF plot
metric="RFL"
par<-par_MF
main="Missing Fossil [single]"
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
#ML plot
TreeCmp.Plot( ML_best , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)

#Setting the MC plot
metric="R.F_Cluster"
par<-par_MC
main="Missing Character [single]" 
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
#ML plot
TreeCmp.Plot( ML_best , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)

#Setting the MC plot
metric="Triples"
par<-par_MC
main="Missing Character [single]"
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
#ML plot
TreeCmp.Plot( ML_best , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)

#Setting the MC plot
metric="RFL"
par<-par_MC
main="Missing Character [single]"
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
#ML plot
TreeCmp.Plot( ML_best , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)

par(op)


###################
#Parameters per metric in ML and Bayesian [treeset]
###################

#Parameters
par<-par_ML
main="Missing Living [treeset]"
#ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
#Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)

op<-par(mfrow=c(3,3))
#Setting the ML plot
metric="R.F_Cluster"
par<-par_ML
main="Missing Living [treeset]"
ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)
#ML plot
TreeCmp.Plot( ML_boot , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
legend(1,0.8, c("ML", "Bayesian"), pch=19, col=palette()[1:2])

#Setting the ML plot
metric="Triples"
par<-par_ML
main="Missing Living [treeset]"
ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)
#ML plot
TreeCmp.Plot( ML_boot , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)

#Setting the ML plot
metric="RFL"
par<-par_ML
main="Missing Living [treeset]"
#ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)
#ML plot
#TreeCmp.Plot( ML_boot , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, ylim=ylim, main=main)

#Setting the MF plot
metric="R.F_Cluster"
par<-par_MF
main="Missing Fossil [treeset]"
ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)
#ML plot
TreeCmp.Plot( ML_boot , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)

#Setting the MF plot
metric="Triples"
par<-par_MF
main="Missing Fossil [treeset]"
ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)
#ML plot
TreeCmp.Plot( ML_boot , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)

#Setting the MF plot
metric="RFL"
par<-par_MF
main="Missing Fossil [treeset]"
#ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)
#ML plot
#TreeCmp.Plot( ML_boot , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, ylim=ylim, main=main)

#Setting the MC plot
metric="R.F_Cluster"
par<-par_MC
main="Missing Character [treeset]"
ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)
#ML plot
TreeCmp.Plot( ML_boot , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)

#Setting the MC plot
metric="Triples"
par<-par_MC
main="Missing Character [treeset]"
ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)
#ML plot
TreeCmp.Plot( ML_boot , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)

#Setting the MC plot
metric="RFL"
par<-par_MC
main="Missing Character [treeset]"
#ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)
#ML plot
#TreeCmp.Plot( ML_boot , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, ylim=ylim, main=main)

par(op)




###################
#Fossil vs. Living vs. Character plot in ML or Bayesian in RF/Triples [single]
###################

op<-par(mfrow=c(2,3))
#ML plots
#Setting the ML plot in RF
metric="R.F_Cluster"
main="Missing data in ML (RF) [single]"
ML_ML<-ML_besttrees[par_ML] ; class(ML_ML)<-class(ML_besttrees)
ML_MF<-ML_besttrees[par_MF] ; class(ML_MF)<-class(ML_besttrees)
ML_MC<-ML_besttrees[par_MC] ; class(ML_MC)<-class(ML_besttrees)
#ML plot
TreeCmp.Plot( ML_ML , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_MF , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
TreeCmp.Plot( ML_MC , metric, probs=c(95, 50), col=palette()[3], lines=TRUE, add=TRUE, shift=0.2, ylim=ylim, save.details=FALSE)
legend(1, 0.4, c("Missing living", "Missing Fossil", "Missing Character"), col=palette()[1:3], pch=19)

#Setting the ML plot in Triples
metric="Triples"
main="Missing data in ML (Triples) [single]"
#ML plot
TreeCmp.Plot( ML_ML , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_MF , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
TreeCmp.Plot( ML_MC , metric, probs=c(95, 50), col=palette()[3], lines=TRUE, add=TRUE, shift=0.2, ylim=ylim, save.details=FALSE)
#legend(1, 0.4, c("Missing living", "Missing Fossil"), col=palette()[1:2], pch=19)

#Setting the ML plot in RFL
metric="RFL"
main="Missing data in ML (RFL) [single]"
#ML plot
TreeCmp.Plot( ML_ML , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_MF , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
TreeCmp.Plot( ML_MC , metric, probs=c(95, 50), col=palette()[3], lines=TRUE, add=TRUE, shift=0.2, ylim=ylim, save.details=FALSE)
#legend(1, 0.4, c("Missing living", "Missing Fossil"), col=palette()[1:2], pch=19)


#ML plots
#Setting the ML plot in RF
metric="R.F_Cluster"
main="Missing data in Bayesian (RF) [single]"
Bay_ML<-Bayesian_contrees[par_ML] ; class(Bay_ML)<-class(Bayesian_contrees)
Bay_MF<-Bayesian_contrees[par_MF] ; class(Bay_MF)<-class(Bayesian_contrees)
Bay_MC<-Bayesian_contrees[par_MC] ; class(Bay_MC)<-class(Bayesian_contrees)

#ML plot
TreeCmp.Plot( Bay_ML , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_MF , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
TreeCmp.Plot( Bay_MC , metric, probs=c(95, 50), col=palette()[3], lines=TRUE, add=TRUE, shift=0.2, ylim=ylim, save.details=FALSE)
#legend(1, 0.4, c("Missing living", "Missing Fossil"), col=palette()[1:2], pch=19)

#Setting the ML plot in Triples
metric="Triples"
main="Missing data in Bayesian (Triples) [single]"
#ML plot
TreeCmp.Plot( Bay_ML , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_MF , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
TreeCmp.Plot( Bay_MC , metric, probs=c(95, 50), col=palette()[3], lines=TRUE, add=TRUE, shift=0.2, ylim=ylim, save.details=FALSE)

#Setting the ML plot in RFL
metric="RFL"
main="Missing data in Bayesian (RFL) [single]"
TreeCmp.Plot( Bay_ML , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_MF , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
TreeCmp.Plot( Bay_MC , metric, probs=c(95, 50), col=palette()[3], lines=TRUE, add=TRUE, shift=0.2, ylim=ylim, save.details=FALSE)
#legend(1, 0.4, c("Missing living", "Missing Fossil"), col=palette()[1:2], pch=19)

par(op)

###################
#Fossil vs. Living vs. Character plot in ML or Bayesian in RF/Triples [treesets]
###################

op<-par(mfrow=c(2,3))
#ML plots
#Setting the ML plot in RF
metric="R.F_Cluster"
main="Missing data in ML (RF) [treeset]"
ML_ML<-ML_bootstraps[par_ML] ; class(ML_ML)<-class(ML_bootstraps)
ML_MF<-ML_bootstraps[par_MF] ; class(ML_MF)<-class(ML_bootstraps)
ML_MC<-ML_bootstraps[par_MC] ; class(ML_MC)<-class(ML_bootstraps)
#ML plot
TreeCmp.Plot( ML_ML , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_MF , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
TreeCmp.Plot( ML_MC , metric, probs=c(95, 50), col=palette()[3], lines=TRUE, add=TRUE, shift=0.2, ylim=ylim, save.details=FALSE)
legend(1, 0.4, c("Missing living", "Missing Fossil", "Missing Character"), col=palette()[1:3], pch=19)

#Setting the ML plot in Triples
metric="Triples"
main="Missing data in ML (Triples) [treeset]"
#ML plot
TreeCmp.Plot( ML_ML , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_MF , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
TreeCmp.Plot( ML_MC , metric, probs=c(95, 50), col=palette()[3], lines=TRUE, add=TRUE, shift=0.2, ylim=ylim, save.details=FALSE)
#legend(1, 0.4, c("Missing living", "Missing Fossil"), col=palette()[1:2], pch=19)

#Setting the ML plot in RFL
metric="RFL"
main="Missing data in ML (RFL) [treeset]"
#ML plot
plot(1)
#TreeCmp.Plot( ML_ML , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
#TreeCmp.Plot( ML_MF , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
#TreeCmp.Plot( ML_MC , metric, probs=c(95, 50), col=palette()[3], lines=TRUE, add=TRUE, shift=0.2, ylim=ylim, save.details=FALSE)
#legend(1, 0.4, c("Missing living", "Missing Fossil"), col=palette()[1:2], pch=19)


#ML plots
#Setting the ML plot in RF
metric="R.F_Cluster"
main="Missing data in Bayesian (RF) [treeset]"
Bay_ML<-Bayesian_treesets[Bay_ML] ; class(Bay_ML)<-class(Bayesian_treesets)
Bay_MF<-Bayesian_treesets[par_MF] ; class(Bay_MF)<-class(Bayesian_treesets)
Bay_MC<-Bayesian_treesets[par_MC] ; class(Bay_MC)<-class(Bayesian_treesets)

#ML plot
TreeCmp.Plot( Bay_ML , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_MF , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
TreeCmp.Plot( Bay_MC , metric, probs=c(95, 50), col=palette()[3], lines=TRUE, add=TRUE, shift=0.2, ylim=ylim, save.details=FALSE)
#legend(1, 0.4, c("Missing living", "Missing Fossil"), col=palette()[1:2], pch=19)

#Setting the ML plot in Triples
metric="Triples"
main="Missing data in Bayesian (Triples) [treeset]"
#ML plot
TreeCmp.Plot( Bay_ML , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_MF , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
TreeCmp.Plot( Bay_MC , metric, probs=c(95, 50), col=palette()[3], lines=TRUE, add=TRUE, shift=0.2, ylim=ylim, save.details=FALSE)

#Setting the ML plot in RFL
metric="RFL"
main="Missing data in Bayesian (RFL) [treeset]"
TreeCmp.Plot( Bay_ML , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( Bay_MF , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
TreeCmp.Plot( Bay_MC , metric, probs=c(95, 50), col=palette()[3], lines=TRUE, add=TRUE, shift=0.2, ylim=ylim, save.details=FALSE)
#legend(1, 0.4, c("Missing living", "Missing Fossil"), col=palette()[1:2], pch=19)

par(op)


#Checking for difference

#Which?
par<-par_MC

#Setting parameters
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)

#Distribution
TreeCmp.distribution(ML_best, "Triples")
TreeCmp.distribution(ML_best, "R.F_Cluster")
TreeCmp.distribution(ML_best, "RFL")
TreeCmp.distribution(Bay_con, "Triples")
TreeCmp.distribution(Bay_con, "R.F_Cluster")
TreeCmp.distribution(Bay_con, "RFL")

#Difference
TreeCmp.anova(ML_best, "R.F_Cluster", plot=TRUE, LaTeX=FALSE)
TreeCmp.anova(ML_best, "Triples", plot=TRUE, LaTeX=FALSE)
TreeCmp.anova(ML_best, "RFL", plot=TRUE, LaTeX=FALSE)
TreeCmp.anova(Bay_con, "R.F_Cluster", plot=TRUE, LaTeX=FALSE)
TreeCmp.anova(Bay_con, "Triples", plot=TRUE, LaTeX=FALSE)
TreeCmp.anova(Bay_con, "RFL", plot=TRUE, LaTeX=FALSE)



#Pairplot 
par<-par_MLMFMC

#Setting parameters
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)

#Distribution
TreeCmp.distribution(ML_best, "Triples")
TreeCmp.distribution(ML_best, "R.F_Cluster")
TreeCmp.distribution(Bay_con, "Triples")
TreeCmp.distribution(Bay_con, "R.F_Cluster")

test<-TreeCmp.anova(ML_best, "Triples", plot=TRUE)
TreeCmp.pairPlot(test$posthoc, parametric=FALSE)

test<-TreeCmp.anova(ML_best, "R.F_Cluster", plot=TRUE)
TreeCmp.pairPlot(test$posthoc, parametric=FALSE)

test<-TreeCmp.anova(ML_best, "RFL", plot=TRUE)
TreeCmp.pairPlot(test$posthoc, parametric=FALSE)

test<-TreeCmp.anova(Bay_con, "Triples", plot=TRUE)
TreeCmp.pairPlot(test$posthoc, parametric=FALSE)

test<-TreeCmp.anova(Bay_con, "R.F_Cluster", plot=TRUE)
TreeCmp.pairPlot(test$posthoc, parametric=FALSE)

test<-TreeCmp.anova(Bay_con, "RFL", plot=TRUE)
TreeCmp.pairPlot(test$posthoc, parametric=FALSE)