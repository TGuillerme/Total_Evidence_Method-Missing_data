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


#Setting the variables
data.sets<-c("ML_besttrees","Bayesian_contrees","ML_bootstraps","Bayesian_treesets")
metrics<-c("R.F_Cluster","Triples")
par<-par_ML

#----------------
# Extracting the mode value for each tree
#----------------
missing_data_param<-c("0%","10%","25%","50%","75%")
#missing_data_param<-c(100,90,75,50,25) #For NC

#Only for each parameters individually
mar_dist<-matrix(NA, nrow=(4+1), ncol=(length(par)+1))
colnames(mar_dist)<-c(missing_data_param, "Marginal")
rownames(mar_dist)<-c("Maximum Likelihood","Bayesian consensus", "Maximum Likelihood Bootstrap", "Bayesian posterior distribution", "Marginal")

#Creating the matrices for RF and Tr
mar_dist_Tr<-mar_dist_RF<-mar_dist

#Get the mode in there!
mode.val<-function (x) {
    as.numeric(names(sort(-table(x))[1]))
}
for (method in 1:length(data.sets)) {
    #RF
    #tmp<-lapply(sub.data(get(data.sets[method]), par, metric=metrics[1]), hdr, prob=c(50,95))
    #mar_dist_RF[method,c(1:5)]<-runlist(unlist(tmp, recursive=FALSE)[c(2,5,8,11,14)])
    #Tr
    #tmp<-lapply(sub.data(get(data.sets[method]), par, metric=metrics[2]), hdr, prob=c(50,95))
    #mar_dist_Tr[method,c(1:5)]<-runlist(unlist(tmp, recursive=FALSE)[c(2,5,8,11,14)])
    mar_dist_RF[method,c(1:5)]<-round(unlist(lapply(sub.data(get(data.sets[method]), par, metric=metrics[1]), mode.val)), digit=2)
    mar_dist_Tr[method,c(1:5)]<-round(unlist(lapply(sub.data(get(data.sets[method]), par, metric=metrics[2]), mode.val)), digit=2)
}

#Saving the row values
raw_RF<-mar_dist_RF[c(1:4), c(1:5)]
raw_Tr<-mar_dist_Tr[c(1:4), c(1:5)]

#Shift the Tr values to be positive
#mar_dist_Tr<-mar_dist_Tr+abs(min(mar_dist_Tr, na.rm=TRUE))

#----------------
# Calculating the marignal distribution
#----------------
#sum of row
for (method in 1:length(data.sets)) {
    mar_dist_RF[method,6]<-sum(mar_dist_RF[method,c(1:5)])
    mar_dist_Tr[method,6]<-sum(mar_dist_Tr[method,c(1:5)])
}
#sum of column
for (param in 1:length(par)) {
    mar_dist_RF[5,param]<-sum(mar_dist_RF[c(1:4),param])
    mar_dist_Tr[5,param]<-sum(mar_dist_Tr[c(1:4),param])
}

library(xtable)
xtable(mar_dist_RF)
xtable(mar_dist_Tr)

#Calculate the probabilities
#mar_dist_RF[5,6]<-total_RF<-sum(mar_dist_RF[5,], na.rm=T)
#mar_dist_Tr[5,6]<-total_Tr<-sum(mar_dist_Tr[5,], na.rm=T)

#round(mar_dist_RF/total_RF, digit=2)
#round(mar_dist_Tr/total_Tr, digit=2)

#----------------
# Same but with the non-marginal values being the mode values
#----------------

#RF_tmp<-round(mar_dist_RF/total_RF, digit=2)
#RF_tmp[c(1:4), c(1:5)]<-raw_RF

#Tr_tmp<-round(mar_dist_Tr/total_Tr, digit=2)
#Tr_tmp[c(1:4), c(1:5)]<-raw_Tr