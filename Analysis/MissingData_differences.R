#Measuring the differences between methods/parameters

setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')

#Loading the functions
source("MissingData_fun.R")

#Loading the data
quick.load=TRUE
if(quick.load == FALSE) {
    source("MissingData_load.R") 
} else {
    #Quick load
    load("../Data/R_data/TreeCmp-ML_bestrees.Rda")
    load("../Data/R_data/TreeCmp-ML_bootstraps.Rda")
    load("../Data/R_data/TreeCmp-Bayesian_contrees.Rda")
    load("../Data/R_data/TreeCmp-Bayesian_treesets.Rda")

    #Isolating the parameters per chains
    par_ML<-c(1,26,51,76,101)
    par_MF<-c(1,6,11,16,21)
    par_MC<-c(1:5)
    par_MLMF<-c(1,6,11,16,21, 26,31,36,41,46, 51,56,61,66,71, 76,81,86,91,96, 101,106,111,116,121)
    par_MLMC<-c(1:5, 26:30, 51:55, 76:80, 101:105)
    par_MFMC<-c(1:25)
    par_MLMFMC<-c(1:125)
}

##Checking for difference

#Distribution (just visual)
data.sets<-c("ML_besttrees","Bayesian_contrees","ML_bootstraps","Bayesian_treesets")
metrics<-c("R.F_Cluster","Triples")
i=1 ; j=1
TreeCmp.distribution(sub.data(get(data.sets[i]), par_ML), metrics[j])

#Difference
parameter<-par_MLMFMC
metric<-1
data<-1
tmp<-TreeCmp.anova(sub.data(get(data.sets[data]), parameter), metrics[metric], plot=TRUE)
TreeCmp.pairPlot(tmp$posthoc, parametric=FALSE)


tmp<-TreeCmp.anova(sub.data(get(data.sets[data]), parameter), metrics[metric], plot=TRUE)

metric=1
data=4
parameter=par_MLMFMC
tmp<-TreeCmp.anova(sub.data(get(data.sets[data]), parameter), metrics[metric], plot=TRUE)

TreeCmp.pairPlot(tmp$posthoc, parametric=FALSE, binary=FALSE, col=c("blue", "red"), col.grad=c("white", "black"))
