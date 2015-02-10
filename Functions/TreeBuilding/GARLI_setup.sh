#!/bin/sh
##########################
#Building a GARLI conf file and partitioning a nexus file for running a GARLI analysis
##########################
#SYNTAX :
#sh GARLI-setup.sh <nexus_matrix> <n_taxa> <Mol_characters> <Evol_model> <Mol_ratecat> <Morpho_characters> <Morpho_ratecat> <outgroup> <bootstraps> <template>
#with
#<nexus_matrix>      a nexus matrix
#<n_taxa>            the number of taxa
#<Mol_characters>    the number of molecular characters (if 0, data will be only standard)
#<Evol_model>        the evolutionary model for the molecular partition (either HKY or GTR)
#<Mol_ratecat>       the number of gamma rate categories for the molecular partition
#<Morpho_characters> the number of morphological characters (if 0, data will be only DNA)
#<Morpho_ratecat>    the number of gamma rate categories for the morphological partition
#<outgroup>          the outgroup (if 1, outgroup is ignored)
#<bootstraps>        the number of bootstrap replicates (if 0, no bootstraps will be performed)
#<template>          a template configuration file for GARLI to use (if 0, the configuration will be set to default: default GARLI.conf file with genthreshfortopoterm set to 5000 if bootstraps are called)
##########################
#version: 0.1
GARLI_setup_version="GARLi_setup.sh v0.1"
#----
#guillert(at)tcd.ie - 09/02/2014
##########################
#Requirements:
##########################

#INPUT

#Input values
nexus_matrix=$1
#nexus_matrix="Chain01_L00F00C00.nex"
n_taxa=$2
#n_taxa=51
Mol_characters=$3
#Mol_characters=1000
Evol_model=$4
#Evol_model="HKY"
Mol_ratecat=$5
#Mol_ratecat=4
Morpho_characters=$6
#Morpho_characters=100
Morpho_ratecat=$7
#Morpho_ratecat=1
outgroup=$8
#outgroup="sp0000"
bootstraps=$9
#bootstraps=100
template=${10}
#template=0

#Setting the chain name
chain_name=$(echo $nexus_matrix | sed 's/.nex//')

#Setting the matrix tags
#Starting line
matrix_start_line=$(grep -n "matrix\|MATRIX\|Matrix" $nexus_matrix | sed 's/:[[:space:]][[:alpha:]][[:alpha:]][[:alpha:]][[:alpha:]][[:alpha:]][[:alpha:]]//g')
#Check where the matrix block starts (the following line first)
let "matrix_start_line += 1"
until sed -n ''"$matrix_start_line"'p' $nexus_matrix | grep [[:alpha:]] > /dev/null
do
    let "matrix_start_line += 1"
done
#Ending line
matrix_end_line=$matrix_start_line
let "matrix_end_line += $n_taxa"

#Extracting the matrix block (+ remove the last lines)
sed -n ''"$matrix_start_line"','"$matrix_end_line"'p' $nexus_matrix | sed '$d' > matrix_block.tmp

#Extracting the list of taxa names
taxlab=$(sed 's/[[:space:]].*//g' matrix_block.tmp)
taxlabel="Taxlabels ${taxlab};"

