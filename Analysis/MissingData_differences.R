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

##################
#Checking for difference using the Bhattacharyya Coefficient 
##################

#Setting the variables
data.sets<-c("ML_besttrees","Bayesian_contrees","ML_bootstraps","Bayesian_treesets")
metrics<-c("R.F_Cluster","Triples")
parameter<-par_MLMFMC

#----------------
#Calculating the pairwise comparisons within (effect of the parameters)
#----------------

#pair.comp_within.MLbest.RF<-pair.bhatt.coeff(sub.data(get(data.sets[1]), par_MLMFMC, metric=metrics[1]), diag=TRUE)
#save(pair.comp_within.MLbest.RF, file="../Data/R_data/pair.comp_within.MLbest.RF.Rda")
load("../Data/R_data/pair.comp_within.MLbest.RF.Rda")
#pair.comp_within.MLbest.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[1]), par_MLMFMC, metric=metrics[2]), diag=TRUE)
#save(pair.comp_within.MLbest.Tr, file="../Data/R_data/pair.comp_within.MLbest.Tr.Rda")
load("../Data/R_data/pair.comp_within.MLbest.Tr.Rda")
#pair.comp_within.Baycon.RF<-pair.bhatt.coeff(sub.data(get(data.sets[2]), par_MLMFMC, metric=metrics[1]), diag=TRUE)
#save(pair.comp_within.Baycon.RF, file="../Data/R_data/pair.comp_within.Baycon.RF.Rda")
load("../Data/R_data/pair.comp_within.Baycon.RF.Rda")
#pair.comp_within.Baycon.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[2]), par_MLMFMC, metric=metrics[2]), diag=TRUE)
#save(pair.comp_within.Baycon.Tr, file="../Data/R_data/pair.comp_within.Baycon.Tr.Rda")
load("../Data/R_data/pair.comp_within.Baycon.Tr.Rda")
#pair.comp_within.MLboot.RF<-pair.bhatt.coeff(sub.data(get(data.sets[3]), par_MLMFMC, metric=metrics[1]), diag=TRUE)
#save(pair.comp_within.MLboot.RF, file="../Data/R_data/pair.comp_within.MLboot.RF.Rda")
load("../Data/R_data/pair.comp_within.MLboot.RF.Rda")
#pair.comp_within.MLboot.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[3]), par_MLMFMC, metric=metrics[2]), diag=TRUE)
#save(pair.comp_within.MLboot.Tr, file="../Data/R_data/pair.comp_within.MLboot.Tr.Rda")
load("../Data/R_data/pair.comp_within.MLboot.Tr.Rda")
#pair.comp_within.Baytre.RF<-pair.bhatt.coeff(sub.data(get(data.sets[4]), par_MLMFMC, metric=metrics[1]), diag=TRUE)
#save(pair.comp_within.Baytre.RF, file="../Data/R_data/pair.comp_within.Baytre.RF.Rda")
load("../Data/R_data/pair.comp_within.Baytre.RF.Rda")
#pair.comp_within.Baytre.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[4]), par_MLMFMC, metric=metrics[2]), diag=TRUE)
#save(pair.comp_within.Baytre.Tr, file="../Data/R_data/pair.comp_within.Baytre.Tr.Rda")
load("../Data/R_data/pair.comp_within.Baytre.Tr.Rda")

#Visualising the results
pairwise.comp_within<-c("pair.comp_within.MLbest.RF", "pair.comp_within.MLbest.Tr",
                        "pair.comp_within.Baycon.RF", "pair.comp_within.Baycon.Tr",
                        "pair.comp_within.MLboot.RF", "pair.comp_within.MLboot.Tr",
                        "pair.comp_within.Baytre.RF", "pair.comp_within.Baytre.Tr")
plot.bhatt.coeff(get(pairwise.comp_within[8]), col=c("red", "green"), col.grad=c("white", "black"))

#----------------
#Calculating the pairwise comparison without (effect of the method)
#----------------

#MLbest vs Baycon
pair.comp_without.MLbest.Baycon.RF<-pair.bhatt.coeff(sub.data(get(data.sets[1]), par_MLMFMC, metric=metrics[1]), sub.data(get(data.sets[2]), par_MLMFMC, metric=metrics[1]))
pair.comp_without.MLbest.Baycon.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[1]), par_MLMFMC, metric=metrics[2]), sub.data(get(data.sets[2]), par_MLMFMC, metric=metrics[2]))

