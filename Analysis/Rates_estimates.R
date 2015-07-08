#Script for post-analysing the morphological rates estimates

#Shell part (DO NOT RUN)
do.not.run=TRUE
if(do.not.run == FALSE) {
system('
mkdir morpho_rates
mkdir morpho_rates/TrueRates
mkdir morpho_rates/EstimatesRates

for n in $(seq -w 01 50)
do
    tar xvf True_trees/Chain${n}_TrueTree/Chain${n}-randoms.tar MorphoGammaRates.txt
    cat MorphoGammaRates.txt > morpho_rates/TrueRates/Chain${n}_TrueRates.txt
    rm MorphoGammaRates.txt
    grep "alpha{2}" Bayesian_trees/Chain${n}_Bayesian/MCMC/Chain${n}_*.pstat > morpho_rates/EstimatesRates/Chain${n}_EstRates.txt
    printf .
done
')

    #Reading the True Rates
    files<-list.files("morpho_rates/TrueRates/", pattern="Chain")
    True_Rates<-read.table(paste("morpho_rates/TrueRates/",files[n], sep=""))
    for (n in 2:50) {
        tmp<-read.table(paste("morpho_rates/TrueRates/",files[n], sep=""))
        True_Rates<-cbind(True_Rates, tmp)
    }
    names(True_Rates)<-seq(1:50)
    save(True_Rates, file="True_morpho.rates.Rda")

    #Reading the Estimates rates
    Estimates_rates<-list()
    files<-list.files("morpho_rates/EstimatesRates/", pattern="Chain")
    for (n in 1:50) {
        tmp<-read.table(paste("morpho_rates/EstimatesRates/",files[n], sep=""))
        tmp<-tmp[,c(2,3)]
        names(tmp)<-c("Mean", "Variance")
        Estimates_rates[[n]]<-tmp
    }
    names(Estimates_rates)<-seq(1:50)
    #Removed bugged chains
    Estimates_rates<-Estimates_rates[-c(3, 31)]
    save(Estimates_rates, file="Estimate_morpho.rates.Rda")

} else {
    load("../Data/R_data/True_morpho.rates.Rda")
    load("../Data/R_data/Estimate_morpho.rates.Rda")
}


#Building the true rates table
library(MASS)
True_tab<-data.frame(Mean=NA, Variance=NA)
for (n in 1:50) {
    options(warn=-1)
    tmp<-fitdistr(True_Rates[,n], 'gamma')
    options(warn=0)
    True_tab[n,1]<-tmp$estimate[[1]]
    True_tab[n,2]<-tmp$sd[[1]]
}
#Removed bugged chains
True_tab<-True_tab[-c(3,31),]

#Calculating the difference between the estimate the true rate
differences<-matrix(data=NA, ncol=48, nrow=125)
for(n in 1:48) {
    differences[,n]<-True_tab[n,1]-Estimates_rates[[n]][,1]
}

differences_theoretical<-matrix(data=NA, ncol=48, nrow=125)
for(n in 1:48) {
    differences_theoretical[,n]<-0.5-Estimates_rates[[n]][,1]
}

#Calculate the hdr for each tree
hdr.results<-NULL
for (i in 1:125) {
    hdr.results[[i]]<-hdr(differences[i,], prob=c(95,50), h= bw.nrd0(differences[i,]))
}


xlab=""
ylabels="Gamma shape difference (True - Estimate)"
ylim=c(-1,1)
probs=c(95,50)

quartz(width = 8.3, height = 5.8)
nf <- layout(matrix(c(1,2),2, byrow=TRUE), widths=c(1), heights=c(4,1), FALSE)
#layout.show(nf)
#Plot the difference results
par(mar=c(0,4,2,2), bty="l")

plot(1,1, xlab=xlab, ylab=ylabels, xlim= c(1,125), ylim=ylim, type='n', xaxt='n',las=2)
abline(h=0, lty=3)

#Adding the lines
for (j in 1:125) {
    temp <- hdr.results[[j]]
    shift=0
    border="black"

    for (k in 1:length(probs)) {
        #Plot the probabilities distribution
        temp2 <- temp$hdr[k, ]

        #Lines options
        lines(c(j+shift,j+shift), c(min(temp2[!is.na(temp2)]), max(temp2[!is.na(temp2)])), lwd=1+(k*2-2), lty=(length(probs)-(k-1)), col=border)  
        points(j+shift,temp$mode,pch=19, col=border)
    }
}

#Add the legend bars
par(mar=c(2,4,0,2))
plot(1,1, xlab='', ylab='', xlim=c(1,125), ylim=c(0,3), type='n', yaxt='n', bty='n', xaxt='n') #
text(-2, 2.5, "ML")
text(-2, 1.5, "MF")
text(-2, 0.5, "MC")

#Setting the color gradient
colfunc<-colorRampPalette(c("white", "black"))
colgrad<-colfunc(5)

#ML
col.new<-colgrad[1:5]
for(i in 1:5) {
    rect(xleft=(25*i-25), ybottom=2, xright=(25*i), ytop=3, col=col.new[i], broder=NULL, lty='blank')
}
#MF
col.new<-rep(colgrad[1:5], 5)
for(i in 1:25) {
    rect(xleft=(5*i-5), ybottom=1, xright=(5*i), ytop=2, col=col.new[i], broder=NULL, lty='blank')
}
#MC
col.new<-rep(colgrad[1:5], 25)
for(i in 1:125) {
    rect(xleft=(1*i-1), ybottom=0, xright=(1*i), ytop=1, col=col.new[i], broder=NULL, lty='blank')
}
