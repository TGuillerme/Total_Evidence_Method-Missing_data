#Script for testing the Random Pairwise Bayesian Tree Comparisons (RPBTC)
#setwd('../PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')

#Loading the functions
source('../Functions/TreeComparisons/NTS.R')
source('../Functions/TreeComparisons/TreeCmp.Plot.R')
source('../Functions/TreeComparisons/TreeCmp.Read.R')
source('../Functions/TreeComparisons/TreeCmp.anova.R')


#Loading the Random tree comparisons
Random51<-read.table("../Data/Tree_Comparisons/Random_trees/51t_Random.Cmp",header=TRUE)
Random26<-read.table("../Data/Tree_Comparisons/Random_trees/26t_Random.Cmp",header=TRUE)
Random25<-read.table("../Data/Tree_Comparisons/Random_trees/25t_Random.Cmp",header=TRUE)

#Loading the treesets comparisons
#Low score comparisons
setwd("../Data/Tree_Comparisons/RPBTC_testing/Low_score_treesets_100/")
tmp<-TreeCmp.Read('LowScore', verbose=TRUE)
LowScore<-NTS(tmp, Random51)
setwd('../../../../Analysis/')
#Medium score comparisons
setwd("../Data/Tree_Comparisons/RPBTC_testing/Medium_score_treesets_100/")
tmp<-TreeCmp.Read('MediumScore', verbose=TRUE)
MediumScore<-NTS(tmp, Random51)
setwd('../../../../Analysis/')
#High score comparisons
setwd("../Data/Tree_Comparisons/RPBTC_testing/High_score_treesets_100/")
tmp<-TreeCmp.Read('HighScore', verbose=TRUE)
HighScore<-NTS(tmp, Random26)
setwd('../../../../Analysis/')

#TreeCmp anova per metric and per score
LS.RF<-TreeCmp.anova(LowScore, "R.F_Cluster")
MS.RF<-TreeCmp.anova(MediumScore, "R.F_Cluster")
HS.RF<-TreeCmp.anova(HighScore, "R.F_Cluster")
LS.Tr<-TreeCmp.anova(LowScore, "Triples")
MS.Tr<-TreeCmp.anova(MediumScore, "Triples")
HS.Tr<-TreeCmp.anova(HighScore, "Triples")


#LaTeX table
library(xtable)

results<-data.frame("Tree Type"=c(rep("Low Score",2), rep("Medium Score",2), rep("High Score",2)), "Used metric"=c(rep(c("RF","Tr"),3)), "Replicates"=c(rep(100,6)),
    "Df"=c(LS.RF[[1]][[1]][1], LS.Tr[[1]][[1]][1], MS.RF[[1]][[1]][1], MS.Tr[[1]][[1]][1], HS.RF[[1]][[1]][1], HS.Tr[[1]][[1]][1]),
    "F value"=c(LS.RF[[1]][[4]][1], LS.Tr[[1]][[4]][1], MS.RF[[1]][[4]][1], MS.Tr[[1]][[4]][1], HS.RF[[1]][[4]][1], HS.Tr[[1]][[4]][1]),
    "p value"=c(LS.RF[[1]][[5]][1], LS.Tr[[1]][[5]][1], MS.RF[[1]][[5]][1], MS.Tr[[1]][[5]][1], HS.RF[[1]][[5]][1], HS.Tr[[1]][[5]][1])
    )
xtable(results)
