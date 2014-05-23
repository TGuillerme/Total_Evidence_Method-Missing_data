#Script for testing the effect of missing data on tree topology.

#Loading the functions
source('../Functions/TreeComparisons/NTS.R')
source('../Functions/TreeComparisons/TreeCmp.Plot.R')
source('../Functions/TreeComparisons/TreeCmp.Read.R')

#Loading the Random tree comparisons
Random51<-read.table("../Data/Tree_Comparisons/Random_trees/51t_Random.Cmp",header=TRUE)
Random26<-read.table("../Data/Tree_Comparisons/Random_trees/26t_Random.Cmp",header=TRUE)
Random25<-read.table("../Data/Tree_Comparisons/Random_trees/25t_Random.Cmp",header=TRUE)

#Loading the treesets
#/TreeCmp_chains/

#ML chains
#/ML/

#Bayesian chains
#/Bayesian/

#Plots

#Setting the metric
metric="R.F_Cluster"
#or "Triples"

#MLiving
TreeCmp.Plot( <chain.Bayesian> , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, add=FALSE, shift=0, save.details=FALSE)
TreeCmp.Plot( <chain.ML> , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, save.details=FALSE)
legend( <x> , <y> , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( <x> , <y> , c("Mode", "50% CI", "95% CI"), col="grey", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("grey"), cex=0.8)

#MFossil
TreeCmp.Plot( <chain.Bayesian> , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, add=FALSE, shift=0, save.details=FALSE)
TreeCmp.Plot( <chain.ML> , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, save.details=FALSE)
legend( <x> , <y> , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( <x> , <y> , c("Mode", "50% CI", "95% CI"), col="grey", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("grey"), cex=0.8)

#MCharacter
TreeCmp.Plot( <chain.Bayesian> , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, add=FALSE, shift=0, save.details=FALSE)
TreeCmp.Plot( <chain.ML> , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, save.details=FALSE)
legend( <x> , <y> , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( <x> , <y> , c("Mode", "50% CI", "95% CI"), col="grey", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("grey"), cex=0.8)

#Mliving:MFossil
TreeCmp.Plot( <chain.Bayesian> , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, add=FALSE, shift=0, save.details=FALSE)
TreeCmp.Plot( <chain.ML> , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, save.details=FALSE)
legend( <x> , <y> , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( <x> , <y> , c("Mode", "50% CI", "95% CI"), col="grey", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("grey"), cex=0.8)

#Mliving:MCharacter
TreeCmp.Plot( <chain.Bayesian> , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, add=FALSE, shift=0, save.details=FALSE)
TreeCmp.Plot( <chain.ML> , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, save.details=FALSE)
legend( <x> , <y> , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( <x> , <y> , c("Mode", "50% CI", "95% CI"), col="grey", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("grey"), cex=0.8)

#MFossil:MCharacter
TreeCmp.Plot( <chain.Bayesian> , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, add=FALSE, shift=0, save.details=FALSE)
TreeCmp.Plot( <chain.ML> , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, save.details=FALSE)
legend( <x> , <y> , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( <x> , <y> , c("Mode", "50% CI", "95% CI"), col="grey", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("grey"), cex=0.8)

#MLiving:MFossil:MCharcacter
TreeCmp.Plot( <chain.Bayesian> , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, add=FALSE, shift=0, save.details=FALSE)
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