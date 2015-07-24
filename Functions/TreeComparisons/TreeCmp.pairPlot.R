##########################
#Pairwise difference plot from an 'TreeCmp' object anova.
##########################
#Plots a pairwise comparison results table to summarize a "TreeCmp" object anova.
#v.0.2
#Update: improved plotting when there is 125 pairwise comparisons
#Update: heat map can be transformed into a binary pixel map
##########################
#SYNTAX :
#<posthoc> the posthoc results of a TreeCmp.anova function.
#<parametric> whether the test was parametric or not (must be logical).
#<binary> whether to plot or not the levels of significance, when TRUE, plots the same colour for any significance level. If FALSE, plots a colour gradient (default = FALSE).
#<col> the colours for the colour gradient in the plot (if binary = TRUE, only the first colour is used - default= c("yellow", "red")).
#<col.grad> the colours for the colour gradient in the axis (default = c("white", "black")).
##########################
#----
#guillert(at)tcd.ie - 26/11/2014
##########################
#Requirements:
#-R 3
##########################

TreeCmp.pairPlot<-function(posthoc, parametric, binary=FALSE, col=c("yellow", "red"), col.grad=c("white", "black")) {

#DATA INPUT

    #DEBUG
    debug=FALSE
    if(debug==TRUE) {
        data.sets<-c("ML_besttrees","Bayesian_contrees","ML_bootstraps","Bayesian_treesets")
        metrics<-c("R.F_Cluster","Triples")
        TreeCmp<-sub.data(Bayesian_contrees, par_MLMFMC)
        metric<-metrics[1]
        plot=TRUE
        LaTeX=FALSE
        save.test=FALSE
        output<-TreeCmp.anova(TreeCmp, metric, plot=FALSE, LaTeX=FALSE, save.test=FALSE)
        parametric<-FALSE
        posthoc<-output$posthoc
        col=c("yellow", "red")
        col.grad=c("white", "black")
    }


    #parametric
    if(class(parametric) != 'logical'){
        stop('Parametric is not logical')
    }

    #posthoc
    if(parametric == FALSE){
        #posthoc comes from a non-parametric Kruskal-Wallis
        if(class(posthoc) != 'data.frame'){
            stop('Wrong posthoc format, pothoc must be the output of TreeCmp.anova function')
        } else {
            critical.dif<-posthoc[[2]][1]
            name.list<-unique(unlist(strsplit(row.names(posthoc), split="-")))
            n.parameters<-length(name.list)
            posthoc.scores<-posthoc[[1]]
            #remove non.significant values
            non.significant<-which(posthoc[[3]] == FALSE)
            posthoc.scores[non.significant]<-NA
        }
    } else {
        #posthoc comes from a parametric anova
        if(class(posthoc) != 'matrix'){
            stop('Wrong posthoc format, pothoc must be the output of TreeCmp.anova function')
        } else {
            critical.dif<-0
            name.list<-unique(unlist(strsplit(row.names(posthoc), split="-")))
            n.parameters<-length(name.list)
            posthoc.scores<-abs(as.vector(posthoc[,1]))
             #remove non.significant values
            non.significant<-which(as.vector(posthoc[,4]) > 0.05)
            posthoc.scores[non.significant]<-NA
        }
    }

    #col

    #col.grad


#FUNCTIONS

    FUN.matrix<-function(posthoc.scores, n.parameters, name.list, critical.dif){
        #transform the posthoc difference values in a squared matrix

        #Selecting the lower triangle of the matrix
        mat<-matrix(NA, n.parameters, n.parameters)
        sub<-lower.tri(mat, diag = FALSE)
        triangle<-which(as.vector(sub)==TRUE)

        #Selecting the cells in the matrix to be replaced by the posthoc scores
        values<-rep(NA, n.parameters*n.parameters)
        values[triangle]<-posthoc.scores-critical.dif

        #creating the final matrix
        mat<-matrix(values, n.parameters, n.parameters)
        rownames(mat)<-name.list
        colnames(mat)<-name.list

        return(mat)
    }

    FUN.parameter.plot.lines<-function(colgrad, horizontal=TRUE) {
        if(horizontal == TRUE) {
            #Add the legend bars
            plot(1,1, xlab='', ylab='', xlim=c(1,125), ylim=c(0,3), type='n', yaxt='n', bty='n', xaxt='n')
            text(-2, 2.5, "ML")
            text(-2, 1.5, "MF")
            text(-2, 0.5, "NC")
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
        } else {
            #Add the legend bars
            plot(1,1, xlab='', ylab='', xlim=c(0,3), ylim=c(1,125), type='n', yaxt='n', bty='n', xaxt='n')
            text(2.5, -2, "ML")
            text(1.5, -2, "MF")
            text(0.5, -2, "NC")
            #ML
            col.new<-colgrad[1:5]
            for(i in 1:5) {
                rect(xleft=2, xright=3, ybottom=(25*i-25), ytop=(25*i), col=col.new[i], broder=NULL, lty='blank')
            }
            #MF
            col.new<-rep(colgrad[1:5], 5)
            for(i in 1:25) {
                rect(xleft=1, ybottom=(5*i-5), xright=2, ytop=(5*i), col=col.new[i], broder=NULL, lty='blank')
            }
            #MC
            col.new<-rep(colgrad[1:5], 25)
            for(i in 1:125) {
                rect(xleft=0, ybottom=(1*i-1), xright=1, ytop=(1*i), col=col.new[i], broder=NULL, lty='blank')
            }
        }
    }

#PLOTING THE COMPARISONS HEAT MAP

    #Creating the matrix
    mat<-FUN.matrix(posthoc.scores, n.parameters, name.list, critical.dif)

    #Setting the colours
    colfunc<-colorRampPalette(col)
    colheat<-colfunc(3)

    #Setting the plot window if n.parameter == 125
    if (n.parameters == 125) {
        nf<-layout(matrix(c(2,1,0,3),2,2,byrow = TRUE), c(1,4), c(4,1), FALSE)
        #layout.show(nf)
        par(mar=c(1,1,1.1,1.1))
    }

    #Plotting the heat map
    length.axis<-seq(from=0, to=1, length=n.parameters)
        
    if(binary == FALSE) {
        #Heat map
        image(mat, col=colheat, axes=FALSE) #0,1

        #minimal critical difference distance
        min.dif<-round(min(posthoc.scores, na.rm=TRUE)-critical.dif, digit=3)
        #first quantile critical difference distance
        fst.dif<-round(summary(posthoc.scores)[[2]]-critical.dif, digit=3)
        #third quantile critical difference distance
        trd.dif<-round(summary(posthoc.scores)[[5]]-critical.dif, digit=3)
        #maximal critical difference distance
        max.dif<-round(max(posthoc.scores, na.rm=TRUE)-critical.dif, digit=3)

        #Add the legend
        legend(0,1,
            c(
                paste(min.dif, fst.dif, sep=":"),
                paste(fst.dif, trd.dif, sep=":"),
                paste(trd.dif, max.dif, sep=":")
            ),
            pch=15, pt.cex=2, col=colheat, title="Distance from critical difference", bty="n")
        title(main = "Significant posthoc pairwise differences")

    } else {
        #Heat map
        image(mat, col=col[1], axes=FALSE) #0,1
    }

    #Plotting the axis
    if (n.parameters == 125) {
        #Setting the colours
        colfunc<-colorRampPalette(col.grad)
        colgrad<-colfunc(5)

        #Plotting the axis gradients
        par(mar=c(0,0,0,0))
        FUN.parameter.plot.lines(colgrad, horizontal=FALSE)
        par(mar=c(0,0,0,0))
        FUN.parameter.plot.lines(colgrad)

    } else {        

        #Just adding normal axis
        axis(1, length.axis, labels=name.list,las=2, cex.axis=0.8)
        axis(2, length.axis, labels=name.list,las=2, cex.axis=0.8)
    }

    #
    
#End
}
