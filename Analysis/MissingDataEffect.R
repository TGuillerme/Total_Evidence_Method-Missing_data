#Script for testing the effect of missing data on tree topology.
#setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')


#Loading the functions
source('../Functions/TreeComparisons/NTS.R')
source('../Functions/TreeComparisons/TreeCmp.Plot.R')
source('../Functions/TreeComparisons/TreeCmp.Read.R')
source('../Functions/TreeComparisons/TreeCmp.Mode.R')
source('../Functions/TreeComparisons/TreeCmp.anova.R')
source('../Functions/TreeComparisons/TreeCmp.distribution.R')
source('../Functions/TreeComparisons/TreeCmp.pairPlot.R')
source('../Functions/TreeComparisons/as.TreeCmp.R')


#Loading the Random tree comparisons
Random51<-read.table("../Data/Tree_Comparisons/Random_trees/51t_Random.Cmp",header=TRUE)
Random26<-read.table("../Data/Tree_Comparisons/Random_trees/26t_Random.Cmp",header=TRUE)
Random25<-read.table("../Data/Tree_Comparisons/Random_trees/25t_Random.Cmp",header=TRUE)


#Loading the treesets
#/TreeCmp_chains/

#ML chains
setwd("../Data/Tree_Comparisons/TreeCmp_chains/ML/")
tmp<-TreeCmp.Read('MChain', verbose=TRUE)
ML_trees<-NTS(tmp, Random51)
setwd('../../../../Analysis/')

#Isolating the ML treesets
ML.ML<-ML_trees[c(1,26,51,76,101)]
class(ML.ML)<-class(ML_trees)

ML.MF<-ML_trees[c(1,6,11,16,21)]
class(ML.MF)<-class(ML_trees)

ML.MC<-ML_trees[1:5]
class(ML.MC)<-class(ML_trees)

ML.MLMF<-ML_trees[c(1,6,11,16,21, 26,31,36,41,46, 51,56,61,66,71, 76,81,86,91,96, 101,106,111,116,121)]
class(ML.MLMF)<-class(ML_trees)

ML.MLMC<-ML_trees[c(1:5, 26:30, 51:55, 76:80, 101:105)]
class(ML.MLMC)<-class(ML_trees)

ML.MFMC<-ML_trees[c(1:25)]
class(ML.MFMC)<-class(ML_trees)

ML.MLMFMC<-ML_trees
class(ML.MLMFMC)<-class(ML_trees)


#Bayesian run difference


#Bayesian chains
setwd("../Data/Tree_Comparisons/TreeCmp_chains/Bayesian/")
tmp<-TreeCmp.Read('MChain', verbose=TRUE)
Bayesian_trees<-NTS(tmp, Random51)
setwd('../../../../Analysis/')

#Isolating the Bayesian treesets + summarize each RPBTC by the mode  
Bayesian.ML<-Bayesian_trees[c(1,26,51,76,101)]
class(Bayesian.ML)<-class(Bayesian_trees)
#Bayesian.ML<-TreeCmp.Mode(Bayesian.ML, 1000, verbose=TRUE)

Bayesian.MF<-Bayesian_trees[c(1,6,11,16,21)]
class(Bayesian.MF)<-class(Bayesian_trees)
#Bayesian.MF<-TreeCmp.Mode(Bayesian.MF, 1000, verbose=TRUE)

Bayesian.MC<-Bayesian_trees[1:5]
class(Bayesian.MC)<-class(Bayesian_trees)
#Bayesian.MC<-TreeCmp.Mode(Bayesian.MC, 1000, verbose=TRUE)

Bayesian.MLMF<-Bayesian_trees[c(1,6,11,16,21, 26,31,36,41,46, 51,56,61,66,71, 76,81,86,91,96, 101,106,111,116,121)]
class(Bayesian.MLMF)<-class(Bayesian_trees)
#Bayesian.MLMF<-TreeCmp.Mode(Bayesian.MLMF, 1000, verbose=TRUE)

Bayesian.MLMC<-Bayesian_trees[c(1:5, 26:30, 51:55, 76:80, 101:105)]
class(Bayesian.MLMC)<-class(Bayesian_trees)
#Bayesian.MLMC<-TreeCmp.Mode(Bayesian.MLMC, 1000, verbose=TRUE)

