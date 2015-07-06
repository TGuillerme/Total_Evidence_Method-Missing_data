##########################
#Wrapper for the TreeCmp function for comparing the trees to a chain of reference trees (classicaly best/true)
##########################
#SYNTAX: TEM_TreeCmp_chain <chain> <method> <type> <ref>
#With
#<chain> chain name
#<method> either Bayesian or ML
#<type> either single or treesets
#<ref> either (${ref} or Best)
##########################
#version: 0.1
TEM_TreeCmp_chain_version="TEM_TreeCmp_chain.sh v0.1"
#----
#guillert(at)tcd.ie - 06/07/2015
##########################
#Requirements:
#-R 3.x
#-TEM_TreeCmp.sh
#-TreeCmp java script (Bogdanowicz et al 2012)
#-http://www.la-press.com/treecmp-comparison-of-trees-in-polynomial-time-article-a3300
#-TreeCmp folder to be installed at the level of the analysis
#-TEM_NexToNew.sh
##########################

chain=$1
method=$2
type=$3
ref=$4

if echo $method | grep "ML" > /dev/null
#ML method
then
    if echo $type | grep "single" > /dev/null
    #single
    then
        #running the comparisons
        sh TEM_TreeCmp.sh ${ref}_trees/${chain}_${ref}Tree/${chain}-${ref}_tree.tre ML_trees/${chain}_ML/RAxML_bestTree/RAxML_bestTree.${chain}_L 1 ${chain}-${method}-${type}_${ref} newick TRUE
    
    #Treesets
    else
        #running the comparisons
        for input in ML_trees/${chain}_ML/RAxML_bootstrap/RAxML_bootstrap.${chain}_L*
        do 
            tree=$(echo ${input} | sed 's/ML_trees\/'"${chain}"'_ML\/RAxML_bootstrap\/RAxML_bootstrap.'"${chain}"'_//g')
            echo $tree
            sh TEM_TreeCmp.sh ${ref}_trees/${chain}_${ref}Tree/${chain}-${ref}_tree.tre ${input} 1000 ${chain}_${tree}-${method}-${type}_${ref} newick TRUE
        done
    fi

#Bayesian method
else
    if echo $type | grep "single" > /dev/null
    #single
    then
        sh TEM_TreeCmp.sh ${ref}_trees/${chain}_${ref}Tree/${chain}-${ref}_tree.tre Bayesian_trees/${chain}_Bayesian/con.tre/${chain}_L 1 ${chain}-${method}-${type}_${ref} newick TRUE
    #Treesets
    else
        for input in Bayesian_trees/${chain}_Bayesian/treesets/${chain}_*.treeset
        do 
            tree=$(echo ${input} | sed 's/Bayesian_trees\/'"${chain}"'_Bayesian\/treesets\/'"${chain}"'_//g' | sed 's/.treeset//g')
            echo $tree
            sh TEM_TreeCmp.sh ${ref}_trees/${chain}_${ref}Tree/${chain}-${ref}_tree.nex ${input} 10 ${chain}_${tree}-${method}-${type}_${ref} nexus TRUE
        done        
    fi
fi

#End