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

#####################
#Plot main figures (individual parameters in RF and Triples)
#####################
#windows parameters
quartz(width = 8.3, height = 5.8) #A5 landscape
op<-par(mfrow=c(2,3), bty="l")
ylim=c(0,1)

#data parameters
data.sets<-c("ML_besttrees","Bayesian_contrees","ML_bootstraps","Bayesian_treesets")
metrics<-c("R.F_Cluster","Triples")

#2*3 plots
par(mar=c(1,5,5,0) + 0.1)
multi.TreeCmp.plot( data.sets , par_ML, metrics[1], col=palette(), las=2, probs=c(95, 50), ylim=ylim, xaxis=NULL, xlab=NULL, ylab="Robinson-Fould distance", las=2)
par(mar=c(1,3,5,2) + 0.1)
multi.TreeCmp.plot( data.sets , par_MF, metrics[1], col=palette(), las=2, probs=c(95, 50), ylim=ylim, xaxis=NULL, xlab=NULL, ylab=NULL, las=2)
par(mar=c(1,1,5,4) + 0.1)
multi.TreeCmp.plot( data.sets , par_MC, metrics[1], col=palette(), las=2, probs=c(95, 50), ylim=ylim, xaxis=NULL, xlab=NULL, ylab=NULL, las=2)

xaxis.labs<-c("0%", "10%", "25%", "50%", "75%")
par(mar=c(5,5,1,0) + 0.1)
multi.TreeCmp.plot( data.sets , par_ML, metrics[2], col=palette(), las=2, probs=c(95, 50), ylim=ylim, xaxis=xaxis.labs, ylab="Triplets distance", las=2, xlab="Missing living taxa") 
par(mar=c(5,3,1,2) + 0.1)
multi.TreeCmp.plot( data.sets , par_MF, metrics[2], col=palette(), las=2, probs=c(95, 50), ylim=ylim, xaxis=xaxis.labs, ylab=NULL, las=2, xlab="Missing data in the fossil record")
par(mar=c(5,2,1,4) + 0.1)
multi.TreeCmp.plot( data.sets , par_MC, metrics[2], col=palette(), las=2, probs=c(95, 50), ylim=ylim, xaxis=xaxis.labs, ylab=NULL, las=2, xlab="Missing characters") 

#Back to default
par(op)




data.sets<-c("ML_besttrees", "Bayesian_contrees")
metrics<-c("R.F_Cluster")
multi.TreeCmp.plot( data.sets , par_MLMFMC, metrics[1], col=palette(), las=2, probs=c(95, 50), ylim=ylim, xaxis=NULL, xlab=NULL, ylab="Robinson-Fould distance", las=2, shift=0.5)
