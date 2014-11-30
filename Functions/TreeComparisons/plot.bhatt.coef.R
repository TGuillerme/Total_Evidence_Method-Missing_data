##########################
#Pairwise difference plot from an Bhattacharyya Coefficient matrix.
##########################
#Plots a pairwise comparison from an Bhattacharyya Coefficient matrix.
#v.0.1
##########################
#SYNTAX :
#<matrix> the posthoc results of a TreeCmp.anova function.
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

plot.bhatt.coeff<-function(matrix, col=c("blue", "red"), col.grad=c("white", "black")) {

    #SANITIZING
    #matrix
    if(class(matrix) != 'matrix') {
        stop('matrix argument is not a matrix object.')
    }

    #FUNCTIONS
    FUN.parameter.plot.lines<-function(colgrad, horizontal=TRUE) {
        if(horizontal == TRUE) {
            #Add the legend bars
            plot(1,1, xlab='', ylab='', xlim=c(1,125), ylim=c(0,3), type='n', yaxt='n', bty='n', xaxt='n')
            text(-2, 2.5, "ML")
            text(-2, 1.5, "MF")
            text(-2, 0.5, "MC")
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
            text(0.5, -2, "MC")
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

    #Setting the colours
    colfunc<-colorRampPalette(col)
    colheat<-colfunc(10)

    #Setting the plot window if ncol(matrix) == 125
    if (ncol(matrix) == 125) {
        nf<-layout(matrix(c(2,1,0,3),2,2,byrow = TRUE), c(1,4), c(4,1), FALSE)
        #layout.show(nf)
        par(mar=c(1,1,1.1,1.1))
    }

    #Plotting the heat map
    length.axis<-seq(from=0, to=1, length=ncol(matrix))
        
    #Heat map
    image(matrix, col=colheat, axes=FALSE) #0,1

    #Add legend
    legend(0,0.8, c(0,1), pch=15, pt.cex=1, col=col, title="Bhattacharyya\nCoefficient:", bty="n")

    #Plotting the axis
    if (ncol(matrix) == 125) {
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
    
#End
}



##########################
#Plot distributions of a list of Bhattacharyya Coefficients
##########################
#Plots a series of kernel density estimates of Bhattacharyya Coefficients
#v.0.1
##########################
#SYNTAX :
#<list> a list of Bhattacharyya Coefficients
#<...>  the name of the metric of interest
##########################
#----
#guillert(at)tcd.ie - 29/11/2014
##########################
#Requirements:
#-R 3
##########################

plot.bhatt.coeff.dist<-function(list, col, ...) {

#INPUT

    #list
    if(class(list) != 'list') {
        stop('Provided list is not a list of Bhattacharyya Coefficients.')
    }

    #list
    if(class(col) != 'character') {
        stop('col must be a vector of characters.')
    }    

#PLOT THE DISTRIBUTION

    #Calculating the density list
    density.list<-lapply(list, density)

    #Extracting the min/max for x and y axis
    ext.coord<-list("minx"=NA, "maxx"=NA, "miny"=NA, "maxy"=NA)
    for(i in 1:length(density.list)) {
        ext.coord$minx[[i]]<-min(density.list[[i]]$x)
        ext.coord$maxx[[i]]<-max(density.list[[i]]$x)
        ext.coord$miny[[i]]<-min(density.list[[i]]$y)
        ext.coord$maxy[[i]]<-max(density.list[[i]]$y)
    }

    #Setting the colours
    

    #Plotting the distributions
    plot(1,1, xlim=c(min(ext.coord$minx), max(ext.coord$maxx)), ylim=c(min(ext.coord$miny), max(ext.coord$maxy)), type='n', ...)
    for (n in 1:length(density.list)){
        lines(density.list[[n]], col=col[n])
    }

    #Adding the legend
    legend(mean(ext.coord$maxx-abs(ext.coord$minx)), max(ext.coord$maxy), names(density.list), cex=0.8, lty=1, col=col[1:length(density.list)], bty="n")

#End
}