Bayesian.MFMC<-Bayesian_trees[c(1:25)]
class(Bayesian.MFMC)<-class(Bayesian_trees)
#Bayesian.MFMC<-TreeCmp.Mode(Bayesian.MFMC, 1000, verbose=TRUE)

Bayesian.MLMFMC<-Bayesian_trees
class(Bayesian.MLMFMC)<-class(Bayesian_trees)
#Bayesian.MLMFMC<-TreeCmp.Mode(Bayesian.MLMFMC, 1000, verbose=TRUE)



#Plots

#Setting the metric
metric="R.F_Cluster"
metric="Triples"
#colour figures palette("default")
#BW figures  
palette(c("black", "gray50"))
#fix ylim
ylim=c(0,1)

#MLiving
TreeCmp.Plot( Bayesian.ML , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim)
TreeCmp.Plot( ML.ML, metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
legend( 0.5 , 0.8 , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( 0.5 , 0.7 , c("Mode", "50% CI", "95% CI"), col="gray80", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("gray80"), cex=0.8)

#MFossil
TreeCmp.Plot( Bayesian.MF , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim)
TreeCmp.Plot( ML.MF , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
legend( 0.5 , 0.8 , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( 0.5 , 0.7 , c("Mode", "50% CI", "95% CI"), col="gray80", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("gray80"), cex=0.8)

#MCharacter
TreeCmp.Plot( Bayesian.MC , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim)
TreeCmp.Plot( ML.MC , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
legend( 0.5 , 0.8 , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( 0.5 , 0.7 , c("Mode", "50% CI", "95% CI"), col="gray80", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("gray80"), cex=0.8)

#Mliving:MFossil
TreeCmp.Plot( Bayesian.MLMF , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim)
TreeCmp.Plot( ML.MLMF , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
legend( 20 , 1 , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( 20 , 0.9 , c("Mode", "50% CI", "95% CI"), col="gray80", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("gray80"), cex=0.8)

#Mliving:MCharacter
TreeCmp.Plot( Bayesian.MLMC , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim)
TreeCmp.Plot( ML.MLMC , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
legend( 20 , 1 , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( 20 , 0.9 , c("Mode", "50% CI", "95% CI"), col="gray80", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("gray80"), cex=0.8)

#MFossil:MCharacter
TreeCmp.Plot( Bayesian.MFMC , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim)
TreeCmp.Plot( ML.MFMC , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
legend( 20 , 1 , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( 20 , 0.9 , c("Mode", "50% CI", "95% CI"), col="gray80", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("gray80"), cex=0.8)

#MLiving:MFossil:MCharcacter
TreeCmp.Plot( Bayesian.MLMFMC , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim)
TreeCmp.Plot( ML.MLMFMC , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
legend( 100 , 1 , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( 100 , 0.9 , c("Mode", "50% CI", "95% CI"), col="gray80", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("gray80"), cex=0.8)


#Publication style plot
par(mfrow=c(2,3))
palette(c("black", "gray50"))
ylim=c(0,1)
metric="Triples"
TreeCmp.Plot( Bayesian.ML , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim)
TreeCmp.Plot( ML.ML, metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
legend( 0.5 , 0.8 , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( 0.5 , 0.7 , c("Mode", "50% CI", "95% CI"), col="gray80", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("gray80"), cex=0.8)
TreeCmp.Plot( Bayesian.MF , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim)
TreeCmp.Plot( ML.MF , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
TreeCmp.Plot( Bayesian.MC , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim)
TreeCmp.Plot( ML.MC , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
metric="R.F_Cluster"
TreeCmp.Plot( Bayesian.ML , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim)
TreeCmp.Plot( ML.ML, metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
TreeCmp.Plot( Bayesian.MF , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim)
TreeCmp.Plot( ML.MF , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
TreeCmp.Plot( Bayesian.MC , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim)
TreeCmp.Plot( ML.MC , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)



#Checking for difference - ML
#MLiving
#Distribution check (visual)

TreeCmp.distribution(ML.ML, "Triples")
TreeCmp.anova(ML.ML, "R.F_Cluster", plot=TRUE, LaTeX=TRUE) ; TreeCmp.xtables$posthoc
TreeCmp.anova(ML.ML, "Triples", plot=TRUE, LaTeX=TRUE) ; TreeCmp.xtables$posthoc
#MFossil
TreeCmp.distribution(ML.MF, "Triples")
TreeCmp.anova(ML.MF, "R.F_Cluster", plot=TRUE, LaTeX=TRUE) ; TreeCmp.xtables$posthoc
TreeCmp.anova(ML.MF, "Triples", plot=TRUE, LaTeX=TRUE) ; TreeCmp.xtables$posthoc
#MCharacter
TreeCmp.distribution(ML.MC, "Triples")
TreeCmp.anova(ML.MC, "R.F_Cluster", plot=TRUE, LaTeX=TRUE) ; TreeCmp.xtables$posthoc
TreeCmp.anova(ML.MC, "Triples", plot=TRUE, LaTeX=TRUE) ; TreeCmp.xtables$posthoc
#MLiving:MFossil
TreeCmp.distribution(ML.MLMF, "Triples")
TreeCmp.anova(ML.MLMF, "R.F_Cluster", plot=TRUE)
TreeCmp.anova(ML.MLMF, "Triples", plot=TRUE)
#MLiving:MCharacter
TreeCmp.distribution(ML.MLMC, "Triples")
TreeCmp.anova(ML.MLMC, "R.F_Cluster", plot=TRUE)
TreeCmp.anova(ML.MLMC, "Triples", plot=TRUE)
#MFossil:MCharacter
TreeCmp.distribution(ML.MFMC, "Triples")
TreeCmp.anova(ML.MFMC, "R.F_Cluster", plot=TRUE)
TreeCmp.anova(ML.MFMC, "Triples", plot=TRUE)
#MLiving:MFossil:MCharcacter
TreeCmp.distribution(ML.MLMFMC, "Triples")
test.RF<-TreeCmp.anova(ML.MLMFMC, "R.F_Cluster", plot=TRUE)
test.Tr<-TreeCmp.anova(ML.MLMFMC, "Triples", plot=TRUE)
TreeCmp.pairPlot(test.RF$posthoc, parametric=FALSE)
TreeCmp.pairPlot(test.Tr$posthoc, parametric=FALSE)


#Checking for differences - Bayesian
#MLiving
TreeCmp.anova(Bayesian.ML, "R.F_Cluster", plot=TRUE, LaTeX=TRUE) ;  TreeCmp.xtables$posthoc #Diff
TreeCmp.anova(Bayesian.ML, "Triples", plot=TRUE, LaTeX=TRUE) ; TreeCmp.xtable #No diff
#MFossil
TreeCmp.anova(Bayesian.MF, "R.F_Cluster", plot=TRUE, LaTeX=TRUE) ;  TreeCmp.xtables$posthoc #Diff
TreeCmp.anova(Bayesian.MF, "Triples", plot=TRUE, LaTeX=TRUE) ; TreeCmp.xtable #No diff
#MCharacter
TreeCmp.anova(Bayesian.MC, "R.F_Cluster", plot=TRUE, LaTeX=TRUE) ;  TreeCmp.xtables$posthoc #Diff
TreeCmp.anova(Bayesian.MC, "Triples", plot=TRUE, LaTeX=TRUE) ; TreeCmp.xtable #No diff
#MLiving:MFossil
test<-TreeCmp.anova(Bayesian.MLMF, "R.F_Cluster") #Diff
TreeCmp.pairPlot(test$posthoc, parametric=FALSE)
TreeCmp.anova(Bayesian.MLMF, "Triples") #No diff
#MLiving:MCharacter
test<-TreeCmp.anova(Bayesian.MLMC, "R.F_Cluster") #Diff
TreeCmp.pairPlot(test$posthoc, parametric=FALSE)
TreeCmp.anova(Bayesian.MLMC, "Triples") #No diff
#MFossil:MCharacter
test<-TreeCmp.anova(Bayesian.MFMC, "R.F_Cluster") #Diff
TreeCmp.pairPlot(test$posthoc, parametric=FALSE)
TreeCmp.anova(Bayesian.MFMC, "Triples") #No diff
#MLiving:MFossil:MCharcacter
test<-TreeCmp.anova(Bayesian.MLMFMC, "R.F_Cluster") #Diff

#Distribution (visual)
TreeCmp.distribution(Bayesian.MLMFMC, "R.F_Cluster")
#Heat map
TreeCmp.pairPlot(test$posthoc, parametric=FALSE)

TreeCmp.anova(Bayesian.MLMFMC, "Triples") #No diff
