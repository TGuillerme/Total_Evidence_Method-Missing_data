##########################
#Building the tree sets for analysing the TEM simulation results
##########################
#SYNTAX :
#sh TEM_ChainSum.sh <Chain name> <number of species> <burnin>
#<Chain Name> the chain name of the treesets to combine
#<Number of species> the number of species in the trees
#<Burnin> the proportion of first trees to ignore as a burnin
##########################
#Create .treeset files with all the trees from two mb chains.
#version: 1.0
TEM_ChainSum_version="TEM_ChainSum.sh v1.0"
#Update: Allows a burnin proportion value
#Update: Error in the burnin is now fixed
#Update: Name change and cleaning
#Update: Name.run.t fixed
#Update: BurnTree variable fixed
#----
#guillert(at)tcd.ie - 02/09/2014
##########################


#Set the variables
chain=$1
nsp=$2
burnin=$3

#Move to the folder
cd *${chain}*

header=$nsp
let "header += 5"

FirstTree=$nsp
let "FirstTree += 6"

#Create the folder

mkdir ${chain}_treesets

#Create the .treeset file
echo "Generating the treesets files for ${chain}"
for f in ${chain}*.run1.t
    do prefix=$(basename $f .run1.t)

    #echo $prefix

    #print the header 
    head -$header ${prefix}.run1.t > ${chain}_treesets/${prefix}.treeset

    #Burnin
    BurnTree=$FirstTree
    length=$(grep '[&U]' $f | wc -l)
    let "length *= $burnin"
    let "length /= 100"
    let "BurnTree += $length"

    #Add the two list of trees
    sed -n ''"$BurnTree"',$p' ${prefix}.run1.t | sed '$d' >> ${chain}_treesets/${prefix}.treeset
    sed -n ''"$BurnTree"',$p' ${prefix}.run2.t >> ${chain}_treesets/${prefix}.treeset
    printf .
done
echo "Done"
echo ""

mv ${chain}_treesets/ ../

#end