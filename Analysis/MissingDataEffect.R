#Script for testing the effect of missing data on tree topology.
#setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')

#Loading the functions
source('~/PhD/Projects/Total_Evidence_Method-Missing_data/Functions/TreeComparisons/NTS.R')
source('~/PhD/Projects/Total_Evidence_Method-Missing_data//Functions/TreeComparisons/TreeCmp.Plot.R')
source('~/PhD/Projects/Total_Evidence_Method-Missing_data//Functions/TreeComparisons/TreeCmp.Read.R')
source('~/PhD/Projects/Total_Evidence_Method-Missing_data//Functions/TreeComparisons/TreeCmp.Mode.R')
source('~/PhD/Projects/Total_Evidence_Method-Missing_data//Functions/TreeComparisons/TreeCmp.anova.R')
source('~/PhD/Projects/Total_Evidence_Method-Missing_data//Functions/TreeComparisons/TreeCmp.distribution.R')
source('~/PhD/Projects/Total_Evidence_Method-Missing_data//Functions/TreeComparisons/TreeCmp.pairPlot.R')
source('~/PhD/Projects/Total_Evidence_Method-Missing_data//Functions/TreeComparisons/as.TreeCmp.R')

#Loading the Random tree comparisons
Random51<-read.table("~/PhD/Projects/Total_Evidence_Method-Missing_data/Data/Tree_Comparisons/RandomTrees/51t_Random.Cmp",header=TRUE)
Random26<-read.table("~/PhD/Projects/Total_Evidence_Method-Missing_data/Data/Tree_Comparisons/RandomTrees/26t_Random.Cmp",header=TRUE)
Random25<-read.table("~/PhD/Projects/Total_Evidence_Method-Missing_data/Data/Tree_Comparisons/RandomTrees/25t_Random.Cmp",header=TRUE)

#Loading the treesets

#ML chains

#Best trees
setwd("~/PhD/Projects/Total_Evidence_Method-Missing_data/Data/Tree_Comparisons/ML/besttree")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
ML_besttrees<-NTS(tmp, Random51)
setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')

#Bootstraps
setwd("~/PhD/Projects/Total_Evidence_Method-Missing_data/Data/Tree_Comparisons/ML/bootstraps")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
ML_bootstraps<-NTS(tmp, Random51)
setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')

#Bayesian chains

#Consensus
setwd("~/PhD/Projects/Total_Evidence_Method-Missing_data/Data/Tree_Comparisons/Bayesian/consensus")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
Bayesian_contrees<-NTS(tmp, Random51)
setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')

#Treesets
setwd("~/PhD/Projects/Total_Evidence_Method-Missing_data/Data/Tree_Comparisons/Bayesian/treesets")
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
metric="R.F_Cluster"
#metric="Triples"
#colour figures palette("default")
#BW figures  
#palette(c("black", "gray50"))
#fix ylim
ylim=c(0,1)

#Parameters
par<-par_ML
main="Missing Living"
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)


#Pair plots
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_best , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
legend( 0.5 , 0.8 , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( 0.5 , 0.7 , c("Mode", "50% CI", "95% CI"), col="gray80", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("gray80"), cex=0.8)

TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_boot , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
legend( 0.5 , 0.8 , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( 0.5 , 0.7 , c("Mode", "50% CI", "95% CI"), col="gray80", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("gray80"), cex=0.8)


#Combined Plots
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_best , metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[3], lines=TRUE, add=TRUE, shift=0.2, ylim=ylim, save.details=FALSE)
TreeCmp.Plot( ML_boot , metric, probs=c(95, 50), col=palette()[4], lines=TRUE, add=TRUE, shift=0.3, ylim=ylim, save.details=FALSE)
legend( 0.5 , 0.95 , c("Consensus", "ML tree", "Bayesian trees", "Bootstraps"), pch=21, col=c(palette()[1:4]), pt.bg=c(palette()[1:4]), cex=0.8)
legend( 0.5 , 0.2 , c("Mode", "50% CI", "95% CI"), col="gray80", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("gray80"), cex=0.8)



#Publication style plot - single
par(mfrow=c(2,3))
palette(c("black", "gray50"))
ylim=c(0,1)
#Triples
metric="Triples"
#ML
par<-par_ML
main="Missing Living"
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_best, metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
legend( 0.5 , 0.8 , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( 0.5 , 0.7 , c("Mode", "50% CI", "95% CI"), col="gray80", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("gray80"), cex=0.8)
#MF
par<-par_MF
main="Missing Fossil"
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_best, metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
#MC
par<-par_MC
main="Missing Characters"
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_best, metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
#RF
metric="R.F_Cluster"
#ML
par<-par_ML
main="Missing Living"
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_best, metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
#MF
par<-par_MF
main="Missing Fossil"
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_best, metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
#MC
par<-par_MC
main="Missing Characters"
ML_best<-ML_besttrees[par] ; class(ML_best)<-class(ML_besttrees)
Bay_con<-Bayesian_contrees[par] ; class(Bay_con)<-class(Bayesian_contrees)
TreeCmp.Plot( Bay_con , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_best, metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)



#Publication style plot - treesets
par(mfrow=c(2,3))
palette(c("black", "gray50"))
ylim=c(0,1)
#Triples
metric="Triples"
#ML
par<-par_ML
main="Missing Living"
ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_boot, metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
legend( 0.5 , 0.8 , c("Bayesian", "ML"), pch=21, col=c(palette()[1:2]), pt.bg=c(palette()[1:2]), cex=0.8)
legend( 0.5 , 0.7 , c("Mode", "50% CI", "95% CI"), col="gray80", lty=c(NA, 1, 2), pch=c(21, NA, NA), pt.bg=c("gray80"), cex=0.8)
#MF
par<-par_MF
main="Missing Fossil"
ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_boot, metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
#MC
par<-par_MC
main="Missing Characters"
ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_boot, metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
#RF
metric="R.F_Cluster"
#ML
par<-par_ML
main="Missing Living"
ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_boot, metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
#MF
par<-par_MF
main="Missing Fossil"
ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_boot, metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)
#MC
par<-par_MC
main="Missing Characters"
ML_boot<-ML_bootstraps[par] ; class(ML_boot)<-class(ML_bootstraps)
Bay_set<-Bayesian_treesets[par] ; class(Bay_set)<-class(Bayesian_treesets)
TreeCmp.Plot( Bay_set , metric, probs=c(95, 50), col=palette()[1], lines=TRUE, ylim=ylim, main=main)
TreeCmp.Plot( ML_boot, metric, probs=c(95, 50), col=palette()[2], lines=TRUE, add=TRUE, shift=0.1, ylim=ylim, save.details=FALSE)























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
