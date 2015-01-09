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

#pair.comp_within.MLbest.RF<-pair.bhatt.coeff(sub.data(get(data.sets[1]), parameter, metric=metrics[1]), diag=TRUE)
#save(pair.comp_within.MLbest.RF, file="../Data/R_data/pair.comp_within.MLbest.RF.Rda")
load("../Data/R_data/pair.comp_within.MLbest.RF.Rda")
#pair.comp_within.MLbest.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[1]), parameter, metric=metrics[2]), diag=TRUE)
#save(pair.comp_within.MLbest.Tr, file="../Data/R_data/pair.comp_within.MLbest.Tr.Rda")
load("../Data/R_data/pair.comp_within.MLbest.Tr.Rda")
#pair.comp_within.Baycon.RF<-pair.bhatt.coeff(sub.data(get(data.sets[2]), parameter, metric=metrics[1]), diag=TRUE)
#save(pair.comp_within.Baycon.RF, file="../Data/R_data/pair.comp_within.Baycon.RF.Rda")
load("../Data/R_data/pair.comp_within.Baycon.RF.Rda")
#pair.comp_within.Baycon.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[2]), parameter, metric=metrics[2]), diag=TRUE)
#save(pair.comp_within.Baycon.Tr, file="../Data/R_data/pair.comp_within.Baycon.Tr.Rda")
load("../Data/R_data/pair.comp_within.Baycon.Tr.Rda")
#pair.comp_within.MLboot.RF<-pair.bhatt.coeff(sub.data(get(data.sets[3]), parameter, metric=metrics[1]), diag=TRUE)
#save(pair.comp_within.MLboot.RF, file="../Data/R_data/pair.comp_within.MLboot.RF.Rda")
load("../Data/R_data/pair.comp_within.MLboot.RF.Rda")
#pair.comp_within.MLboot.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[3]), parameter, metric=metrics[2]), diag=TRUE)
#save(pair.comp_within.MLboot.Tr, file="../Data/R_data/pair.comp_within.MLboot.Tr.Rda")
load("../Data/R_data/pair.comp_within.MLboot.Tr.Rda")
#pair.comp_within.Baytre.RF<-pair.bhatt.coeff(sub.data(get(data.sets[4]), parameter, metric=metrics[1]), diag=TRUE)
#save(pair.comp_within.Baytre.RF, file="../Data/R_data/pair.comp_within.Baytre.RF.Rda")
load("../Data/R_data/pair.comp_within.Baytre.RF.Rda")
#pair.comp_within.Baytre.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[4]), parameter, metric=metrics[2]), diag=TRUE)
#save(pair.comp_within.Baytre.Tr, file="../Data/R_data/pair.comp_within.Baytre.Tr.Rda")
load("../Data/R_data/pair.comp_within.Baytre.Tr.Rda")

#Visualising the results
pairwise.comp_within<-c("pair.comp_within.MLbest.RF", "pair.comp_within.MLbest.Tr",
                        "pair.comp_within.Baycon.RF", "pair.comp_within.Baycon.Tr",
                        "pair.comp_within.MLboot.RF", "pair.comp_within.MLboot.Tr",
                        "pair.comp_within.Baytre.RF", "pair.comp_within.Baytre.Tr")
plot.bhatt.coeff(get(pairwise.comp_within[3]), col=c("blue", "yellow"), col.grad=c("white", "black"))
summary(as.vector(get(pairwise.comp_within[3]))[-which(is.na(as.vector(get(pairwise.comp_within[3]))))])

#----------------
#Plotting the distribution of coefficients per method and per metric
#----------------
#Plotting the coefficients distribution for RF
Bhat.coeff.RF<-list(as.vector(pair.comp_within.MLbest.RF)[-which(is.na(as.vector(pair.comp_within.MLbest.RF)))],
                    as.vector(pair.comp_within.Baycon.RF)[-which(is.na(as.vector(pair.comp_within.Baycon.RF)))],
                    as.vector(pair.comp_within.MLboot.RF)[-which(is.na(as.vector(pair.comp_within.MLboot.RF)))],
                    as.vector(pair.comp_within.Baytre.RF)[-which(is.na(as.vector(pair.comp_within.Baytre.RF)))])
names(Bhat.coeff.RF)<-c("Maximum Likelihood - RF", "Bayesian consensus - RF", "Bootstraps - RF", "Bayesian posterior trees - RF")
op<-par(bty="l")
plot.bhatt.coeff.dist(Bhat.coeff.RF, col=palette(), xlab="Bhattacharyya Coefficient", ylab="Frequency")

#Plotting the coefficients distribution for Tr
Bhat.coeff.Tr<-list(as.vector(pair.comp_within.MLbest.Tr)[-which(is.na(as.vector(pair.comp_within.MLbest.Tr)))],
                    as.vector(pair.comp_within.Baycon.Tr)[-which(is.na(as.vector(pair.comp_within.Baycon.Tr)))],
                    as.vector(pair.comp_within.MLboot.Tr)[-which(is.na(as.vector(pair.comp_within.MLboot.Tr)))],
                    as.vector(pair.comp_within.Baytre.Tr)[-which(is.na(as.vector(pair.comp_within.Baytre.Tr)))])
