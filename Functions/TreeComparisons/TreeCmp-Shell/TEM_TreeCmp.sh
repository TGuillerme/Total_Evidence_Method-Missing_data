##########################
#Uses TreeCmp java script to compare either single trees or treesets
##########################
#SYNTAX: TEM_TreeCmp <reference tree> <input tree> <number of random draws> <output> <tree format> <rooted>
#with:
#<reference tree> a tree file with the reference tree 
#<input tree> a tree file or a chain name with the tree to compare to the reference tree
#<number of random draws> number of random draws for the comparison (if 1, then method is singletrees, if >1 then method is Treesets)
#<output> a chain name for the output
#<trees> must be either nexus or newick
#<rooted> must be either TRUE or FALSE
##########################
#version: 1.1
#Update: improved output format
#Update: correction on the random tree selection from the ref tree: if the ref tree is unique, no sample is performed any more.
#Update: cleaning improved (remove the files from the concern chain only)
#Update: temporary results are now stored in a temporary folder
#Update: added a Treesets/Singletrees method input. If the method is Singletrees, there is no random tree drawing.
#Update: trees can now be nexus or newick
#Update: changed method arguments from Bayesian/ML to Treesets/Singletrees
#Update: improved documentation within the function
#Update: added a rooted/unrooted option
#Update: changed tree comparison architecture to rely more on Bogdanowicz's algorithm
#Update: improved tree reading (nexus vs newick)
#Update: number of species is now obsolete
#Update: method and random draws are now the same option, if random draws is 1, then method is singletrees, if random draws is >1 then method is Treesets
#Update: input tree now allows to use a chain name
#Update: can now deal with nexus files containing a translate part
#----
#guillert(at)tcd.ie - 07/07/2015
##########################
#Requirements:
#-R 3.x
#-TreeCmp java script (Bogdanowicz et al 2012)
#-http://www.la-press.com/treecmp-comparison-of-trees-in-polynomial-time-article-a3300
#-TreeCmp folder to be installed at the level of the analysis
##########################

#INPUT

#Input values
REFtree=$1
INPtree=$2
draws=$3
output=$4
treeFormat=$5
rooted=$6

#Creates the settings file
echo "$(ls *$INPtree* | wc -l | sed 's/[[:space:]]//g') file(s)" > TreeCmp_settings.tmp #Is a input a chain
echo "$draws draw(s)" >> TreeCmp_settings.tmp #which method to use
echo "$treeFormat trees" >> TreeCmp_settings.tmp #which tree format to use
echo "rooted=$rooted" >> TreeCmp_settings.tmp #is the tree rooted

#Creates the temporary output folder to store the temporary results
mkdir ${output}_tmp

#TREES SETTING

if grep '1 draw(s)' TreeCmp_settings.tmp >/dev/null
then
    #Only one draw, comparison is in single tree method
    #Is the input tree a chain?
    if grep '1 file(s)' TreeCmp_settings.tmp >/dev/null
    then
        echo $INPtree > ${output}_tmp/treenames.list
    else
        echo "Combining trees from $INPtree chain"
        if grep 'newick trees' TreeCmp_settings.tmp > /dev/null
        then
            #Combining the newick trees to a single INPUT tree file
            for f in *$INPtree*
            do
                cat $f >> ${output}_tmp/INPtree.treeset
                echo $f >> ${output}_tmp/treenames.list
                printf .
            done
        else
            #Combining the nexus trees to a single INPUT tree file
            #Creates the list of trees
            for f in *$INPtree*
            do
                echo $f >> ${output}_tmp/treenames.list
            done
            
            #Print the first tree with the nexus header
            firstTree=$(sed -n '1p' ${output}_tmp/treenames.list)
            cat $firstTree | sed '$d' > ${output}_tmp/INPtree.treeset
            printf .

            #Print the following trees without the nexus header
            sed '1d' ${output}_tmp/treenames.list > ${output}_tmp/treenames.list.tmp
            treesleft=$(wc -l ${output}_tmp/treenames.list.tmp | sed 's/'"${output}"'_tmp\/treenames.list.tmp//g')
            for n in $(seq 1 $treesleft)
            do
                nexustree=$(sed -n ''"${n}"'p' ${output}_tmp/treenames.list.tmp)
                sed '$d' ${nexustree} | sed -n '$p'>> ${output}_tmp/INPtree.treeset
                printf .
            done
            echo 'END;' >> ${output}_tmp/INPtree.treeset
            rm ${output}_tmp/treenames.list.tmp
        fi
        INPtree=${output}_tmp/INPtree.treeset
        echo "Done"
    fi