#MLbest vs MLboot
pair.comp_without.MLbest.MLboot.RF<-pair.bhatt.coeff(sub.data(get(data.sets[1]), par_MLMFMC, metric=metrics[1]), sub.data(get(data.sets[3]), par_MLMFMC, metric=metrics[1]))
pair.comp_without.MLbest.MLboot.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[1]), par_MLMFMC, metric=metrics[2]), sub.data(get(data.sets[3]), par_MLMFMC, metric=metrics[2]))

#MLbest vs Baytre
pair.comp_without.MLbest.Baytre.RF<-pair.bhatt.coeff(sub.data(get(data.sets[1]), par_MLMFMC, metric=metrics[1]), sub.data(get(data.sets[4]), par_MLMFMC, metric=metrics[1]))
pair.comp_without.MLbest.Baytre.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[1]), par_MLMFMC, metric=metrics[2]), sub.data(get(data.sets[4]), par_MLMFMC, metric=metrics[2]))

#Baycon vs MLboot
pair.comp_without.Baycon.MLboot.RF<-pair.bhatt.coeff(sub.data(get(data.sets[2]), par_MLMFMC, metric=metrics[1]), sub.data(get(data.sets[3]), par_MLMFMC, metric=metrics[1]))
pair.comp_without.Baycon.MLboot.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[2]), par_MLMFMC, metric=metrics[2]), sub.data(get(data.sets[3]), par_MLMFMC, metric=metrics[2]))

#Baycon vs Baytre
pair.comp_without.Baycon.Baytre.RF<-pair.bhatt.coeff(sub.data(get(data.sets[2]), par_MLMFMC, metric=metrics[1]), sub.data(get(data.sets[4]), par_MLMFMC, metric=metrics[1]))
pair.comp_without.Baycon.Baytre.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[2]), par_MLMFMC, metric=metrics[2]), sub.data(get(data.sets[4]), par_MLMFMC, metric=metrics[2]))

#MLboot vs Baytre
pair.comp_without.MLboot.Baytre.RF<-pair.bhatt.coeff(sub.data(get(data.sets[3]), par_MLMFMC, metric=metrics[1]), sub.data(get(data.sets[4]), par_MLMFMC, metric=metrics[1]))
pair.comp_without.MLboot.Baytre.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[3]), par_MLMFMC, metric=metrics[2]), sub.data(get(data.sets[4]), par_MLMFMC, metric=metrics[2]))

#Store all this data as a list per metric
pair.comp_without.RF<-list(pair.comp_without.MLbest.Baycon.RF,
                           pair.comp_without.MLbest.MLboot.RF,
                           pair.comp_without.MLbest.Baytre.RF,
                           pair.comp_without.Baycon.MLboot.RF,
                           pair.comp_without.Baycon.Baytre.RF,
                           pair.comp_without.MLboot.Baytre.RF)
names(pair.comp_without.RF)<-c("MLbest vs Baycon", "MLbest vs MLboot",
                               "MLbest vs Baytre", "Baycon vs MLboot",
                               "Baycon vs Baytre", "MLboot vs Baytre")

pair.comp_without.Tr<-list(pair.comp_without.MLbest.Baycon.Tr,
                           pair.comp_without.MLbest.MLboot.Tr,
                           pair.comp_without.MLbest.Baytre.Tr,
                           pair.comp_without.Baycon.MLboot.Tr,
                           pair.comp_without.Baycon.Baytre.Tr,
                           pair.comp_without.MLboot.Baytre.Tr)
names(pair.comp_without.Tr)<-c("MLbest vs Baycon", "MLbest vs MLboot",
                               "MLbest vs Baytre", "Baycon vs MLboot",
                               "Baycon vs Baytre", "MLboot vs Baytre")

#Plot the distributions
op<-par(bty="l")
plot.bhatt.coeff.dist(pair.comp_without.RF, col=palette(), xlab="Bhattacharyya Coefficient", ylab="Frequency")
plot.bhatt.coeff.dist(pair.comp_without.Tr, col=palette(), xlab="Bhattacharyya Coefficient", ylab="Frequency")