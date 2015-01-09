#Plotting the results of the Total Evidence Missing Data Analysis

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

#Storing the sub data sets
library(hdrcde)
data.sets<-c("ML_besttrees","Bayesian_contrees","ML_bootstraps","Bayesian_treesets")
metrics<-c("R.F_Cluster","Triples")
par<-par_MF
boot.RF<-sub.data(get(data.sets[3]), par, metric=metrics[1])
boot.Tr<-sub.data(get(data.sets[3]), par, metric=metrics[2])
bayt.RF<-sub.data(get(data.sets[4]), par, metric=metrics[1])
bayt.Tr<-sub.data(get(data.sets[4]), par, metric=metrics[2])
ML.RF<-sub.data(get(data.sets[1]), par, metric=metrics[1])
ML.Tr<-sub.data(get(data.sets[1]), par, metric=metrics[2])
Bay.RF<-sub.data(get(data.sets[2]), par, metric=metrics[1])
Bay.Tr<-sub.data(get(data.sets[2]), par, metric=metrics[2])

#Calculating the hdr
ML.RF.hdr<-lapply(ML.RF[-1], hdr)
ML.Tr.hdr<-lapply(ML.Tr[-1], hdr)
Bay.RF.hdr<-lapply(Bay.RF[-1], hdr)
Bay.Tr.hdr<-lapply(Bay.Tr[-1], hdr)
boot.RF.hdr<-lapply(boot.RF, hdr)
boot.Tr.hdr<-lapply(boot.Tr, hdr)
bayt.RF.hdr<-lapply(bayt.RF, hdr)
bayt.Tr.hdr<-lapply(bayt.Tr, hdr)

#Extracting the modes
mode.ML.RF<-vector()
for(i in 1:(length(par)-1)) {mode.ML.RF[[i]]<-ML.RF.hdr[[i]]$mode}
mode.ML.Tr<-vector()
for(i in 1:(length(par)-1)) {mode.ML.Tr[[i]]<-ML.Tr.hdr[[i]]$mode}
mode.Bay.RF<-vector()
for(i in 1:(length(par)-1)) {mode.Bay.RF[[i]]<-Bay.RF.hdr[[i]]$mode}
mode.Bay.Tr<-vector()
for(i in 1:(length(par)-1)) {mode.Bay.Tr[[i]]<-Bay.Tr.hdr[[i]]$mode}
mode.boot.RF<-vector()
for(i in 1:length(par)) {mode.boot.RF[[i]]<-boot.RF.hdr[[i]]$mode}
mode.boot.Tr<-vector()
for(i in 1:length(par)) {mode.boot.Tr[[i]]<-boot.Tr.hdr[[i]]$mode}
mode.bayt.RF<-vector()
for(i in 1:length(par)) {mode.bayt.RF[[i]]<-bayt.RF.hdr[[i]]$mode}
mode.bayt.Tr<-vector()
for(i in 1:length(par)) {mode.bayt.Tr[[i]]<-bayt.Tr.hdr[[i]]$mode}

#Creating the mode table
table.tmp<-data.frame("Maximum likelihood-RF"=as.vector(summary(mode.ML.RF)), "Maximumlikelihood-Tr"=as.vector(summary(mode.ML.Tr)),
                       "Bayesian consensus-RF"=as.vector(summary(mode.Bay.RF)), "Bayesian consensus-Tr"=as.vector(summary(mode.Bay.Tr)),
                       "Bootstraps-RF"=as.vector(summary(mode.boot.RF)), "Bootstraps-Tr"=as.vector(summary(mode.boot.Tr)),
                       "Bayesian posterior trees-RF"=as.vector(summary(mode.bayt.RF)), "Bayesian posterior trees-Tr"=as.vector(summary(mode.bayt.Tr)))

mode.table<-matrix(NA, ncol=6, nrow=8)
colnames(mode.table)<-names(summary(mode.ML.RF))
rownames(mode.table)<-c("Maximum likelihood-RF", "Maximumlikelihood-Tr","Bayesian consensus-RF", "Bayesian consensus-Tr","Bootstraps-RF", "Bootstraps-Tr","Bayesian posterior trees-RF", "Bayesian posterior trees-Tr")
for (row in 1:8) {
    mode.table[row,]<-table.tmp[,row]
}

#LaTeX
library(xtable)
xtable(mode.table)
