##########################
#Total Evidence Method simulations
##########################
#SYNTAX:
#sh TEM_treesim.sh [<Living Species> <Input Matrix>] <Molecular characters> <Morphological characters> <Evolutionary model> <Method> <Replicates> <Number of simulations> <Chain name> <CPU>
#with:
#<Living Species> being any entire number of living species to put into the matrices.
#<Input matrix> an optional matrix in phylip format to split. The first species should be the outgroup.
#<Molecular characters> being any entire number of molecular characters to put into the matrices.
#<Morphological characters> being any entire number of morphological characters to put into the matrices. Is ignored if an input matrix is given.
#<Evolutionary model> can be chosen between HKY or GTR as an evolutionary model to build the matrices.
#<Method> can be chosen between ML, Bayesian or Both
#<Replicates> being either a number of bootstraps (if method is ML) or any entire number of mega generations (10e6) (if method is Bayesian). If method is set to both, replicates are set to default of 50.10e6 Bayesian generations and 1000 Bootstraps.
#<Number of simulations> being any entire number of repetitions of the simulations.
#<Chain name> being any string of characters used as the chain name.
#<CPU> number of CPUs available
##########################
#Simulate a Total Evidence Method with variation of three parameters:
#-the number of morphological coded "living" taxa (NL)
#-the number of missing data for the "fossil" taxa (NF)
#-the number of morphological data (NC)
#version: 3.1
TEM_treesim_version="TEM_treesim v3.1"
#Update: Use the full random TEM_matsim.sh script
#Update: Only one outgroup is given in input
#Update: Uses MrBayes
#Update: Build a backbone for MrBayes input
#Update: Evolutionary model for the matrices construction and Bayesian method for the tree construction
#Update: Possibility to chose the method between ML, CON (Bayesian with backbone) or TEM (Bayesian Total Evidence)
#Update: Optional Input file is accepted
#Update: The same evolutionary model is used for building the matrix through Marsim and to run the trees
#Update: Methods are now restricted to ML or Bayesian only
#Update: On the multicore version, the number of runs is fixed a 2 and the number of chains is fixed at 4
#Update: When using Bayesian method, rates are fixed to Gamma distribution with a given alpha prior (normal distribution centred on the given mean with 5% sd) and 4 distinct gamma categories
#Update: When using Bayesian method, the True tree topology simulated by TEM_matsim.sh is given as a starting tree for the MCMC
#Update: Code clean and tidied up
#Update: Script only creates sh executable scripts for building the tree instead of running the trees
#Update: Allow to specify the number of CPU
#Update: Allow to use both Bayesian and ML methods
#TO DO: allow input matrix
#----
#guillert(at)tcd.ie - 17/07/2014
##########################
#Requirements:
#-Shell script TEM_matsim.sh
#-R 3
#-R package "ape"
#-R package "phyclust"
#-R package "diversitree"
#-R package "MCMCpack"
#-seqConverter.pl
#-raxmlHPC-PTHREADS-SSE3
#-MrBayes 3.2.2
##-To install the R packages:
##echo "install.packages(c('ape','phyclust','diversitree','MCMCpack'))" | R --no-save
##########################

#Step 1 - INPUT

#Input values
LivingSp=$1
MolecularChar=$2
MorphologChar=$3
Model=$4
Method=$5
Replicates=$6
Simulations=$7
Chain=$8
CPU=$9


#Creating secondary inputs
#Total number of characters
TotalChar=$MolecularChar
let "TotalChar += $MorphologChar"

#Total number of species
TotalSp=LivingSp                            #Fix this variable !!!
let "TotalSp += LivingSp"
let "TotalSp += 1"

