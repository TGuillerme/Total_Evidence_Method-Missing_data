##########################
#Anova on TreeCmp analysis
##########################
#Performs an anova on a 'TreeCmp' object
#Performs a TukeyHSD if a posthoc difference is significant
#v.0.1
##########################
#SYNTAX :
#<data> an object of the class 'TreeCmp'
#<metric> the name of the metric of interest
#<plot> whether to plot the distribution of the metric as a boxplot (default=FALSE)
#<LaTeX> whether to output a LaTeX table (default=FALSE)
##########################
#----
#guillert(at)tcd.ie - 27/05/2014
##########################
#Requirements:
#-R 3
#-R package 'xtable' [optional]
##########################

TreeCmp.anova<-function(TreeCmp, metric, plot=FALSE, LaTeX=FALSE) {

#HEADER

#DATA INPUT

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

    #plot
    if(class(plot) != 'logical'){
        stop('Plot is not logical')
    }

    #LaTeX
    if(class(LaTeX) != 'logical'){
        stop('LaTeX is not logical')
    } else {
        if(LaTeX == TRUE){
            require(xtable)
        }
    }

#FUNCTIONS

    FUN.data.table<-function(TreeCmp, metric, replicates.TreeCmp){
        #makes a data frame of all the replicates for one metric for all the comparisons (length must be length.TreeCmp*replicates.TreeCmp)
        data.table<-NULL
        metric.number<-which(names(TreeCmp[[1]]) == metric)

        for (n in 1:length.TreeCmp){
            data.table[[n]]<-TreeCmp[[n]][[metric.number]]
        }

        data.table<-as.data.frame(data.table)
        names(data.table)<-names(TreeCmp)

        return(data.table)
    }

    FUN.anova.data<-function(data.table, length.TreeCmp, replicates.TreeCmp) {
        #makes a factor vector and a values vector
        factors<-NULL
        for (n in 1:length.TreeCmp){
            factors<-c(factors, rep(names(TreeCmp)[n], replicates.TreeCmp))
        }

        values<-NULL
        for (n in 1:length.TreeCmp) {
            values<-c(values, data.table[[n]])
        }
        
        anova.data<-list(factors=factors, values=values)
        return(anova.data)

    }

#CALCULATING THE DIFFERENCE BETWEEN THE TREE COMPARISONS

    data.table<-FUN.data.table(TreeCmp, metric, replicates.TreeCmp)
    anova.data<-FUN.anova.data(data.table, length.TreeCmp, replicates.TreeCmp)
    aov<-aov(values ~ factors, data=anova.data)
    anova<-summary(aov) #more variation among groups than within? null hypothesis that there is no difference among groups.
    pvalue<-anova[[1]][[5]][1]

    #If there posthoc difference
    if(pvalue < 0.05){
        tukey<-TukeyHSD(aov)
    }

    #Plot (optional)
    if(plot == TRUE){
        if(pvalue < 0.05) {
            par( mfrow = c( 1, 2 ) )
            plot(TukeyHSD(aov), las=2)
            boxplot(data.table, ylab=metric, las=2, main="Data distribution")
        } else {
            boxplot(data.table, ylab=metric, las=2, main="Data distribution") 
        }
    }

#OUTPUT

    if(LaTeX == TRUE){
        TreeCmp.xtable<<-xtable(aov)
        cat('LaTeX anova table available in : \n TreeCmp.xtable',"\n")

        if(pvalue < 0.05){
            TreeCmp.xtables<<-list(anova=xtable(aov), TukeyHSD=xtable(tukey$factors))
            cat('LaTeX anova table available in : \n TreeCmp.xtables$anova',"\n")
            cat('LaTeX TukeyHSD table available in : \n TreeCmp.xtables$TuckeyHSD',"\n")
        }
    }

    if(pvalue < 0.05){
        output<-list(anova=anova, TukeyHSD=tukey)
    } else {
        output<-anova
    }

    return(output)

#End
}