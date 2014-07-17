##########################
#Total Evidence Method simulations tasks generator
##########################
#SYNTAX:
#sh TEM_tasker.sh <chain> <method> <moduleslist>
#with:
#<chain> the name of the chain to generate task files for
#<method> ML or Bayesian
#<modules.list> a text file containing the list of modules to load before submitting the individual jobs
#########################
#version 2.0
TEM_tasker_version="TEM_tasker v2.0"
#Generates the job files for running the simulation on a cluster
#Update: Now creates a series of 25 jobs to submit
#Update: Updated to use mpirun on the new version of the cluster
#
#----
#guillert(at)tcd.ie - 16/07/2014
##########################
#Requirements:
#-raxmlHPC-PTHREADS-SSE3
#-MrBayes 3.2.1
##########################

#Input values
chain=$1
method=$2
moduleslist=$3

#Initializing the loop
for folder in *${chain}*
do
    cd ${folder}
    #Extracting the chain number ($n in TEM_treesim)
    n=$(echo ${folder} | sed 's/.*'"${chain}"'//g')
    #Setting the CPU variable from the log file
    CPU=$(grep 'Number of CPU =' ${chain}${n}-Simulation.log | sed 's/Number of CPU = //g')

    #CREATING THE JOB FILES

    #Bayesian method
    if echo $method | grep 'Bayesian' > /dev/null
    then

        #Creating the job.template file
        echo '/#!/bin/sh' | sed 's/\/\#!/\#!/g' > job.template
        echo "#SBATCH -n ${CPU}" >> job.template
        echo "#SBATCH -t 4-00:00:00" >> job.template   #Future update? Being able to set the time
        echo "#SBATCH -p compute" >> job.template
        echo "#SBATCH -J <JOBNAME>-Bayesian" >> job.template
        echo "" >> job.template
        cat ../$moduleslist >> job.template
        echo "\n\n##########################" >> job.template
        echo "#TASK FILE <NTASK> - ${chain}${n}" >> job.template
        echo "##########################\n" >> job.template    
        echo "cd ${folder}_Bayesianjobs" >> job.template
        echo "mpirun -np $CPU mb ${Chain}${n}_L00<SUFFIX>.cmd ;" >> job.template   
        echo "mpirun -np $CPU mb ${Chain}${n}_L10<SUFFIX>.cmd ;" >> job.template   
        echo "mpirun -np $CPU mb ${Chain}${n}_L25<SUFFIX>.cmd ;" >> job.template   
        echo "mpirun -np $CPU mb ${Chain}${n}_L50<SUFFIX>.cmd ;" >> job.template   
        echo "mpirun -np $CPU mb ${Chain}${n}_L75<SUFFIX>.cmd ;" >> job.template   
        echo "cd ../" >> job.template
        printf .

        #Creating the list of chain suffix (*_L*F*C*.cmd)
        echo -e "F00C00\nF10C00\nF25C00\nF50C00\nF75C00" > suffix.list
        echo -e "F00C10\nF10C10\nF25C10\nF50C10\nF75C10" >> suffix.list
        echo -e "F00C25\nF10C25\nF25C25\nF50C25\nF75C25" >> suffix.list
        echo -e "F00C50\nF10C50\nF25C50\nF50C50\nF75C50" >> suffix.list
        echo -e "F00C75\nF10C75\nF25C75\nF50C75\nF75C75" >> suffix.list
        printf .

        #Creating the 25 jobs for the whole chain (25*5)
        for task in $(seq -w 1 25)
        do
            SUFFIX=$(sed -n ''"$task"'p' suffix.list)
            JOBNAME=C${n}-T${task}
            sed 's/<NTASK>/'"${task}"'/g' job.template | sed 's/<SUFFIX>/'"${SUFFIX}"'/g' | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task}.job
            printf .
        done

        #Cleaning
        rm job.template ; rm suffix.list
        printf .

    #ML method
    else

        #Creating the job.template file
        echo '/#!/bin/sh' | sed 's/\/\#!/\#!/g' > job.template
        echo "#SBATCH -n ${CPU}" >> job.template
        echo "#SBATCH -t 4-00:00:00" >> job.template   #Future update? Being able to set the time
        echo "#SBATCH -p compute" >> job.template
        echo "#SBATCH -J <JOBNAME>-ML" >> job.template
        echo "" >> job.template
        cat ../$moduleslist >> job.template
        echo "\n\n##########################" >> job.template
        echo "#TASK FILE <NTASK> - ${chain}${n}" >> job.template
        echo "##########################\n" >> job.template    
        echo "cd ${folder}_MLjobs" >> job.template
        printf .

        #Creating the list of scripts
        ls ${folder}_MLjobs/ML-*.sh | sed s/^.*\\/\// | sed 's/^/sh /' > script.list
        printf .

        #Creating the 5 jobs for the whole chain (5*25)
        task=(1 2 3 4 5)
        start=(1 26 51 76 101)
        end=(25 50 75 100 125)

        for ((i = 0; i < 5; i++)) 
        do 
            JOBNAME=C${n}-T${task[i]}
            sed 's/<NTASK>/'"${task[i]}"'/g' job.template | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task[i]}.job
            sed -n ''"${start[i]}"','"${end[i]}"'p' script.list >> ${chain}${n}_${task[i]}.job
            echo "cd ../" >> ${chain}${n}_${task[i]}.job
            printf .
        done

        #Cleaning
        rm job.template ; rm script.list
        printf .
    fi

    echo "\nJob files ready for ${Chain}${n} in ${method} framework."
    cd ..

done

echo 'Next step:'
echo "for f in *.job ; do echo $f ; sbatch $f ; done ;"
#End