names(Bhat.coeff.Tr)<-c("Maximum Likelihood - Tr", "Bayesian consensus - Tr", "Bootstraps - Tr", "Bayesian posterior trees - Tr")
op<-par(bty="l")
plot.bhatt.coeff.dist(Bhat.coeff.Tr, col=palette(), xlab="Bhattacharyya Coefficient", ylab="Frequency")


#----------------
#Calculating the pairwise comparison without (effect of the method)
#----------------

#MLbest vs Baycon
pair.comp_without.MLbest.Baycon.RF<-pair.bhatt.coeff(sub.data(get(data.sets[1]), parameter, metric=metrics[1]), sub.data(get(data.sets[2]), parameter, metric=metrics[1]))
pair.comp_without.MLbest.Baycon.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[1]), parameter, metric=metrics[2]), sub.data(get(data.sets[2]), parameter, metric=metrics[2]))

#MLbest vs MLboot
pair.comp_without.MLbest.MLboot.RF<-pair.bhatt.coeff(sub.data(get(data.sets[1]), parameter, metric=metrics[1]), sub.data(get(data.sets[3]), parameter, metric=metrics[1]))
pair.comp_without.MLbest.MLboot.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[1]), parameter, metric=metrics[2]), sub.data(get(data.sets[3]), parameter, metric=metrics[2]))

#MLbest vs Baytre
pair.comp_without.MLbest.Baytre.RF<-pair.bhatt.coeff(sub.data(get(data.sets[1]), parameter, metric=metrics[1]), sub.data(get(data.sets[4]), parameter, metric=metrics[1]))
pair.comp_without.MLbest.Baytre.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[1]), parameter, metric=metrics[2]), sub.data(get(data.sets[4]), parameter, metric=metrics[2]))

#Baycon vs MLboot
pair.comp_without.Baycon.MLboot.RF<-pair.bhatt.coeff(sub.data(get(data.sets[2]), parameter, metric=metrics[1]), sub.data(get(data.sets[3]), parameter, metric=metrics[1]))
pair.comp_without.Baycon.MLboot.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[2]), parameter, metric=metrics[2]), sub.data(get(data.sets[3]), parameter, metric=metrics[2]))

#Baycon vs Baytre
pair.comp_without.Baycon.Baytre.RF<-pair.bhatt.coeff(sub.data(get(data.sets[2]), parameter, metric=metrics[1]), sub.data(get(data.sets[4]), parameter, metric=metrics[1]))
pair.comp_without.Baycon.Baytre.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[2]), parameter, metric=metrics[2]), sub.data(get(data.sets[4]), parameter, metric=metrics[2]))

#MLboot vs Baytre
pair.comp_without.MLboot.Baytre.RF<-pair.bhatt.coeff(sub.data(get(data.sets[3]), parameter, metric=metrics[1]), sub.data(get(data.sets[4]), parameter, metric=metrics[1]))
pair.comp_without.MLboot.Baytre.Tr<-pair.bhatt.coeff(sub.data(get(data.sets[3]), parameter, metric=metrics[2]), sub.data(get(data.sets[4]), parameter, metric=metrics[2]))

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

#Summarizing these distributions in a table



#Creating the methods table
table.tmp<-data.frame("Maximum likelihood vs. Bayesian consensus - RF"=as.vector(summary(pair.comp_without.MLbest.Baycon.RF)),
                      "Maximum likelihood vs. Bayesian consensus - Tr"=as.vector(summary(pair.comp_without.MLbest.Baycon.Tr)),
                      "Maximum likelihood vs. Bootstraps - RF"=as.vector(summary(pair.comp_without.MLbest.MLboot.RF)),
                      "Maximum likelihood vs. Bootstraps - Tr"=as.vector(summary(pair.comp_without.MLbest.MLboot.Tr)),
                      "Maximum likelihood vs. Bayesian posterior trees - RF"=as.vector(summary(pair.comp_without.MLbest.Baytre.RF)),
                      "Maximum likelihood vs. Bayesian posterior trees - Tr"=as.vector(summary(pair.comp_without.MLbest.Baytre.Tr)),
                      "Bayesian consensus vs. Bootstraps - RF"=as.vector(summary(pair.comp_without.Baycon.MLboot.RF)),
                      "Bayesian consensus vs. Bootstraps - Tr"=as.vector(summary(pair.comp_without.Baycon.MLboot.Tr)),
                      "Bayesian consensus vs. Bayesian posterior trees - RF"=as.vector(summary(pair.comp_without.Baycon.Baytre.RF)),
                      "Bayesian consensus vs. Bayesian posterior trees - Tr"=as.vector(summary(pair.comp_without.Baycon.Baytre.Tr)),
                      "Boostraps vs. Bayesian posterior trees - RF"=as.vector(summary(pair.comp_without.MLboot.Baytre.RF)),
                      "Boostraps vs. Bayesian posterior trees - Tr"=as.vector(summary(pair.comp_without.MLboot.Baytre.Tr))
                      )

methods.table<-matrix(NA, ncol=6, nrow=12)
colnames(methods.table)<-names(summary(pair.comp_without.MLbest.Baycon.RF))
rownames(methods.table)<-colnames(table.tmp)
for (row in 1:12) {
    methods.table[row,]<-table.tmp[,row]
}

#LaTeX
library(xtable)
xtable(methods.table)