echo "Generating the tree files using $Method method(s):"
#Initializing the loop
for n in $(seq 1 $Simulations)
do
    echo "Saving the first simulation in"
    echo ${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${n}
    #Creates the output folder
    mkdir ${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${n}
    #Copy the TEM_matsim.sh script
    sed 's/Matrix/'"${Chain}${n}"'/g' TEM_matsim.sh | sed 's/Simulation.log/'"${Chain}${n}"'-Simulation.log/g' > ${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${n}/Matsim_${n}.sh
    cd ${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${n}

    #Step 2 - CREATING THE MATRICES

    #Using the TEM_matsim.sh script to create the matrices
    sh Matsim_${n}.sh $LivingSp $MolecularChar $MorphologChar $Model

    #Setting the number of fossil species and updating the total number of species
    FossilSp=$(grep "umber of fossil species = " ${Chain}${n}-Simulation.log | sed 's/Number of fossil species = //g')
    TotalSp=$FossilSp
    let "TotalSp += $LivingSp"
    let "TotalSp += 1"

    #Setting the number of morphological characters for the submatrices (i.e. for the C parameter)
    MolChar1=$MolecularChar
    let "MolChar1 += 1"
    MorphoChar00=$MorphologChar
    let "MorphoChar00 += $MolecularChar"
    MorphoChar10=$MorphologChar
    let "MorphoChar10 *= 90"
    let "MorphoChar10 /= 100"
    let "MorphoChar10 += $MolecularChar"
    MorphoChar25=$MorphologChar
    let "MorphoChar25 *= 75"
    let "MorphoChar25 /= 100"
    let "MorphoChar25 += $MolecularChar"
    MorphoChar50=$MorphologChar
    let "MorphoChar50 *= 50"
    let "MorphoChar50 /= 100"
    let "MorphoChar50 += $MolecularChar"
    MorphoChar75=$MorphologChar
    let "MorphoChar75 *= 25"
    let "MorphoChar75 /= 100"
    let "MorphoChar75 += $MolecularChar"

    #Updating the log file
    #Setting the outgroup
    outgroup=$(sed -n '2p' ${Chain}${n}_L00F00C00.phylip | sed -n 's/\([A-z]*\)[[:space:]].*/\1/p') 

    #Setting the method(s)
    echo "##########################" >> ${Chain}${n}-Simulation.log
    echo "TREE BUILDING" >> ${Chain}${n}-Simulation.log
    echo "Commands generated using $TEM_treesim_version" >> ${Chain}${n}-Simulation.log
    if echo $Method | grep 'Both' > /dev/null
    then
        echo "Both method have been chosen" >> ${Chain}${n}-Simulation.log
        echo "Chosen method = Bayesian" >> ${Chain}${n}-Simulation.log
        echo "Chosen method = ML" >> ${Chain}${n}-Simulation.log
    else
        echo "Chosen method = $Method" >> ${Chain}${n}-Simulation.log
    fi
    echo "Outgroup = $outgroup" >> ${Chain}${n}-Simulation.log
    echo "==========================" >> ${Chain}${n}-Simulation.log
    echo "Number of CPU = $CPU" >> ${Chain}${n}-Simulation.log
    echo "==========================" >> ${Chain}${n}-Simulation.log

    #Setting the replicates (if method=Both)
    if echo $Method | grep 'Both' > /dev/null
    then
        Generations=50000000
        Bootstraps=1000
    else
        if grep 'Chosen method = Bayesian' ${Chain}${n}-Simulation.log  > /dev/null
        then
            Generations=${Replicates}000000
        else
            Bootstraps=$Replicates
        fi
    fi

    #Modifying the matrices for MrBayes (into nexus)

    #Convert to nexus
    if grep 'Chosen method = Bayesian' ${Chain}${n}-Simulation.log > /dev/null
    then

        #Transforming into nexus format
        echo ""
        echo "Creating the nexus files"
        for f in *.phylip
        do
            seqConverter.pl -d${f} -ip -on -ri > /dev/null
            printf .
        done
        echo ""

        #Correcting the nexus files datatype line into partitioned data (depending on seqConverter version?)

        echo "Cheking nexus files"
        #format datatype = protein
        if grep 'format datatype = protein' ${Chain}${n}_L00F00C00.nex > /dev/null

        then
            for f in *C00.nex
            do
                sed 's/format datatype = protein gap = - missing = ?;/format datatype=mixed(DNA:1-'"$MolecularChar"',standard:'"$MolChar1"'-'"$MorphoChar00"') interleave=yes gap=- missing=?;/g' $f > ${f}.tmp
                printf .
            done

            for f in *C10.nex
            do
                sed 's/format datatype = protein gap = - missing = ?;/format datatype=mixed(DNA:1-'"$MolecularChar"',standard:'"$MolChar1"'-'"$MorphoChar10"') interleave=yes gap=- missing=?;/g' $f > ${f}.tmp
                printf .
            done

            for f in *C25.nex
            do
                sed 's/format datatype = protein gap = - missing = ?;/format datatype=mixed(DNA:1-'"$MolecularChar"',standard:'"$MolChar1"'-'"$MorphoChar25"') interleave=yes gap=- missing=?;/g' $f > ${f}.tmp
                printf .
            done

            for f in *C50.nex
            do
                sed 's/format datatype = protein gap = - missing = ?;/format datatype=mixed(DNA:1-'"$MolecularChar"',standard:'"$MolChar1"'-'"$MorphoChar50"') interleave=yes gap=- missing=?;/g' $f > ${f}.tmp
                printf .
            done

            for f in *C75.nex
            do
                sed 's/format datatype = protein gap = - missing = ?;/format datatype=mixed(DNA:1-'"$MolecularChar"',standard:'"$MolChar1"'-'"$MorphoChar75"') interleave=yes gap=- missing=?;/g' $f > ${f}.tmp
                printf .
            done

        else 
            echo 'datatype = protein' > /dev/null
        fi

        #format datatype = nculeotide
        if grep 'format datatype = nucleotide' ${Chain}${n}_L00F00C00.nex >/dev/null

        then
            for f in *C00.nex
            do
                sed 's/format datatype = nucleotide gap = - missing = ?;/format datatype=mixed(DNA:1-'"$MolecularChar"',standard:'"$MolChar1"'-'"$MorphoChar00"') interleave=yes gap=- missing=?;/g' $f > ${f}.tmp
                printf .
            done

            for f in *C10.nex
            do 
                sed 's/format datatype = nucleotide gap = - missing = ?;/format datatype=mixed(DNA:1-'"$MolecularChar"',standard:'"$MolChar1"'-'"$MorphoChar10"') interleave=yes gap=- missing=?;/g' $f > ${f}.tmp
                printf .
            done

            for f in *C25.nex
            do
                sed 's/format datatype = nucleotide gap = - missing = ?;/format datatype=mixed(DNA:1-'"$MolecularChar"',standard:'"$MolChar1"'-'"$MorphoChar25"') interleave=yes gap=- missing=?;/g' $f > ${f}.tmp
                printf .
            done

            for f in *C50.nex
            do
                sed 's/format datatype = nucleotide gap = - missing = ?;/format datatype=mixed(DNA:1-'"$MolecularChar"',standard:'"$MolChar1"'-'"$MorphoChar50"') interleave=yes gap=- missing=?;/g' $f > ${f}.tmp
                printf .
            done

            for f in *C75.nex
            do
                sed 's/format datatype = nucleotide gap = - missing = ?;/format datatype=mixed(DNA:1-'"$MolecularChar"',standard:'"$MolChar1"'-'"$MorphoChar75"') interleave=yes gap=- missing=?;/g' $f > ${f}.tmp
                printf .
            done

        else
            echo 'datatype = nucleotide' > /dev/null
        fi

        #format datatype = DNA
        if grep 'format datatype = DNA' ${Chain}${n}_L00F00C00.nex >/dev/null

        then
            for f in *C00.nex
            do
                sed 's/format datatype = DNA gap = - missing = ?;/format datatype=mixed(DNA:1-'"$MolecularChar"',standard:'"$MolChar1"'-'"$MorphoChar00"') interleave=yes gap=- missing=?;/g' $f > ${f}.tmp
                printf .
            done

            for f in *C10.nex
            do 
                sed 's/format datatype = DNA gap = - missing = ?;/format datatype=mixed(DNA:1-'"$MolecularChar"',standard:'"$MolChar1"'-'"$MorphoChar10"') interleave=yes gap=- missing=?;/g' $f > ${f}.tmp
                printf .
            done

            for f in *C25.nex
            do
                sed 's/format datatype = DNA gap = - missing = ?;/format datatype=mixed(DNA:1-'"$MolecularChar"',standard:'"$MolChar1"'-'"$MorphoChar25"') interleave=yes gap=- missing=?;/g' $f > ${f}.tmp
                printf .
            done

            for f in *C50.nex
            do
                sed 's/format datatype = DNA gap = - missing = ?;/format datatype=mixed(DNA:1-'"$MolecularChar"',standard:'"$MolChar1"'-'"$MorphoChar50"') interleave=yes gap=- missing=?;/g' $f > ${f}.tmp
                printf .
            done

            for f in *C75.nex
            do
                sed 's/format datatype = DNA gap = - missing = ?;/format datatype=mixed(DNA:1-'"$MolecularChar"',standard:'"$MolChar1"'-'"$MorphoChar75"') interleave=yes gap=- missing=?;/g' $f > ${f}.tmp
                printf .
            done

        else
            echo 'datatype = DNA' > /dev/null
        fi

    else
        echo "nothing" > /dev/null
    fi

    #Checking the seqConverter.pl names bug
    rm *.nex
    for f in *.nex.tmp
    do
        prefix=$(basename $f .nex.tmp)
        printf .
        sed 's/\([a-z]\)\([a-z]\)\([0-9]\)\([0-9]\)\([0-9]\)[[:space:]]\([0-9]\)/\1\2\3\4\5\6	/g' $f > ${prefix}.nex
    done
    rm *.nex.tmp

    #Step 3 - RUNNING THE TREES

    #MAXIMUM LIKELIHOOD
    if grep 'Chosen method = ML' ${Chain}${n}-Simulation.log > /dev/null

    then
        #Running ML trees with fast bootstraps
        echo 'ML method' >/dev/null

        #Creating partition set
        echo "DNA, set1 = 1-$MolecularChar" > part00.set
        echo "MULTI, set2 = $MolChar1 - $MorphoChar00" >> part00.set
        echo "DNA, set1 = 1-$MolecularChar" > part10.set
        echo "MULTI, set2 = $MolChar1 - $MorphoChar10" >> part10.set
        echo "DNA, set1 = 1-$MolecularChar" > part25.set
        echo "MULTI, set2 = $MolChar1 - $MorphoChar25" >> part25.set
        echo "DNA, set1 = 1-$MolecularChar" > part50.set
        echo "MULTI, set2 = $MolChar1 - $MorphoChar50" >> part50.set
        echo "DNA, set1 = 1-$MolecularChar" > part75.set
        echo "MULTI, set2 = $MolChar1 - $MorphoChar75" >> part75.set

        #Creating the tree building shell scripts

        echo ""
        echo "Creating the RAxML scripts"

        for f in *C00.phylip
        do
            prefix=$(basename $f .phylip)
            echo "raxmlHPC-PTHREADS-SSE3 -T ${CPU} -f a -s $f -n ${prefix} -m GTRGAMMA -q part00.set -o $outgroup -x 12345 -# $Bootstraps" > ML-${prefix}.sh
            printf .
        done

        for f in *C10.phylip
        do
            prefix=$(basename $f .phylip)
            echo "raxmlHPC-PTHREADS-SSE3 -T ${CPU} -f a -s $f -n ${prefix} -m GTRGAMMA -q part10.set -o $outgroup -x 12345 -# $Bootstraps" > ML-${prefix}.sh
            printf .
        done

        for f in *C25.phylip
        do
            prefix=$(basename $f .phylip)
            echo "raxmlHPC-PTHREADS-SSE3 -T ${CPU} -f a -s $f -n ${prefix} -m GTRGAMMA -q part25.set -o $outgroup -x 12345 -# $Bootstraps" > ML-${prefix}.sh
            printf .
        done

        for f in *C50.phylip
        do
            prefix=$(basename $f .phylip)
            echo "raxmlHPC-PTHREADS-SSE3 -T ${CPU} -f a -s $f -n ${prefix} -m GTRGAMMA -q part50.set -o $outgroup -x 12345 -# $Bootstraps" > ML-${prefix}.sh
            printf .
        done

        for f in *C75.phylip
        do
            prefix=$(basename $f .phylip)
            echo "raxmlHPC-PTHREADS-SSE3 -T ${CPU} -f a -s $f -n ${prefix} -m GTRGAMMA -q part75.set -o $outgroup -x 12345 -# $Bootstraps" > ML-${prefix}.sh
            printf .
        done

        #Saving the scripts, partition sets and phylip matrices in a MLjobs folder

        echo ""
        echo "RAxML scripts saved in:"
        echo "${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${n}_MLjobs"
        echo ""

        mkdir ${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${n}_MLjobs
        mv ML-*.sh ${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${n}_MLjobs/
        mv *.set ${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${n}_MLjobs/
        mv *.phylip ${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${n}_MLjobs/

    else
        echo 'nothing' > /dev/null
    fi

    if grep 'Chosen method = Bayesian' ${Chain}${n}-Simulation.log >/dev/null
    then 
        #BAYESIAN METHOD
        echo 'Updating the nexus files for MrBayes' 

        #Creating the starting tree
        echo "library(ape)
            Start.tree<-read.tree('True_tree.tre')
            Start.tree[[4]]<-rep(1, length(Start.tree[[4]]))
            write.tree(Start.tree, 'Start_tree.tre')" | R --no-save >/dev/null

        StartTree=$(sed -n '1p' Start_tree.tre | sed 's/:1):0;/:1);/g')

        #Adding the starting tree to the nexus files
        for f in *.nex
        do
            echo "Begin trees;
            ">> ${f}
            echo "tree Start_tree = $StartTree
            ">> ${f}
            echo "End;">> ${f}
            printf .
        done

        #Preparing the MrBayes parameters

        echo ""
        echo "Creating the MrBayes command files"

        #Gamma priors (DNA/Morphological)
        DGamma=$(grep "Molecular rates distribution" ${Chain}${n}-Simulation.log | sed 's/Molecular rates distribution (gamma) alpha = //g')
        MGamma=$(grep "Morphological rates distribution" ${Chain}${n}-Simulation.log | sed 's/Morphological rates distribution (gamma) alpha = //g')
       
        #Model (HKY/GTR)
        if grep 'Chosen model = HKY'  ${Chain}${n}-Simulation.log > /dev/null
        then
            nst=$'2'
        else
            nst=$'6'
        fi
       
        #Sampling frequency
        sampling=$(echo "$Generations * 0.0002" | bc | sed 's/\.[0-9]*//g') #5000 sampling
        printing=$(echo "$Generations * 0.001" | bc | sed 's/\.[0-9]*//g') #1000 printing
        diagnosi=$(echo "$Generations * 0.01" | bc | sed 's/\.[0-9]*//g') #100 diagnosis

        #Runs/Chains
        if echo $CPU | grep '1'
        then
            runs=1
            chains=2
        else
            runs=2
            chains=$(echo "$CPU / 2" | bc | sed 's/\.[0-9]*//g')
        fi

        #Creating the mrbayes.cmd template
        echo "begin mrbayes;" > base-cmd.tmp
        echo "[Data input]" >> base-cmd.tmp
        echo "set autoclose=yes nowarn=yes;" >> base-cmd.tmp
        echo "log start filename=<CHAIN>.log;" >> base-cmd.tmp
        echo "execute <CHAIN>.nex;" >> base-cmd.tmp
        echo "charset DNA = 1-$MolecularChar;" >> base-cmd.tmp
        echo "charset morphology = $MolChar1-<NUMBER>;" >> base-cmd.tmp
        echo "partition favored = 2: DNA, morphology;" >> base-cmd.tmp
        echo "set partition = favored;" >> base-cmd.tmp
        echo "" >> base-cmd.tmp
        echo "[Model settings]" >> base-cmd.tmp
        echo "outgroup $outgroup ;" >> base-cmd.tmp
        echo "prset applyto=(1) Shapepr=Exponential($DGamma) Tratiopr = beta(80,40);" >> base-cmd.tmp
        echo "prset applyto=(2) Shapepr=Exponential($MGamma);" >> base-cmd.tmp
        echo "lset applyto=(1) nst=${nst} rates=gamma Ngammacat=4;" >> base-cmd.tmp
        echo "lset applyto=(2) nst=1 rates=gamma Ngammacat=4;" >> base-cmd.tmp
        echo "" >> base-cmd.tmp
        echo "[MCMC settings]" >> base-cmd.tmp
        echo "startvals tau=Start_tree V=Start_tree ;" >> base-cmd.tmp
        echo "mcmc nruns=${runs} Nchains=${chains} ngen=${Generations} samplefreq=${sampling} printfreq=${printing} diagnfreq=${diagnosi} Stoprule=YES stopval=0.01 mcmcdiagn=YES file=<CHAIN>;" >> base-cmd.tmp
        echo "sump Filename=<CHAIN> Relburnin=YES Burninfrac=0.25;" >> base-cmd.tmp
        echo "sumt Filename=<CHAIN> Relburnin=YES Burninfrac=0.25;" >> base-cmd.tmp
        echo "end;" >> base-cmd.tmp

        #Giving the <CHAIN> and <NUMBER> arguments function of the input nexus file
        for f in *C00.nex
        do
            prefix=$(basename $f .nex)
            sed 's/<CHAIN>/'"${prefix}"'/g' base-cmd.tmp | sed 's/<NUMBER>/'"$MorphoChar00"'/g' > ${prefix}.cmd
            printf .
        done

        for f in *C10.nex
        do
            prefix=$(basename $f .nex)
            sed 's/<CHAIN>/'"${prefix}"'/g' base-cmd.tmp | sed 's/<NUMBER>/'"$MorphoChar10"'/g' > ${prefix}.cmd
            printf .
        done

        for f in *C25.nex
        do
            prefix=$(basename $f .nex)
            sed 's/<CHAIN>/'"${prefix}"'/g' base-cmd.tmp | sed 's/<NUMBER>/'"$MorphoChar25"'/g' > ${prefix}.cmd
            printf .
        done

        for f in *C50.nex
        do
            prefix=$(basename $f .nex)
            sed 's/<CHAIN>/'"${prefix}"'/g' base-cmd.tmp | sed 's/<NUMBER>/'"$MorphoChar50"'/g' > ${prefix}.cmd
            printf .
        done

        for f in *C75.nex
        do
            prefix=$(basename $f .nex)
            sed 's/<CHAIN>/'"${prefix}"'/g' base-cmd.tmp | sed 's/<NUMBER>/'"$MorphoChar75"'/g' > ${prefix}.cmd
            printf .
        done

        #Deleting the template and the start tree
        rm base-cmd.tmp
        rm Start_tree.tre

        echo ""
        echo "MrBayes command files saved in:"
        echo "${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${n}_MLjobs"
        echo ""

        #Saving the command files and the nexus matrices in a Bayesianjobs folder
        mkdir ${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${n}_Bayesianjobs
        mv *.cmd ${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${n}_Bayesianjobs/
        mv *.nex ${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${n}_Bayesianjobs/

    else
        echo 'nothing' > /dev/null
    fi

    #Step 4 - CLEANING

    rm Matsim_${n}.sh
    mv True_tree.tre ${Chain}${n}-True_tree.tre
    mv randoms.tar ${Chain}${n}-randoms.tar

    #Closing the loop
    cd ..
    
done

echo "${n} Chains generated with ${Method} script files."
echo "To run the trees, use:"
echo ""
if echo $Method | grep 'Both' > /dev/null
then
    echo "for simulations in $seq(1 ${n}) ; do for script in ${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${simulations}_MLjobs/*.sh ; do sh $script ; done ; done"
    echo ""
    echo "for simulations in $seq(1 ${n}) ; dofor command in ${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${simulations}_Bayesianjobs/*.cmd ; do mb $command ; done ; done"
    echo ""
else
    if echo $Method | grep 'ML' > /dev/null
    then
        echo "for simulations in $seq(1 ${n}) ; do for script in ${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${simulations}_MLjobs/*.sh ; do sh $script ; done ; done"
        echo ""
    else
        echo "for simulations in $seq(1 ${n}) ; dofor command in ${TotalSp}t_${TotalChar}c_${Model}_${Method}_${Chain}${simulations}_Bayesianjobs/*.cmd ; do mb $command ; done ; done"
        echo ""
    fi
fi
echo "Or use TEM_tasker.sh script."



#end