##########################
#Adds the Robinson-Fould Branch length distance to a TreeCmp table.
##########################
#Calculate the Robinson-Fould Branch Length distance (Kuhner and Felsenstein (1994)) and adds it to the TreeCmp table
#v.0.1
##########################
#SYNTAX :
#<chain> the name of the chain
##########################
#----
#guillert(at)tcd.ie - 16/11/2014
##########################
#Requirements:
#-R 3
#-ape package
#-a "treecmps" folder containing the .Cmp files
#-a "trees" folder containing the .run*.t files
#-TEM_ChainSum.sh v1.0
#
#Use TEM_RFL_wrapper.sh to automatise the process and create the right folders
#
##########################


RFL<-function(chain) {

    require(ape)

    trees=list.files(paste(chain, "_treesets", sep=""))

    system(sys)
    exec.time<-vector()

    message("Calculating RFL for ", length(trees), " trees:")

    #Original tree input
    message("Reading the tree ", paste(chain, "_L00F00C00", sep=""), "...")
    treeset0<-read.nexus(paste(paste(chain, "_treesets", sep=""), paste(chain, "_L00F00C00.treeset", sep=""), sep="/"))
    message("Done")

    for (tree in 1:length(trees)) {
        
        #Tree input
        message("Reading the tree ", strsplit(trees[tree], split=".treeset")[[1]], "...")
        treeset<-read.nexus(paste(paste(chain, "_treesets", sep=""), trees[tree], sep="/"))
        #Table input
        table<-read.table(paste("treecmps", paste(strsplit(trees[tree], split=".treeset")[[1]], ".Cmp", sep=""), sep="/"), header=TRUE)
        message("Done")

        #Selecting the trees to compare in each tree comparison
        subtreeset0<-treeset0[c(table[,1])]
        subtreeset<-treeset[c(table[,2])]

        #Calculating the RFL
        start.time <- Sys.time()
        message("Calculating RFL for ", strsplit(trees[tree], split=".treeset")[[1]], "...")
        out.mapply<-mapply(dist.topo, x=subtreeset0, y=subtreeset, method="score")
        message("Done")
        end.time <- Sys.time()

        #Saving the execution time
        exec.time <- end.time - start.time

        #Saving the updated table
        table$RFL<-unlist(out.mapply)
        write.table(table, file=paste("treecmps", paste(strsplit(trees[1], split=".treeset")[[1]], ".Cmp", sep=""), sep="/"), quote=FALSE, row.names=FALSE, sep="\t")
    }

    message("Total execution time: ", sum(exec.time)/3600, " CPU hours.")

#End
}