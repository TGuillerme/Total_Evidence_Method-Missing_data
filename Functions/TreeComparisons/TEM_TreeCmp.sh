##########################
#Uses TreeCmp java script to compare either single trees or treesets
##########################
#SYNTAX: TEM_TreeCmp <reference.treeset> <input.treeset> <number of species> <number of random draws> <output> <method> <trees>
#with:
#<reference.treeset> a tree file with the reference trees 
#<input.treeset> a tree file with the trees to compare to the reference tree
#<number of species> number of species per trees
#<number of random draws> number of random draws for the comparison
#<output> a chain name for the output
#<method> must be either Treesets or Singletrees
#<trees> must be either nexus or newick
#<rooted> must be either TRUE or FALSE
##########################
#version: 0.7
#Update: improved output format
#Update: correction on the random tree selection from the ref tree: if the ref tree is unique, no sample is performed any more.
#Update: cleaning improved (remove the files from the concern chain only)
#Update: temporary results are now stored in a temporary folder
#Update: added a Treesets/Singletrees method input. If the method is Singletrees, there is no random tree drawing.
#Update: trees can now be nexus or newick
#Update: changed method arguments from Bayesian/ML to Treesets/Singletrees
#Update: improved documentation within the function
#Update: added a rooted/unrooted option
#----
#guillert(at)tcd.ie - 27/06/2014
##########################
#Requirements:
#-R 3.x
#-TreeCmp java script (Bogdanowicz et al 2012)
#-http://www.la-press.com/treecmp-comparison-of-trees-in-polynomial-time-article-a3300
#-TreeCmp folder to be installed at the level of the analysis
##########################

#!/bin/sh
#INPUT

#Input values
REFtreeset=$1
INPtreeset=$2
species=$3
draws=$4
output=$5
method=$6
trees=$7
rooted=$8

#Creates the settings file
echo $method > TreeCmp_settings.tmp #which method to use
echo $trees >> TreeCmp_settings.tmp #which tree format to use
echo $rooted >> TreeCmp_settings.tmp #is the tree rooted

#Creates the temporary output folder to store the temporary results
mkdir ${output}_tmp

#TREES SETTING
if grep 'nexus' TreeCmp_settings.tmp > /dev/null
then
    #Make the nexus file header
    header=$species
    let "header += 5"
    head -$header $REFtreeset > ${output}_tmp/HEADER_${output}.Tree.tmp

    #Counting the number of trees in the ref/input treesets
    REFntrees=$(grep 'TREE\|Tree\|tree' $REFtreeset | grep '=\[\|=[[:space:]]\[' | wc -l)
    INPntrees=$(grep 'TREE\|Tree\|tree' $INPtreeset | grep '=\[\|=[[:space:]]\[' | wc -l)
else
    echo 'newick is fantastic' > /dev/null
    #Counting the number of trees in the ref/input treesets
    REFntrees=$(grep '(' $REFtreeset | wc -l)
    INPntrees=$(grep '(' $INPtreeset | wc -l)
fi

#RANDOM DRAW LIST

#Create the list of trees to sample. If the provided number of random draws is higher than the number of trees, the sample is done with replacement.
if grep 'Treesets' TreeCmp_settings.tmp > /dev/null
then
    echo "if($REFntrees < $draws) {
            REFrep=TRUE } else {
            REFrep=FALSE}
        if($INPntrees < $draws) {
            INPrep=TRUE } else {
            INPrep=FALSE }
        #Saves the list of trees to sample in the REF and INP files    
        write(sample(seq(1:$REFntrees), $draws, replace=REFrep), file='REFtreeset.sample', ncolumns=1)
        write(sample(seq(1:$INPntrees), $draws, replace=INPrep), file='INPtreeset.sample', ncolumns=1) " | R --no-save
else
    #If the method is set to Singletrees, only the first available tree is used from the REF/INP files
    draws=1
    echo "1" > REFtreeset.sample
    echo "1" > INPtreeset.sample
fi

mv *.sample ${output}_tmp/

#TREE COMPARISONS