#Extracting the data
echo "Extracting the data:"
#Testing which of the morphological or molecular data comes first in the matrix
#In the first line, take the $Morpho_characters first elements, remove the taxon name, search for numeric characters
if sed -n '1p' matrix_block.tmp | cut -c1-$Morpho_characters | sed 's/[[:alnum:]]*//' | grep "[0-9]" > /dev/null
then
    #The morphological matrix comes first in the input matrix
    for OTU in $(seq 1 $n_taxa)
    do
        #Select the line for the OTU
        OTU_line=$(sed -n ''"$OTU"'p' matrix_block.tmp)
        #Get the start cell of the matrix (ignoring the species name)
        matrix_start_cell=$(echo $OTU_line | sed 's/\([[:alnum:]]*[[:space:]]*\).*/\1/g' | wc -m)
        #Get the length of the taxa name (+space)
        taxa_length=$matrix_start_cell
        let "taxa_length -= 1"
        #The $Morpho_characters first characters are numeric (= morphological matrix)
        #Add taxa names into the characters count
        morpho_character_end=$Morpho_characters
        let "morpho_character_end += $taxa_length"
        #Select the first $Morpho_characters + $matrix_start_cell characters
        echo $OTU_line | cut -c1-$morpho_character_end >> Morphological_block.tmp
        #The next $Mol_characters are DNA or missing (= molecular matrix)
        #Set the first morphological characters
        first_mol_character=$morpho_character_end
        let "first_mol_character += 1"
        #Get the last character
        last_character=$morpho_character_end
        let "last_character += $Mol_characters"
        #Select the first $taxa_length characters + the $morpho_character_end to the end characters
        echo $OTU_line | cut -c1-$taxa_length -c$first_mol_character-$last_character >> Molecular_block.tmp
        #be verbose
        printf .
    done
else
    #The molecular matrix comes first in the input matrix
    for OTU in $(seq 1 $n_taxa)
    do
        #Select the line for the OTU
        OTU_line=$(sed -n ''"$OTU"'p' matrix_block.tmp)
        #Get the start cell of the matrix (ignoring the species name)
        matrix_start_cell=$(echo $OTU_line | sed 's/\([[:alnum:]]*[[:space:]]*\).*/\1/g' | wc -m)
        #Get the length of the taxa name (+space)
        taxa_length=$matrix_start_cell
        let "taxa_length -= 1"
        #The $Mol_characters first characters are numeric (= molecular matrix)
        #Add taxa names into the characters count
        mol_character_end=$Mol_characters
        let "mol_character_end += $taxa_length"
        #Select the first $Mol_characters + $matrix_start_cell characters
        echo $OTU_line | cut -c1-$mol_character_end >> Molecular_block.tmp
        #The next $Morpho_characters are DNA or missing (= morphological matrix)
        #Set the first morphological characters
        first_morpho_character=$mol_character_end
        let "first_morpho_character += 1"
        #Get the last character
        last_character=$mol_character_end
        let "last_character += $Morpho_characters"
        #Select the first $taxa_length characters + the $mol_character_end to the end characters
        echo $OTU_line | cut -c1-$taxa_length -c$first_morpho_character-$last_character >> Morphological_block.tmp
        #be verbose
        printf .
    done
fi
#be verbose
echo "Done"

############################
#Creating the new nexus file
############################
#Header
echo "#NEXUS" > ${chain_name}-part.nex
echo "[Nexus file created using $GARLI_setup_version - $(date)]" >> ${chain_name}-part.nex
echo "" >> ${chain_name}-part.nex
#Taxa block
echo "Begin taxa;" >> ${chain_name}-part.nex
echo "Title Taxa_Block;" >> ${chain_name}-part.nex
echo "Dimension NTAX = ${n_taxa};" >> ${chain_name}-part.nex
echo $taxlabel >> ${chain_name}-part.nex
echo "End;" >> ${chain_name}-part.nex
echo "" >> ${chain_name}-part.nex
#Molecular data block
echo "Begin characters;" >> ${chain_name}-part.nex
echo "Link taxa = Taxa_Block;" >> ${chain_name}-part.nex
echo "Dimensions = ${Mol_characters};" >> ${chain_name}-part.nex
echo "Format Datatype = DNA;" >> ${chain_name}-part.nex
echo "Matrix" >> ${chain_name}-part.nex
cat Molecular_block.tmp >> ${chain_name}-part.nex
echo "End;" >> ${chain_name}-part.nex
echo "" >> ${chain_name}-part.nex
#Morphological data block
echo "Begin characters;" >> ${chain_name}-part.nex
echo "Link taxa = Taxa_Block;" >> ${chain_name}-part.nex
echo "Dimensions = ${Morpho_characters};" >> ${chain_name}-part.nex
echo "Format Datatype = Standard missing = '?';" >> ${chain_name}-part.nex
echo "Matrix" >> ${chain_name}-part.nex
cat Morphological_block.tmp >> ${chain_name}-part.nex
echo "End;" >> ${chain_name}-part.nex
echo "" >> ${chain_name}-part.nex

