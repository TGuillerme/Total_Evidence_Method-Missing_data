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
cd("../Data/Tree_Comparisons/RBTC_testing/Low_score_treesets_100/")
tmp<-TreeCmp.Read('LowScore', verbose=TRUE)
LowScore<-NTS(tmp, Random51)
cd('../../../../../')
#Medium score comparisons
cd("../Data/Tree_Comparisons/RBTC_testing/Medium_score_treesets_100/")
tmp<-TreeCmp.Read('MediumScore', verbose=TRUE)
MediumScore<-NTS(tmp, Random51)
cd('../../../../../')
#High score comparisons
cd("../Data/Tree_Comparisons/RBTC_testing/High_score_treesets_100/")
tmp<-TreeCmp.Read('HighScore', verbose=TRUE)
HighScore<-NTS(tmp, Random26)
cd('../../../../../')

#Storing each NTS score in a data.frame object
#RF score (NTS)
LowScore.RF<-NULL
for (replicate in 1:100){
    LowScore.RF[[replicate]]<-LowScore[[i]][[4]]
}
LowScore.RF<-as.data.frame(LowScore.RF)
names(LowScore.RF)<-seq(1:100)

#Triplets score (NTS)
LowScore.Tr<-NULL
for (replicate in 1:100){
    LowScore.Tr[[replicate]]<-LowScore[[i]][[6]]
}
LowScore.Tr<-as.data.frame(LowScore.Tr)
names(LowScore.Tr)<-seq(1:100)

#RF score (NTS)
MediumScore.RF<-NULL
for (replicate in 1:100){
    MediumScore.RF[[replicate]]<-MediumScore[[i]][[4]]
}
MediumScore.RF<-as.data.frame(MediumScore.RF)
names(MediumScore.RF)<-seq(1:100)

#Triplets score (NTS)
MediumScore.Tr<-NULL
for (replicate in 1:100){
    MediumScore.Tr[[replicate]]<-MediumScore[[i]][[6]]
}
MediumScore.Tr<-as.data.frame(MediumScore.Tr)
names(MediumScore.Tr)<-seq(1:100)

#RF score (NTS)
HighScore.RF<-NULL
for (replicate in 1:100){
    HighScore.RF[[replicate]]<-HighScore[[i]][[4]]
}
HighScore.RF<-as.data.frame(HighScore.RF)
names(HighScore.RF)<-seq(1:100)

#Triplets score (NTS)
HighScore.Tr<-NULL
for (replicate in 1:100){
    HighScore.Tr[[replicate]]<-HighScore[[i]][[6]]
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
    scores.medium.Tr<-c(medium.low.Tr, MediumScore.Tr[[replicate]])
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
mod.low.RF<-lm(scores.low.RF, factors)
mod.low.Tr<-lm(scores.low.Tr, factors)
mod.medium.RF<-lm(scores.medium.RF, factors)
mod.medium.Tr<-lm(scores.medium.Tr, factors)
mod.high.RF<-lm(scores.high.RF, factors)
mod.high.Tr<-lm(scores.high.Tr, factors)

#anova
anova(mod.low.RF)
anova(mod.low.Tr)
anova(mod.medium.RF)
anova(mod.medium.Tr)
anova(mod.high.RF)
anova(mod.high.Tr)