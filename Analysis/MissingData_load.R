#Data loading for Total Evidence Missing Data Analysis
setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')


#######################
#Loading the functions
#######################
source("MissingData_fun.R")

#Loading the Random tree comparisons
Random51<-read.table("../Data/Tree_Comparisons/RandomTrees/51t_Random.Cmp",header=TRUE)
Random51<-Random51[,-7]
Random26<-read.table("../Data/Tree_Comparisons/RandomTrees/26t_Random.Cmp",header=TRUE)
Random26<-Random26[,-7]
Random25<-read.table("../Data/Tree_Comparisons/RandomTrees/25t_Random.Cmp",header=TRUE)
Random25<-Random25[,-7]

#######################
#Loading the treesets
#######################

#ML chains

#Best trees
setwd("../Data/Tree_Comparisons/ML/besttree")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
ML_besttrees<-NTS(tmp, Random51)
setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')
save(ML_besttrees, file="../Data/R_data/TreeCmp-ML_bestrees.Rda")

#Bootstraps
setwd("../Data/Tree_Comparisons/ML/bootstraps")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
ML_bootstraps<-NTS(tmp, Random51)
setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')
save(ML_bootstraps, file="../Data/R_data/TreeCmp-ML_bootstraps.Rda")

#Bayesian chains

#Consensus
setwd("../Data/Tree_Comparisons/Bayesian/consensus")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
Bayesian_contrees<-NTS(tmp, Random51)
setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')
save(Bayesian_contrees, file="../Data/R_data/TreeCmp-Bayesian_contrees.Rda")

#Treesets
setwd("../Data/Tree_Comparisons/Bayesian/treesets")
tmp<-TreeCmp.Read('Chain', verbose=TRUE)
Bayesian_treesets<-NTS(tmp, Random51)
setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')
save(Bayesian_treesets, file="../Data/R_data/TreeCmp-Bayesian_treesets.Rda")

#Isolating the parameters per chains
par_ML<-c(1,26,51,76,101)
par_MF<-c(1,6,11,16,21)
par_MC<-c(1:5)
par_MLMF<-c(1,6,11,16,21, 26,31,36,41,46, 51,56,61,66,71, 76,81,86,91,96, 101,106,111,116,121)
par_MLMC<-c(1:5, 26:30, 51:55, 76:80, 101:105)
par_MFMC<-c(1:25)
par_MLMFMC<-c(1:125)

cat("Four different datasets have been loaded:\n
    ML_besttrees
    ML_bootstraps
    Bayesian_contrees
    Bayesian_treesets\n
And 7 parameters combination sets:\n
    par_ML ; par_MF ; par_MC ;
    par_MLMF ; par_MLMC ; par_MFMC ;
    par_MLMFMC ;")