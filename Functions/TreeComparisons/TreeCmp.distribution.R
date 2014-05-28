##########################
#TreeCmp distribution
##########################
#Plots the distribution of the metric of a 'TreeCmp' object
#v.0.1
##########################
#SYNTAX :
#<TreeCmp> an object of the class 'TreeCmp'
#<metric> the name of the metric of interest
##########################
#----
#guillert(at)tcd.ie - 28/05/2014
##########################
#Requirements:
#-R 3
##########################

TreeCmp.distribution<-function(TreeCmp, metric) {

#INPUT

    #TreeCmp
    if(class(TreeCmp) != 'TreeCmp') {
        stop('The input must be a "TreeCmp" class object')
    } else {
        length.TreeCmp<-length(TreeCmp) #The number of comparisons
        columns.TreeCmp<-length(TreeCmp[[1]]) #The number of columns per comparisons (i.e. the number of metrics)
        replicates.TreeCmp<-length(TreeCmp[[1]][[1]]) #The number of replicates per comparison
    }

    #metric
    if(class(metric) != 'character') {
        stop('Provided metric name is not found in the "TreeCmp" object')
    } else {
        if(length(metric) != 1) {
            stop('Only one metric name can be provided')
        } else {
            metric.column<-grep(metric, colnames(TreeCmp[[1]]))
            if(length(metric.column) == 0) {
                stop('Provided metric name is not found in the "TreeCmp" object')
            } else {
                TreeCmp.rows<-NULL
                for (i in 1:length.TreeCmp) {
                    TreeCmp.rows[i]<-length(TreeCmp[[i]][,metric.column])
                }
            }
        }
    }

#FUNCTION

    FUN.density.list<-function(TreeCmp, length.TreeCmp, metric.column){
        #Calculates the density in a list
        density.list<-NULL
        max.den<-NULL
        for (n in 1:length.TreeCmp){
            density.list[[n]]<-density(TreeCmp[[n]][[metric.column]])
            max.den[[n]]<-max(density.list[[n]]$y)
        }
        max.den<<-max(max.den) #Stores out of the function for the plot ylim

        return(density.list)
    }

#PLOT THE DISTRIBUTION

    #Calculating the density list
    density.list<-FUN.density.list(TreeCmp, length.TreeCmp, metric.column)

    #Setting the colours
    palette(rainbow(length.TreeCmp))

    #Plotting the distributions
    plot(density.list[[1]], col=palette()[1], ylim=c(0,max.den), main="Kernel Density Estimates")

    for (n in 2:length.TreeCmp){
        lines(density.list[[n]], col=palette()[n])
    }

    #Adding the legend
    legend(min(density.list[[1]]$x), max.den, names(TreeCmp), cex=0.8, lty=1, col=c(palette()[1:length.TreeCmp]))
    
    #Colours back to default
    palette("default")

#End
}