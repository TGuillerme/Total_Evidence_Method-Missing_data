##########################
#Wrapper for the RFL function for the Total Evidence missing data analysis
##########################
#SYNTAX: TEM_RFL_wrapper <cmpz> <treez> <method> <type>
#With
#<chain> the chain name
#<cmpz> the path to the folder containing the .Cmp files
#<treez> the path to the folder containing the tree files
#<method> either Bayesian or ML
#<type> either single or treesets
##########################
#version: 1.0
#Update: now allows for method and type
#Update: fixed also for the RFL command
TEM_RFL_wrapper_version="TEM_RFL_wrapper.sh v1.0"
#----
#guillert(at)tcd.ie - 16/11/2014
##########################
#Requirements:
#-R 3
#-ape package
#-TEM_ChainSum.sh v1.0
##########################

chain=$1
cmpz=$2
treez=$3
method=$4
type=$5

#Copy the files in the current directory

rm -R treecmps/
rm -R trees/
mkdir treecmps/
mkdir trees/

echo "Copying the comparison files..."
cp $cmpz/$chain*.Cmp treecmps/
echo "Done"

if echo $method | grep "Bayesian" > /dev/null
then
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
else
    if echo $type | grep "single" > /dev/null
    then
        echo "Copying the tree files..."
        cp $treez/RAxML_bestTree.$chain_* trees/
        echo "Done"
    else 
        echo "Copying the tree files..."
        cp $treez/RAxML_bipartitions.$chain_* trees/
        echo "Done"
    fi 
fi

echo "source('RFL.R') ; RFL('$chain', method='$method', type='$type')" > R.task

R --no-save < R.task > /dev/null

rm R.task

rm -R trees/
mv treecmps/ $chain/

#End