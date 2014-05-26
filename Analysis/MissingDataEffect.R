#Script for testing the effect of missing data on tree topology.
#cd('../PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')


#Loading the functions
source('../Functions/TreeComparisons/NTS.R')
source('../Functions/TreeComparisons/TreeCmp.Plot.R')
source('../Functions/TreeComparisons/TreeCmp.Read.R')
source('../Functions/TreeComparisons/TreeCmp.Mode.R')


#Loading the Random tree comparisons
Random51<-read.table("../Data/Tree_Comparisons/Random_trees/51t_Random.Cmp",header=TRUE)
Random26<-read.table("../Data/Tree_Comparisons/Random_trees/26t_Random.Cmp",header=TRUE)
Random25<-read.table("../Data/Tree_Comparisons/Random_trees/25t_Random.Cmp",header=TRUE)

#Loading the treesets
#/TreeCmp_chains/

#ML chains
#/ML/
cd("../Data/Tree_Comparisons/TreeCmp_chains/ML/")
tmp<-TreeCmp.Read('MChain', verbose=TRUE)
ML_trees<-NTS(tmp, Random51)
cd('../../../../Analysis/')

#Bayesian chains
cd("../Data/Tree_Comparisons/TreeCmp_chains/Bayesian/")
tmp<-TreeCmp.Read('MChain', verbose=TRUE)
Bayesian_trees<-NTS(tmp, Random51)
cd('../../../../Analysis/')

#Isolating the Bayesian treesets + summarize each RPBTC by the mode  
Bayesian.ML<-Bayesian_trees[c(1,26,51,76,101)]
class(Bayesian.ML)<-class(Bayesian_trees)
Bayesian.ML<-TreeCmp.Mode(Bayesian.ML, 1000, verbose=TRUE)

Bayesian.MF<-Bayesian_trees[c(1,6,11,16,21)]
class(Bayesian.MF)<-class(Bayesian_trees)
Bayesian.MF<-TreeCmp.Mode(Bayesian.MF, 1000, verbose=TRUE)

Bayesian.MC<-Bayesian_trees[1:5]
class(Bayesian.MC)<-class(Bayesian_trees)
Bayesian.MC<-TreeCmp.Mode(Bayesian.MC, 1000, verbose=TRUE)

Bayesian.MLMF<-Bayesian_trees[c(1,6,11,16,21, 26,31,36,41,46, 51,56,61,66,71, 76,81,86,91,96, 101,106,111,116,121)]
class(Bayesian.MLMF)<-class(Bayesian_trees)
Bayesian.MLMF<-TreeCmp.Mode(Bayesian.MLMF, 1000, verbose=TRUE)

Bayesian.MLMC<-Bayesian_trees[c(1:5, 26:30, 51:55, 76:80, 101:105)]
class(Bayesian.MLMC)<-class(Bayesian_trees)
Bayesian.MLMC<-TreeCmp.Mode(Bayesian.MLMC, 1000, verbose=TRUE)

Bayesian.MFMC<-Bayesian_trees[c(1:25)]
class(Bayesian.MFMC)<-class(Bayesian_trees)
Bayesian.MFMC<-TreeCmp.Mode(Bayesian.MFMC, 1000, verbose=TRUE)

Bayesian.MLMFMC<-Bayesian_trees
class(Bayesian.MLMFMC)<-class(Bayesian_trees)
Bayesian.MLMFMC<-TreeCmp.Mode(Bayesian.MLMFMC, 1000, verbose=TRUE)


#Transforming into lists of 51 modes.



#Plots

#Setting the metric
metric="R.F_Cluster"
#or "Triples"

#MLiving
TreeCmp.Plot( Bayesian.ML , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, add=FALSE, shift=0, save.details=FALSE)
TreeCmp.Plot( <chain.ML> , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, save.details=FALSE)
legend( <x> , <y> , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( <x> , <y> , c("Mode", "50% CI", "95% CI"), col="grey", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("grey"), cex=0.8)

#MFossil
TreeCmp.Plot( Bayesian.MF , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, add=FALSE, shift=0, save.details=FALSE)
TreeCmp.Plot( <chain.ML> , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, save.details=FALSE)
legend( <x> , <y> , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( <x> , <y> , c("Mode", "50% CI", "95% CI"), col="grey", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("grey"), cex=0.8)

#MCharacter
TreeCmp.Plot( Bayesian.MC, metric, probs=c(95, 50), col=palette()[1], lines=TRUE, add=FALSE, shift=0, save.details=FALSE)
TreeCmp.Plot( <chain.ML> , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, save.details=FALSE)
legend( <x> , <y> , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( <x> , <y> , c("Mode", "50% CI", "95% CI"), col="grey", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("grey"), cex=0.8)

#Mliving:MFossil
TreeCmp.Plot( Bayesian.MLMF, metric, probs=c(95, 50), col=palette()[1], lines=TRUE, add=FALSE, shift=0, save.details=FALSE)
TreeCmp.Plot( <chain.ML> , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, save.details=FALSE)
legend( <x> , <y> , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( <x> , <y> , c("Mode", "50% CI", "95% CI"), col="grey", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("grey"), cex=0.8)

#Mliving:MCharacter
TreeCmp.Plot( Bayesian.MLMC, metric, probs=c(95, 50), col=palette()[1], lines=TRUE, add=FALSE, shift=0, save.details=FALSE)
TreeCmp.Plot( <chain.ML> , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, save.details=FALSE)
legend( <x> , <y> , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( <x> , <y> , c("Mode", "50% CI", "95% CI"), col="grey", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("grey"), cex=0.8)

#MFossil:MCharacter
TreeCmp.Plot( Bayesian.MFMC, metric, probs=c(95, 50), col=palette()[1], lines=TRUE, add=FALSE, shift=0, save.details=FALSE)
TreeCmp.Plot( <chain.ML> , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, save.details=FALSE)
legend( <x> , <y> , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( <x> , <y> , c("Mode", "50% CI", "95% CI"), col="grey", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("grey"), cex=0.8)

#MLiving:MFossil:MCharcacter
TreeCmp.Plot( Bayesian.MLMFMC, metric, probs=c(95, 50), col=palette()[1], lines=TRUE, add=FALSE, shift=0, save.details=FALSE)
TreeCmp.Plot( <chain.ML> , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, save.details=FALSE)
legend( <x> , <y> , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( <x> , <y> , c("Mode", "50% CI", "95% CI"), col="grey", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("grey"), cex=0.8)



#Checking for differences
#MLiving
#MFossil
#MCharacter
#MLiving:MFossil
#MLiving:MCharacter
#MFossil:MCharacter
#MLiving:MFossil:MCharcacter