#Setting the comparison metrics (if rooted/unrooted)
if grep 'TRUE' TreeCmp_settings.tmp > /dev/null
then
    #Rooted metrics
    metrics="mc rc ns tt" #Matching Cluster / Robinson-Foulds (base don cluster) / Nodal Split / Triples
else
    #Unrooted metrics
    metrics="ms rf pd qt" #Matching Split / Robinson-Foulds / Path difference / Quartet 
fi

#Creates the files of single trees and compare them one to one
if grep 'nexus' TreeCmp_settings.tmp > /dev/null
then

    #Comparisons using nexus format
    for n in $(seq 1 $draws)
    do
        #Creates the ref tree file for one draw (containing only one tree selected from the *.sample file)
        cp ${output}_tmp/HEADER_${output}.Tree.tmp ${output}_tmp/REFtreeset_tree${n}.Tree.tmp
        REFrand=$(sed -n ''"${n}"'p' ${output}_tmp/REFtreeset.sample)
        let "REFrand += $header"
        sed -n ''"$REFrand"'p' $REFtreeset >> ${output}_tmp/REFtreeset_tree${n}.Tree.tmp
        echo 'end;' >> ${output}_tmp/REFtreeset_tree${n}.Tree.tmp

        #Creates the input tree file for one draw (containing only one tree selected from the *.sample file)
        cp ${output}_tmp/HEADER_${output}.Tree.tmp ${output}_tmp/INPtreeset_tree${n}.Tree.tmp
        INPrand=$(sed -n ''"${n}"'p' ${output}_tmp/INPtreeset.sample)
        let "INPrand += $header"
        sed -n ''"$INPrand"'p' $INPtreeset >> ${output}_tmp/INPtreeset_tree${n}.Tree.tmp
        echo 'end;' >> ${output}_tmp/INPtreeset_tree${n}.Tree.tmp

        #Make the comparison using the TreeCmp java script on all metrics
        java -jar TreeCmp/bin/TreeCmp.jar -r ${output}_tmp/REFtreeset_tree${n}.Tree.tmp -d ${metrics} -i ${output}_tmp/INPtreeset_tree${n}.Tree.tmp -o ${output}_tmp/${output}_draw${n}.Cmp.tmp
    done

else

    #Comparisons using newick format
    for n in $(seq 1 $draws)
    do
        #Creates the ref tree file for one draw
        REFrand=$(sed -n ''"${n}"'p' ${output}_tmp/REFtreeset.sample)
        sed -n ''"$REFrand"'p' $REFtreeset > ${output}_tmp/REFtreeset_tree${n}.Tree.tmp

        #Creates the input tree file for one draw
        INPrand=$(sed -n ''"${n}"'p' ${output}_tmp/INPtreeset.sample)
        sed -n ''"$INPrand"'p' $INPtreeset >> ${output}_tmp/INPtreeset_tree${n}.Tree.tmp

        #Make the comparison using the TreeCmp java script on all metrics
        java -jar TreeCmp/bin/TreeCmp.jar -r ${output}_tmp/REFtreeset_tree${n}.Tree.tmp -d ${metrics} -i ${output}_tmp/INPtreeset_tree${n}.Tree.tmp -o ${output}_tmp/${output}_draw${n}.Cmp.tmp
    done

fi


#SUMMARIZING THE COMPARISONS

#Comparison header
sed -n '1p' ${output}_tmp/${output}_draw1.Cmp.tmp | sed $'s/Tree/Ref.trees\t\Input.trees/g' > ${output}.Cmp

#Add the values from each comparison
for n in $(seq 1 $draws)
do
    REFrand=$(sed -n ''"${n}"'p'  ${output}_tmp/REFtreeset.sample)
    INPrand=$(sed -n ''"${n}"'p'  ${output}_tmp/INPtreeset.sample)
    sed -n '2p' ${output}_tmp/${output}_draw${n}.Cmp.tmp | sed 's/^./'"$REFrand"'@'"$INPrand"'/' | sed $'s/@/\t/' >> ${output}.Cmp
done

#Removing the temporary folder
rm -R ${output}_tmp/
rm TreeCmp_settings.tmp

#end