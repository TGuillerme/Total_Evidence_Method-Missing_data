##########################
#Adds the Robinson-Fould Branch length distance to a TreeCmp table.
##########################
#Calculate the Robinson-Fould Branch Length distance (Kuhner and Felsenstein (1994)) and adds it to the TreeCmp table
#v.0.2
#Update: both types (treeset/single) are available
##########################
#SYNTAX :
#<chain> the name of the chain
#<type> either 'treeset' or 'single'
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


RFL<-function(chain, type) {

    #Libraries
    require(ape)

    #Treesets
    if(type == "treeset") {
        trees=list.files("treecmps/")

        sys<-paste("cd trees/ ; sh ../TEM_ChainSum.sh ", chain, " 51 25", sep="")
        system(sys)
        exec.time<-vector()

        message("Calculating RFL for ", length(trees), " trees:")

        #Original tree input
        message("Reading the tree ", paste(chain, "_L00F00C00", sep=""), "...")
        treeset0<-read.nexus(paste(paste(chain, "_treesets", sep=""), paste(chain, "_L00F00C00.treeset", sep=""), sep="/"))
        message("Done")

        for (tree in 1:length(trees)) {
            
            #Tree input
            message("Reading the tree ", strsplit(trees[tree], split=".Cmp")[[1]], "...")
            treeset<-read.nexus(paste(paste(chain, "_treesets", sep=""), paste(strsplit(trees[tree], split=".Cmp")[[1]], ".treeset", sep=""), sep="/"))
            #Table input
            table<-read.table(paste("treecmps", paste(strsplit(trees[tree], split=".Cmp")[[1]], ".Cmp", sep=""), sep="/"), header=TRUE)
            message("Done")

            #Selecting the trees to compare in each tree comparison
            subtreeset0<-treeset0[c(table[,1])]
            subtreeset<-treeset[c(table[,2])]

            #Calculating the RFL
            start.time <- Sys.time()
            message("Calculating RFL for ", strsplit(trees[tree], split=".Cmp")[[1]], "...")
            out.mapply<-mapply(dist.topo, x=subtreeset0, y=subtreeset, method="score")
            message("Done")
            end.time <- Sys.time()

            #Saving the execution time
            exec.time <- end.time - start.time

            #Saving the updated table
            table$RFL<-unlist(out.mapply)
            write.table(table, file=paste("treecmps", paste(strsplit(trees[tree], split=".Cmp")[[1]], ".Cmp", sep=""), sep="/"), quote=FALSE, row.names=FALSE, sep="\t")
        }

        message("Total execution time: ", sum(exec.time)/3600, " CPU hours.")
    }

    #single
    if(type == "single") {
        #Initializing the loop
        trees=list.files("treecmps/")
        exec.time<-vector()
        start.time <- Sys.time()

        #Original tree input
        message("Calculating RFL for ", length(trees), " trees:")
        tree0<-read.nexus(paste("trees", paste(chain, "_L00F00C00.con.tre", sep=""), sep="/"))

        #Creating the multiPhylo object
        for (tree in 1:length(trees)) {
            tree_comp<-read.nexus(paste("trees", paste(strsplit(trees[tree], split=".Cmp")[[1]], ".con.tre", sep=""), sep="/"))
            table<-read.table(paste("treecmps", paste(strsplit(trees[tree], split=".Cmp")[[1]], ".Cmp", sep=""), sep="/"), header=TRUE)
            table$RFL<-dist.topo(tree0, tree_comp, method="score")
            write.table(table, file=paste("treecmps", paste(strsplit(trees[tree], split=".Cmp")[[1]], ".Cmp", sep=""), sep="/"), quote=FALSE, row.names=FALSE, sep="\t")
            message(".", appendLF = FALSE)
        }
        message("Done")

        #Saving the execution time
        end.time <- Sys.time()
        exec.time <- end.time - start.time
        message("Total execution time: ", sum(exec.time)/3600, " CPU hours.")

    }

#End
}