#Clean temporaries blocks
rm matrix_block.tmp
rm Molecular_block.tmp
rm Morphological_block.tmp

#############################
#Creating the GARLI conf file
#############################

#Setting the evolutionary model for DNA
if echo $Evol_model | grep "HKY" > /dev/null
then
    #if HKY set to 2 rates
    Evol_model="2rate"
else 
    #if GTR set to 6 rates
    Evol_model="6rate"
fi

#Setting the generation threshold for the bootstraps
if echo $bootstraps | grep [1-9] > /dev/null
then
    #threshold is low (1000)
    threshold=1000
    #score is high (0.01)
    score=0.01
else 
    #threshold is default (10000)
    threshold=10000
    #score is default (0.001)
    score=0.001
fi

#If no template is given...
if echo $template | grep "0" > /dev/null
then
    #Default template
    echo "[general]
datafname = ${chain_name}-part.nex
constraintfile = none
streefname = random
attachmentspertaxon = 100
ofprefix = ${chain_name}
randseed = -1
availablememory = 512
logevery = 20
saveevery = 200
refinestart = 1
outputeachbettertopology = 0
outputcurrentbesttopology = 0
enforcetermconditions = 1
genthreshfortopoterm = ${threshold}
scorethreshforterm = ${score}
significanttopochange = 0.01
outputphyliptree = 0
outputmostlyuselessfiles = 0
writecheckpoints = 0
restart = 0
outgroup = ${outgroup}
resampleproportion = 1.0
inferinternalstateprobs = 0
outputsitelikelihoods = 0
optimizeinputonly = 0
collapsebranches = 1

searchreps = 5
bootstrapreps = ${bootstraps}
linkmodels = 0
subsetspecificrates = 1

[model1]
datatype = nucleotide
ratematrix = ${Evol_model}
statefrequencies = estimate
ratehetmodel = gamma
numratecats = ${Mol_ratecat}
invariantsites = estimate

[model2]
datatype = standardvariable
ratematrix = 1rate
statefrequencies = estimate
ratehetmodel = gamma
numratecats = ${Morpho_ratecat}
invariantsites = estimate

[master]
nindivs = 4
holdover = 1
selectionintensity = 0.5
holdoverpenalty = 0
stopgen = 5000000
stoptime = 5000000

startoptprec = 0.5
minoptprec = 0.01
numberofprecreductions = 10
treerejectionthreshold = 50.0
topoweight = 0.01
modweight = 0.002
brlenweight = 0.002
randnniweight = 0.1
randsprweight = 0.3
limsprweight =  0.6
intervallength = 100
intervalstostore = 5
limsprrange = 6
meanbrlenmuts = 5
gammashapebrlen = 1000
gammashapemodel = 1000
uniqueswapbias = 0.1
distanceswapbias = 1.0
" > ${chain_name}.conf

else
    #Replace the following elements in the template file
    sed 's/datafname.*/datafname = '"${chain_name}-part.nex"'/' ${template} |
    sed 's/ofprefix.*/ofprefix = '"${chain_name}"'/' |
    sed 's/genthreshfortopoterm.*/genthreshfortopoterm = '"${threshold}"'/' |
    sed 's/scorethreshforterm.*/scorethreshforterm = '"${score}"'/' |
    sed 's/outgroup.*/outgroup = '"${outgroup}"'/' |
    sed 's/bootstrapreps.*/bootstrapreps = '"${bootstraps}"'/' |
    sed 's/^ratematrix.*/ratematrix = '"${Evol_model}"'/' |
    sed 's/^numratecats.*/numratecats = '"${Mol_ratecat}"'/' |
    sed 's/$numratecats.*/numratecats = '"${Morpho_ratecat}"'/' > ${chain_name}.conf
fi

#End