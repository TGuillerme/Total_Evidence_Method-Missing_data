##########################
#Wrapper for the RFL function for the Total Evidence missing data analysis
##########################
#SYNTAX: TEM_RFL_wrapper <cmpz> <treez> <type>
#With
#<chain> the chain name
#<cmpz> the path to the folder containing the .Cmp files
#<treez> the path to the folder containing the tree files
#<type> either single or treesets
##########################
#version: 0.1
TEM_RFL_wrapper_version="TEM_RFL_wrapper.sh v0.1"
#----
#guillert(at)tcd.ie - 16/11/2014
##########################
#Requirements:
#-R 3
#-ape package
#-a "treecmps" folder containing the .Cmp files
#-a "trees" folder containing the .run*.t files
#-TEM_ChainSum.sh v1.0
##########################

chain=$1
cmpz=$2
treez=$3
type=$4

#Copy the files in the current directory

mkdir treecmps/
mkdir trees/

echo "Copying the comparison files..."
cp $cmpz/$chain*.Cmp treecmps/
echo "Done"

if echo $type | grep "single" > /dev/null
then
    echo "Copying the tree files..."
    cp $treez/$chain*.con.tre trees/
    echo "Done"
else 
    echo "Copying the tree files..."
    cp $treez/$chain*.run*.t trees/
    echo "Done"
fi

echo "source('RFL.R') ; RFL('$chain', type='$type')" > R.task

R --no-save < R.task > /dev/null

rm R.task

#End