else
    #Is the input tree a chain?
    if grep '1 file(s)' TreeCmp_settings.tmp >/dev/null
    then
        echo $INPtree > ${output}_tmp/treenames.list

        #Counting the number of trees available
        if grep 'newick trees' TreeCmp_settings.tmp > /dev/null
        then
            #Number of newick trees per files
            REFntrees=$(cat $REFtree | wc -l)
            INPntrees=$(cat $INPtree | wc -l)
        else
            #Number of nexus trees per files
            REFntrees=$(grep "[[:space:]]TREE[[:space:]]\|[[:space:]]Tree[[:space:]]\|[[:space:]]tree[[:space:]]" $REFtree | wc -l)
            INPntrees=$(grep "[[:space:]]TREE[[:space:]]\|[[:space:]]Tree[[:space:]]\|[[:space:]]tree[[:space:]]" $INPtree | wc -l)
        fi

        #Creating the random draw list
        echo "if($REFntrees < $draws) {
                REFrep=TRUE } else {
                REFrep=FALSE}
            if($INPntrees < $draws) {
                INPrep=TRUE } else {
                INPrep=FALSE }
            #Saves the list of trees to sample in the REF and INP files    
            write(sample(seq(1:$REFntrees), $draws, replace=REFrep), file=\"${output}_tmp/REFtree.sample\", ncolumns=1)
            write(sample(seq(1:$INPntrees), $draws, replace=INPrep), file=\"${output}_tmp/INPtree.sample\", ncolumns=1) " | R --no-save >/dev/null
       
    else
        echo "A single tree file must be given if the number of draws is > 1."
        echo "The single tree file can however contain multiple trees."
        rm TreeCmp_settings.tmp
        rm -R ${output}_tmp/
        exit
    fi
fi

#TREE COMPARISON

#Setting the comparison metrics (if rooted/unrooted)
if grep 'rooted=TRUE' TreeCmp_settings.tmp > /dev/null
then
    #Rooted metrics
    metrics="mc rc ns tt" #Matching Cluster / Robinson-Foulds (based on cluster) / Nodal Split / Triples
else
    #Unrooted metrics
    metrics="ms rf pd qt" #Matching Split / Robinson-Foulds / Path difference / Quartet 
fi


if grep '1 draw(s)' TreeCmp_settings.tmp >/dev/null
then
    #Only one draw, comparison is in single tree method
    #Make the comparison using the TreeCmp java script on all metrics
    java -jar TreeCmp/bin/TreeCmp.jar -r $REFtree -d ${metrics} -i $INPtree -o ${output}_tmp/${output}.Cmp.tmp > /dev/null
    printf .
else
    #More than one draw, comparison is in treeset method
    echo "Comparing the trees $draws times"
    for n in $(seq -w 1 $draws)
    do
        #Extracting the trees from the random draw list
        i=$(sed -n ''"${n}p"'' ${output}_tmp/REFtree.sample)
        j=$(sed -n ''"${n}p"'' ${output}_tmp/INPtree.sample)
        if grep 'newick trees' TreeCmp_settings.tmp > /dev/null
        then
            #Newick trees
            sed -n ''"${i}p"'' $REFtree > ${output}_tmp/REF.tre
            sed -n ''"${j}p"'' $INPtree > ${output}_tmp/INP.tre
        else
            #Nexus trees
            ENDheaderREF=$(grep -n "[[:space:]]TREE[[:space:]]\|[[:space:]]Tree[[:space:]]\|[[:space:]]tree[[:space:]]" $REFtree | cut -f1 -d: | sed -n '1p')
            ENDheaderINP=$(grep -n "[[:space:]]TREE[[:space:]]\|[[:space:]]Tree[[:space:]]\|[[:space:]]tree[[:space:]]" $INPtree | cut -f1 -d: | sed -n '1p')
            let "ENDheaderREF -= 1"
            let "ENDheaderINP -= 1"
            inexus=$i
            jnexus=$j
            let "inexus += $ENDheaderREF"
            let "jnexus += $ENDheaderINP"
            sed -n '1,'"$ENDheaderREF"'p' $REFtree > ${output}_tmp/REF.tre
            #echo ";" >> ${output}_tmp/REF.tre
            sed -n ''"${inexus}p"'' $REFtree >> ${output}_tmp/REF.tre
            echo "END;" >> ${output}_tmp/REF.tre
            sed -n '1,'"$ENDheaderINP"'p' $INPtree > ${output}_tmp/INP.tre
            #echo ";" >> ${output}_tmp/INP.tre
            sed -n ''"${jnexus}p"'' $INPtree >> ${output}_tmp/INP.tre
            echo "END;" >> ${output}_tmp/INP.tre
        fi

        #Comparing the trees
        java -jar TreeCmp/bin/TreeCmp.jar -r ${output}_tmp/REF.tre -d ${metrics} -i ${output}_tmp/INP.tre -o ${output}_tmp/Cmp.${n}.tmp > /dev/null
        printf .

    done
    echo "Done"
fi

#BUILDING THE OUTPUT
if grep '1 draw(s)' TreeCmp_settings.tmp >/dev/null
then
    echo "Renaming the output comparisons"
    totalTrees=$(cat ${output}_tmp/treenames.list | wc -l)

    #Testing if a Multi tree file was used
    MultiTreeTest=$(cat ${output}_tmp/${output}.Cmp.tmp | wc -l)
    let "MultiTreeTest -= 1"
    #Creating the header
    echo "Reference Tree\tTree name" > ${output}_tmp/header.tmp

    if  echo $totalTrees | grep $MultiTreeTest > /dev/null
    then
        #Creating the header using the treenames.list file
        for n in $(seq 1 $totalTrees)
        do
            treename=$(sed -n ''"${n}"'p' ${output}_tmp/treenames.list)
            echo "$REFtree\t$treename"  >> ${output}_tmp/header.tmp
            printf .
        done
    else
        #Creating a new header from scratch
        for n in $(seq 1 $MultiTreeTest)
        do
            treename=$(sed -n '1p' ${output}_tmp/treenames.list)
            echo "$REFtree\t$treename.${n}"  >> ${output}_tmp/header.tmp
            printf .
        done
    fi

else
    echo "Combining the output comparisons"
    sed -n '1p' $(ls ${output}_tmp/Cmp.*.tmp | sed -n '1p') > ${output}_tmp/${output}.Cmp.tmp

    #Combining the output comparisons
    for n in $(seq -w 1 $draws)
    do
        sed -n '2p' ${output}_tmp/Cmp.${n}.tmp >> ${output}_tmp/${output}.Cmp.tmp
        printf .
    done

    #Creating the header using the randon draws list
    #Creating the header
    echo "Ref.tree@Inp.tree" | sed 's/@/'"$(printf '\t')"'/g' > ${output}_tmp/header.tmp
    paste ${output}_tmp/REFtree.sample ${output}_tmp/INPtree.sample >> ${output}_tmp/header.tmp
fi

#Pasting the header with the .Cmp.tmp file
paste ${output}_tmp/header.tmp ${output}_tmp/${output}.Cmp.tmp > ${output}_tmp/${output}.Cmp.tmp2
echo "write.table(read.table(\"${output}_tmp/${output}.Cmp.tmp2\", header=TRUE, sep='\t')[,-3], file=\"${output}_tmp/${output}.Cmp\", sep='\t', row.names=FALSE)" | R --no-save >/dev/null
sed 's/"//g' ${output}_tmp/${output}.Cmp > ${output}.Cmp
echo "Done"

#CLEANING
rm TreeCmp_settings.tmp
rm -R ${output}_tmp/


#end