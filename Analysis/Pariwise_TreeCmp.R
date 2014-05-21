#Script for testing the Random Pairwise Bayesian Tree Comparisons (RPBTC)

#Loading the functions
source('../Functions/TreeComparisons/NTS.R')
source('../Functions/TreeComparisons/TreeCmp.Plot.R')
source('../Functions/TreeComparisons/TreeCmp.Read.R')

#Loading the Random tree comparisons
Random51<-read.table("../Data/Tree_Comparisons/Random_trees/51t_Random.Cmp",header=TRUE)
Random26<-read.table("../Data/Tree_Comparisons/Random_trees/26t_Random.Cmp",header=TRUE)
Random25<-read.table("../Data/Tree_Comparisons/Random_trees/25t_Random.Cmp",header=TRUE)

#Loading the treesets comparisons
#Low score comparisons
cd("../Data/Tree_Comparisons/RPBTC_testing/Low_score_treesets_100/")
tmp<-TreeCmp.Read('LowScore', verbose=TRUE)
LowScore<-NTS(tmp, Random51)
cd('../../../../Analysis/')
#Medium score comparisons
cd("../Data/Tree_Comparisons/RPBTC_testing/Medium_score_treesets_100/")
tmp<-TreeCmp.Read('MediumScore', verbose=TRUE)
MediumScore<-NTS(tmp, Random51)
cd('../../../../Analysis/')
#High score comparisons
cd("../Data/Tree_Comparisons/RPBTC_testing/High_score_treesets_100/")
tmp<-TreeCmp.Read('HighScore', verbose=TRUE)
HighScore<-NTS(tmp, Random26)
cd('../../../../Analysis/')

#Storing each NTS score in a data.frame object
#RF score (NTS)
LowScore.RF<-NULL
for (replicate in 1:100){
    LowScore.RF[[replicate]]<-LowScore[[replicate]][[4]]
}
LowScore.RF<-as.data.frame(LowScore.RF)
names(LowScore.RF)<-seq(1:100)

#Triplets score (NTS)
LowScore.Tr<-NULL
for (replicate in 1:100){
    LowScore.Tr[[replicate]]<-LowScore[[replicate]][[6]]
}
LowScore.Tr<-as.data.frame(LowScore.Tr)
names(LowScore.Tr)<-seq(1:100)

#RF score (NTS)
MediumScore.RF<-NULL
for (replicate in 1:100){
    MediumScore.RF[[replicate]]<-MediumScore[[replicate]][[4]]
}
MediumScore.RF<-as.data.frame(MediumScore.RF)
names(MediumScore.RF)<-seq(1:100)

#Triplets score (NTS)
MediumScore.Tr<-NULL
for (replicate in 1:100){
    MediumScore.Tr[[replicate]]<-MediumScore[[replicate]][[6]]
}
MediumScore.Tr<-as.data.frame(MediumScore.Tr)
names(MediumScore.Tr)<-seq(1:100)

#RF score (NTS)
HighScore.RF<-NULL
for (replicate in 1:100){
    HighScore.RF[[replicate]]<-HighScore[[replicate]][[4]]
}
HighScore.RF<-as.data.frame(HighScore.RF)
names(HighScore.RF)<-seq(1:100)

#Triplets score (NTS)
HighScore.Tr<-NULL
for (replicate in 1:100){
    HighScore.Tr[[replicate]]<-HighScore[[replicate]][[6]]
}
HighScore.Tr<-as.data.frame(HighScore.Tr)
names(HighScore.Tr)<-seq(1:100)


#Visual representation of the results
boxplot(LowScore.RF)
boxplot(LowScore.Tr)
boxplot(MediumScore.RF)
boxplot(MediumScore.Tr)
boxplot(HighScore.RF)
boxplot(HighScore.Tr)

#Checking for difference
#Creating the vectors
factors<-NULL
for (replicate in 1:100){
    factors<-c(factors, rep(replicate,1000))
}

scores.low.RF<-NULL
for (replicate in 1:100){
    scores.low.RF<-c(scores.low.RF, LowScore.RF[[replicate]])
}

scores.low.Tr<-NULL
for (replicate in 1:100){
    scores.low.Tr<-c(scores.low.Tr, LowScore.Tr[[replicate]])
}

scores.medium.RF<-NULL
for (replicate in 1:100){
    scores.medium.RF<-c(scores.medium.RF, MediumScore.RF[[replicate]])
}

scores.medium.Tr<-NULL
for (replicate in 1:100){
    scores.medium.Tr<-c(scores.medium.Tr, MediumScore.Tr[[replicate]])
}

scores.high.RF<-NULL
for (replicate in 1:100){
    scores.high.RF<-c(scores.high.RF, HighScore.RF[[replicate]])
}

scores.high.Tr<-NULL
for (replicate in 1:100){
    scores.high.Tr<-c(scores.high.Tr, HighScore.Tr[[replicate]])
}

#models
mod.low.RF<-lm(scores.low.RF ~ factors)
mod.low.Tr<-lm(scores.low.Tr ~ factors)
mod.medium.RF<-lm(scores.medium.RF ~ factors)
mod.medium.Tr<-lm(scores.medium.Tr ~ factors)
mod.high.RF<-lm(scores.high.RF ~ factors)
mod.high.Tr<-lm(scores.high.Tr ~ factors)

#anova
anova(mod.low.RF)
anova(mod.low.Tr)
anova(mod.medium.RF)
anova(mod.medium.Tr)
anova(mod.high.RF)
anova(mod.high.Tr)

#LaTeX table
library(xtable)

results<-data.frame("Tree Type"=c(rep("Low Score",2), rep("Medium Score",2), rep("High Score",2)), "Used metric"=c(rep(c("RF","Tr"),3)), "Replicates"=c(rep(100,6)),
    "Df"=c(anova(mod.low.RF)[[1]][1],anova(mod.low.Tr)[[1]][1],anova(mod.medium.RF)[[1]][1],anova(mod.medium.Tr)[[1]][1],anova(mod.high.RF)[[1]][1],anova(mod.high.Tr)[[1]][1]),
    "F value"=c(anova(mod.low.RF)[[4]][1],anova(mod.low.Tr)[[4]][1],anova(mod.medium.RF)[[4]][1],anova(mod.medium.Tr)[[4]][1],anova(mod.high.RF)[[4]][1],anova(mod.high.Tr)[[4]][1]),
    "p value"=c(anova(mod.low.RF)[[5]][1],anova(mod.low.Tr)[[5]][1],anova(mod.medium.RF)[[5]][1],anova(mod.medium.Tr)[[5]][1],anova(mod.high.RF)[[5]][1],anova(mod.high.Tr)[[5]][1])
    )
xtable(results)
