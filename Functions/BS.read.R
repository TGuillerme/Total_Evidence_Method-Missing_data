##########################
#Bootstrap reading
##########################
#Extracts the Bootstrap values of a list of trees
#v.0.1
#TO DO: pattern should be either a list/single tree out/in of R environment
##########################
#SYNTAX :
#<pattern> any string of character present in the chain of trees to analyse
#<plot> logical, whether to plot the results or not
#<tree.names> logical, whether to add the tree names in the plot or not (ignored if plot=FALSE)
##########################
#----
#guillert(at)tcd.ie - 14/07/2014
##########################
#Requirements:
#-R 3
#-R package 'ape'
##########################

BS.read<-function(pattern, plot=TRUE, use.tree.names=TRUE){

#DATA INPUT
    #pattern
    if(class(pattern) !='character') {
        stop('No file has been found with the given pattern name')
    } else {
        pattern.list<-list.files(pattern=pattern)
        if(length(pattern.list) == 0) {
            stop('No file has been found with the given pattern name')
        }
    }

    #tree
    if(class(read.tree(list.files(pattern=pattern)[1])) !='phylo') {
        if(class(read.tree(list.files(pattern=pattern)[1])) !='multiPhylo') {
            stop('No tree found corresponding to the given pattern name')
        }
    }

    #use.tree.names
    if(class(use.tree.names) != 'logical') {
        stop('use.tree.names must be logical')
    }

#FUNCTIONS
    #Read the bootstrap values
    FUN.BS.read<-function(pattern) {

        #Extracting the tree names
        names<-list.files(pattern=pattern)
        #Preparing the list
        BS.list<-as.list(names)
        names(BS.list)<-names
        for (i in 1:length(BS.list)){BS.list[[i]]<-NA}

        #Extracting the bootstrap values from each tree and storing it in the list
        for (f in 1:length(list.files(pattern=pattern))){
            tree<-read.tree(list.files(pattern=pattern)[f])
            Nnodes<-tree[[2]]
                for (j in 1:Nnodes){
                    BS.list[[f]][j]<-as.numeric(tree[[5]])[j]
                }
            }
        return(BS.list)
    }

#EXTRACTING THE BOOTSTRAPS

    BS.list<-FUN.BS.read(pattern)

    #Plot
    if(plot==TRUE) {
        if(use.tree.names==TRUE) {
            boxplot(BS.list,las=2,ylab="Boostrap values")
        } else {
            boxplot(BS.list,las=1,ylab="Boostrap values", names=seq(1:length(BS.list)))
        }
    }
        
    return(BS.list)    
}