##########################
#Pairwise difference plot from an 'TreeCmp' object anova.
##########################
#Plots a pairwise comparison results table to summarize a "TreeCmp" object anova.
#v.0.1
##########################
#SYNTAX :
#<posthoc> the posthoc results of a TreeCmp.anova function
#<parametric> whether the test was parametric or not (must be logical)
##########################
#----
#guillert(at)tcd.ie - 29/05/2014
##########################
#Requirements:
#-R 3
##########################

TreeCmp.pairPlot<-function(posthoc, parametric) {

#DATA INPUT

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

#PLOTING THE COMPARISONS HEAT MAP

    #Creating the matrix
    mat<-FUN.matrix(posthoc.scores, n.parameters, name.list, critical.dif)

    #Plotting the heat map
    heat<-rev(heat.colors(n.parameters, alpha=1))
    length.axis<-seq(from=0, to=1, length=n.parameters)
    image(mat, col=heat, axes=FALSE) #0,1
    axis(1, length.axis, labels=name.list,las=2, cex.axis=0.8)
    axis(2, length.axis, labels=name.list,las=2, cex.axis=0.8)
    legend(0,1,
        c(paste("min:",round(min(posthoc.scores, na.rm=TRUE), digit=3)),
            paste("median:",round(median(posthoc.scores, na.rm=TRUE), digit=3)),
            paste("max:",round(max(posthoc.scores, na.rm=TRUE), digit=3))
        ),
        pch=15, pt.cex=2, col=c(heat[1],heat[abs(n.parameters/2)],heat[n.parameters]))
    title(main = "Significant posthoc pairwise differences")
    box()
    
#End
}
