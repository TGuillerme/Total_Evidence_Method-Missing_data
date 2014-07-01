##########################
#Posterior ML Tree
##########################
#Extracts the Maximum Likelihood tree out of MrBayes' posterior distribution.
#v.0.2
#Update: allows to save the ML score and the generation in a 'data.frame' object
#TO DO: allow BEAST and PhyloBayes output files to be read as posterior
##########################
#SYNTAX :
#<chain> the prefix of the posterior distribution file (generally *.run*.p)
#<software> the software generating the posterior files (default="MrBayes")
#<output> the format for the output trees (either "nexus", "newick" or "none")
#<save.score> logical, whether to save the generation number and the associated ML score in a 'data.frame' object
#<verbose> logical, whether to be verbose or not
##########################
#----
#guillert(at)tcd.ie - 01/07/2014
##########################
#Requirements:
#-R 3
#-R package 'ape'
#-MrBayes *.p and *.t files
##########################

PostML<-function(chain, software="MrBayes", output="none", save.score=FALSE, verbose=FALSE) {

#HEADER

#Loading the libraries
    require(ape)

#INPUT

    #Software
    if(class(software) != "character") {
        stop("Wrong software input.\nThis version allows only 'MrBayes'.")
    } else {
        if(software != "MrBayes") {
            stop("Wrong software input.\nThis version allows only 'MrBayes'.")
        }
    }

    #Posterior file is present
    if (length(grep(chain, list.files())) == 0) {
        stop("Posterior distribution file not found")
    } else {
        all.posterior<-list.files(pattern=chain)
        all.posterior<-grep(".t[:print:]", all.posterior, invert=TRUE, value=TRUE)
    }

    #MrBayes files configurations
    if (software == "MrBayes") {

        #Posterior files names
        if (length(grep(".p", all.posterior)) == 0) {
            stop("Posterior distribution file not found")
        } else {
            n.runs<-length(grep(".p", all.posterior))
            posteriors<-NULL
            for (n in 1:n.runs){
                run<-paste("run",n, sep="")
                posteriors[n]<-paste(chain,run,"p", sep=".")
            }
        }
    
        #Trees files names
        if (length(grep(".t", all.posterior)) != n.runs) {
            stop("Posterior tree files missing")
        } else {
            trees<-NULL
            for (n in 1:n.runs){
                run<-paste("run",n, sep="")
                trees[n]<-paste(chain,run,"t", sep=".")
            }
        } 
    }

    #Output
    if(class(output) != "character") {
        stop("Wrong output format.\nOutput should be either 'none', 'nexus' or 'newick'.")
    } else {
        if(output != "nexus") {
            if(output != "newick") {
                if(output != "none") {
                    stop("Wrong output format.\nOutput should be either 'none', 'nexus' or 'newick'.")
                }
            }
        }
    }        

    #Save.score
    if(class(save.score) != 'logical'){
        stop("Save.score must be logical")
    } else {
        if(save.score == TRUE) {
            cat("ML score are saved in 'PostML.score.txt'\n")
        }
    }

    #Verbose
    if(class(verbose) != 'logical'){
        stop("Verbose must be logical")
    }

#FUNCTIONS

    FUN.ML<-function(posterior.table, tree.file, save.score) {
        ML.score<-max(posterior.table[,2])
        ML.gen<-which(posterior.table[,2] == ML.score)
        ML.gen<-posterior.table[ML.gen,1]
        PostML.tree<-tree.file[[which(names(tree.file) == paste("gen", ML.gen, sep="."))]]
        if(save.score == TRUE){
            save.sc<<-c(ML.score, ML.gen)
        }
        return(PostML.tree)
    }


#EXTRACTING THE ML TREE

    #Setting the output file (depending on the number of runs)
    if(n.runs == 1){
        PostML.trees<-NULL
    } else {
        PostML.trees<-list(NULL)
    }

    for (n in 1:n.runs) {
        posterior.table<-read.table(posteriors[n], header=TRUE, skip=1)
        tree.file<-read.nexus(trees[n])
        if(verbose == TRUE){
            cat(format(Sys.time(), '%H:%M:%S'), '-', chain, "run", n, "done.\n")
        }
        PostML.tree<-FUN.ML(posterior.table, tree.file, save.score)
        
        #Output
        PostML.trees[[n]]<-PostML.tree
        if(save.score == TRUE){
            saving<-data.frame(NA,NA,NA,NA)
            saving[1,]<-c(chain, n, save.sc)
            write.table(saving, file="PostML.score.txt", append=TRUE, row.names=FALSE, col.names=FALSE)
        }

        #Save the tree if necessary
        if(output == "newick"){
            write.tree(PostML.tree, file=paste(strsplit(trees[n], ".t")[[1]],"ML", "tre", sep="."))
        }
        if(output == "nexus"){
            write.nexus(PostML.tree, file=paste(strsplit(trees[n], ".t")[[1]],"ML", "nex", sep="."))
        }
    }

    return(PostML.trees)

#End
}
