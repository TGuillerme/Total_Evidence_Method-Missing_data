#Script for measuring the node support for the ML "best" trees.
#cd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')

#Loading the functions
source('../Functions/BS.read.R')
library(xtable)

#Loading the Bootstrap values
setwd('../Data/Best_trees_ML')
bootstraps<-BS.read('MChain', plot=TRUE, use.tree.names=FALSE)
setwd('../../Analysis/')
sum.bs<-unlist(bootstraps)
sum.bs<-sum.bs[-which(is.na(sum.bs))]

#Plotting the bootstrap distribution
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

##################
#Correlation between Birth-Death parameters and median bootstrap
##################

#Extracting median bootstrap
boots<-bootstraps
for (f in 1:length(bootstraps)){
    boots[[f]]<-bootstraps[[f]][-which(is.na(bootstraps[[f]]))]
}
bs<-as.vector(unlist(lapply(boots, median)))

#Extracting the BD parameters
setwd('../Data/')
comp<-read.table("BD-param.txt", header=FALSE)
setwd('../Analysis/')
turnover<-comp[,2]/comp[,1]
net.div<-comp[,1]-comp[,2]

#Linear regression models
comp2<-data.frame('name'=seq(1,50), 'type'=rep('bla',50),'lambda'=comp[,1],'mu'=comp[,2],'turnover'=turnover,'net.div'=net.div,'bootstrap'=bs)
mod.lambda<-lm(bootstrap~lambda, data=comp2)
mod.mu<-lm(bootstrap~mu, data=comp2)
mod.turnover<-lm(bootstrap~turnover, data=comp2)
mod.net.div<-lm(bootstrap~net.div, data=comp2)

#Color plot
plot(comp2$lambda, comp2$bootstrap, col=1, pch=16, xlim=c(0,1), ylim=c(0,80), xlab='parameters', ylab='Median bootstrap')
points(comp2$mu, comp2$bootstrap, col=2, pch=16)
points(comp2$turnover, comp2$bootstrap, col=3, pch=16)
points(comp2$net.div, comp2$bootstrap, col=4, pch=16)
abline(mod.lambda, col=1)
text(0.28,21,
     paste("R=", round(summary(mod.lambda)[[8]],3), " p=",round(summary(mod.lambda)[[4]][8],4), sep="")
    ,cex=0.6, col=1)
abline(mod.mu, col=2)
text(0.9,70,
     paste("R=", round(summary(mod.mu)[[8]],3), " p=",round(summary(mod.mu)[[4]][8],4), sep="")
    ,cex=0.6, col=2)
abline(mod.turnover, col=3)
text(0.92,35,
     paste("R=", round(summary(mod.turnover)[[8]],3), " p=",round(summary(mod.turnover)[[4]][8],4), sep="")
    ,cex=0.6, col=3)
abline(mod.net.div, col=4)
text(0.6,70,
     paste("R=", round(summary(mod.net.div)[[8]],3), " p=",round(summary(mod.net.div)[[4]][8],4), sep="")
    ,cex=0.6, col=4)
legend(0.2, 80, cex=0.8, c(expression(lambda), expression(mu), expression(mu/lambda), expression(lambda-mu)), col=(1:4), pch=16)

#Grayscale plot
palette(gray(seq(0, 0.75 ,length = 4)))
plot(comp2$lambda, comp2$bootstrap, bg=1, pch=21, xlim=c(0,1), ylim=c(0,80), xlab='parameters', ylab='Median bootstrap')
points(comp2$mu, comp2$bootstrap, bg=2, pch=22)
points(comp2$turnover, comp2$bootstrap, bg=3, pch=23)
points(comp2$net.div, comp2$bootstrap, bg=4, pch=24)
abline(mod.lambda, lty=1)
text(0.28,21,
     paste("R=", round(summary(mod.lambda)[[8]],3), " p=",round(summary(mod.lambda)[[4]][8],4), sep="")
    ,cex=0.6)
abline(mod.mu, lty=2)
text(0.9,70,
     paste("R=", round(summary(mod.mu)[[8]],3), " p=",round(summary(mod.mu)[[4]][8],4), sep="")
    ,cex=0.6)
abline(mod.turnover, lty=3)
text(0.92,35,
     paste("R=", round(summary(mod.turnover)[[8]],3), " p=",round(summary(mod.turnover)[[4]][8],4), sep="")
    ,cex=0.6)
abline(mod.net.div, lty=4)
text(0.6,70,
     paste("R=", round(summary(mod.net.div)[[8]],3), " p=",round(summary(mod.net.div)[[4]][8],4), sep="")
    ,cex=0.6)
legend(0.2, 80, cex=0.8, c(expression(lambda), expression(mu), expression(mu/lambda), expression(lambda-mu)), pt.bg=(1:4), pch=(21:24), lty=(1:4), merge=F)
