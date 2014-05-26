##########################
#Chain TreeCmp Mode
##########################
#Transform the values of a TreeCmp object in mode (e.g. for transforming Bayesian posterior distribution in mode)
#v.0.1
#To do: make this version work if the object is not 'TreeCmp'
##########################
#SYNTAX :
#<TreeCmp> a 'TreeCmp' object from TreeCmp.Read
#<length> the number of Random Pairwise Bayesian Tree Comparisons
#<verbose> whether to be verbose or not (default=FALSE) - useful for large data sets handling
##########################
#----
#guillert(at)tcd.ie - 25/04/2014
##########################
#Requirements:
#-R 3
##########################

TreeCmp.Mode<-function(TreeCmp, length, verbose=FALSE) {
#DATA INPUT
    #Verbose
    if(class(verbose) != 'logical') {
        stop('Verbose must be logical')
    }

    #TreeCmp
    if(class(TreeCmp) != 'TreeCmp') {
        stop('The input must be a "TreeCmp" class object')
    } else {
        length.TreeCmp<-length(TreeCmp)
        measures.TreeCmp<-length(TreeCmp[[1]])
        replicates.TreeCmp<-length(TreeCmp[[1]][[1]])
    }

    #length
    if(class(length) != 'numeric') {
        stop('Length must be a numeric')
    } else {
        replicates<-replicates.TreeCmp/length
        if (replicates==round(replicates)){
            if(verbose==TRUE){
            cat(replicates, "replicates found.", "\n")
            }
        } else {
            stop("length does not match with the number of replicates: \n one or more replicates probably don't have the same length")
        }
    }

#FUNCTIONS
    Fun.Mode<-function(x){
        as.numeric(names(sort(-table(x))[1]))
        }

#CALCULATING THE MODES OF THE TreeCmp OBJECT

    #Emptying the TreeCmp object
    mode.TreeCmp<-TreeCmp
    for (f in 1:length.TreeCmp){
        mode.TreeCmp[[f]]<-mode.TreeCmp[[f]][FALSE,]
    }

    #Filling mode.TreeCmp with the mode of every replicates
    for (f in 1:length.TreeCmp){
        for (r in 1:replicates){
            vector<-NULL
            for (m in 1:measures.TreeCmp){
                vector[[m]]<-Fun.Mode(TreeCmp[[f]][[m]][(1+((r*length)-length)):(r*length)])
            }
            mode.TreeCmp[[f]][r,]<-vector
        }
        if(verbose==TRUE){
            cat("Mode calculated for", names(TreeCmp[f]), "\n")
        }
    }

    #Return the results
    return(mode.TreeCmp)
#End
}