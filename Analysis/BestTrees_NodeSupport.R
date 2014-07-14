#Script for measuring the node support for the ML "best" trees.
#cd('../PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')

#Loading the functions
source('../Functions/BS.read.R')

library(xtable)

#Loading the trees
setwd('../Data/Best_trees_ML')
bootstraps<-BS.read('MChain', plot=TRUE, use.tree.names=FALSE)
setwd('../../Analysis/')
sum.bs<-unlist(bootstraps)
sum.bs<-sum.bs[-which(is.na(sum.bs))]

#Ploting the bootstrap distribution
hist(sum.bs, xlab="Bootstraps", main="Bootstraps distribution")

#Cumulate frequencies for BS thresholds
bs.100<-length(which(sum.bs == 100))/length(sum.bs)
bs.90<-length(which(sum.bs > 89))/length(sum.bs)
bs.80<-length(which(sum.bs > 79))/length(sum.bs)
bs.75<-length(which(sum.bs > 74))/length(sum.bs)
bs.50<-length(which(sum.bs > 49))/length(sum.bs)
s.bs<-summary(sum.bs)
#Result table
bs.results<-data.frame("median"=median(sum.bs), "1stQu"=s.bs[[2]], "3rdQu"=s.bs[[2]], "bs100"=bs.100, "bs.90"=bs.90, "bs.80"=bs.80, "bs.75"=bs.75, "bs.50"=bs.50)
xtable(bs.results)