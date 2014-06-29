##########################
#Posterior ML Tree
##########################
#Extracts the Maximum Likelihood tree out of MrBayes' posterior distribution.
#v.0.1
#TO DO: allow BEAST and PhyloBayes output files to be read as posterior
##########################
#SYNTAX :
#<chain> the prefix of the posterior distribution file (generally *.run*.p)
#<software> the software generating the posterior files (default="MrBayes")
#<output> the format for the output trees (either "nexus", "newick" or "none")
##########################
#----
#guillert(at)tcd.ie - 29/06/2014
##########################
#Requirements:
#-R 3
#- R package 'ape'
#-MrBayes *.p and *.t files
##########################

PostML<-function(chain, software="MrBayes", output="none") {

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

    

#FUNCTIONS

    FUN.ML<-function(posterior.table, tree.file) {
        ML.gen<-which(posterior.table[,2] == max(postrior.table[,2]))
        ML.gen<-postrior.table[ML.gen,1]
        PostML.tree<-tree.file[[which(names(tree.file) == paste("gen", ML.gen, sep="."))]]
        return(PostML.tree)
    }


#EXTRACTING THE ML TREE

    if(n.runs == 1){
        PostML.trees<-NULL
    } else {
        PostML.trees<-list(NULL)
    }

    for (n in 1:n.runs) {
        posterior.table<-read.table(postriors[n], header=TRUE, skip=1)
        tree.file<-read.nexus(trees[n])
        PostML.tree<-FUN.ML(postrior.table, tree.file)
        
        #Output
        PostML.trees[[n]]<-PostML.tree

        #Save the tree if necessary
        if(output == "newick"){
            write.tree(PostML.tree, file=paste(trees[n],"ML", sep="-"))
        }
        if(output == "nexus"){
            write.nexus(PostML.tree, file=paste(trees[n],"ML", sep="-"))
        }
    }

    return(PostML.trees)

#End
}
