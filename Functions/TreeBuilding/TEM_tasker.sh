##########################
#Total Evidence Method simulations tasks generator
##########################
#SYNTAX:
#sh TEM_tasker.sh <chain> <method> <moduleslist> <split>
#with:
#<chain> the name of the chain to generate task files for
#<method> ML or Bayesian
#<modules.list> a text file containing the list of modules to load before submitting the individual jobs
#<split> a value between 1 and 5 for splitting the jobs (1=1 job: 5 tasks, 5=1 job: 1 task)
#########################
#version 2.2
TEM_tasker_version="TEM_tasker v2.2"
#Generates the job files for running the simulation on a cluster
#Update: Now creates a series of 25 jobs to submit
#Update: Updated to use mpirun on the new version of the cluster
#Update: Typo in the chain variable
#Update: Added a split option
#To do: fix this option for ML
#----
#guillert(at)tcd.ie - 11/08/2014
##########################

#Input values
chain=$1
method=$2
moduleslist=$3
split=$4

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
        if echo $split | grep '1' > ./dev/null
        then
            echo '/#!/bin/sh' | sed 's/\/\#!/\#!/g' > job.template
            echo "#SBATCH -n ${CPU}" >> job.template
            echo "#SBATCH -t 4-00:00:00" >> job.template   #Future update? Being able to set the time
            echo "#SBATCH -p compute" >> job.template
            echo "#SBATCH -J <JOBNAME>-Bayesian" >> job.template
            echo "" >> job.template
            cat ../$moduleslist >> job.template
            echo "" >> job.template
            echo "##########################" >> job.template
            echo "#TASK FILE <NTASK> - ${chain}${n}" >> job.template
            echo "##########################" >> job.template    
            echo "cd ${folder}_Bayesianjobs" >> job.template
            echo "mpirun -np $CPU mb ${chain}${n}_L00<SUFFIX>.cmd ;" >> job.template   
            echo "mpirun -np $CPU mb ${chain}${n}_L10<SUFFIX>.cmd ;" >> job.template   
            echo "mpirun -np $CPU mb ${chain}${n}_L25<SUFFIX>.cmd ;" >> job.template   
            echo "mpirun -np $CPU mb ${chain}${n}_L50<SUFFIX>.cmd ;" >> job.template   
            echo "mpirun -np $CPU mb ${chain}${n}_L75<SUFFIX>.cmd ;" >> job.template   
            echo "cd ../" >> job.template
            printf .
        fi

        if echo $split | grep '2' > ./dev/null
        then
            echo '/#!/bin/sh' | sed 's/\/\#!/\#!/g' > job.template
            echo "#SBATCH -n ${CPU}" >> job.template
            echo "#SBATCH -t 4-00:00:00" >> job.template   #Future update? Being able to set the time
            echo "#SBATCH -p compute" >> job.template
            echo "#SBATCH -J <JOBNAME>-Bayesian" >> job.template
            echo "" >> job.template
            cat ../$moduleslist >> job.template
            echo "" >> job.template
            echo "##########################" >> job.template
            echo "#TASK FILE <NTASK> - ${chain}${n}" >> job.template
            echo "##########################" >> job.template    
            echo "cd ${folder}_Bayesianjobs" >> job.template
            cp job.template > job1.template
            mv job.template > job2.template
            echo "mpirun -np $CPU mb ${chain}${n}_L00<SUFFIX>.cmd ;" >> job1.template   
            echo "mpirun -np $CPU mb ${chain}${n}_L10<SUFFIX>.cmd ;" >> job1.template
            echo "cd ../" >> job1.template
            echo "mpirun -np $CPU mb ${chain}${n}_L25<SUFFIX>.cmd ;" >> job2.template   
            echo "mpirun -np $CPU mb ${chain}${n}_L50<SUFFIX>.cmd ;" >> job2.template   
            echo "mpirun -np $CPU mb ${chain}${n}_L75<SUFFIX>.cmd ;" >> job2.template   
            echo "cd ../" >> job2.template
            printf .
        fi

        if echo $split | grep '3' > ./dev/null
        then
            echo '/#!/bin/sh' | sed 's/\/\#!/\#!/g' > job.template
            echo "#SBATCH -n ${CPU}" >> job.template
            echo "#SBATCH -t 4-00:00:00" >> job.template   #Future update? Being able to set the time
            echo "#SBATCH -p compute" >> job.template
            echo "#SBATCH -J <JOBNAME>-Bayesian" >> job.template
            echo "" >> job.template
            cat ../$moduleslist >> job.template
            echo "" >> job.template
            echo "##########################" >> job.template
            echo "#TASK FILE <NTASK> - ${chain}${n}" >> job.template
            echo "##########################" >> job.template    
            echo "cd ${folder}_Bayesianjobs" >> job.template
            cp job.template > job1.template
            cp job.template > job2.template
            mv job.template > job3.template
            echo "mpirun -np $CPU mb ${chain}${n}_L00<SUFFIX>.cmd ;" >> job1.template 
            echo "cd ../" >> job1.template
            echo "mpirun -np $CPU mb ${chain}${n}_L10<SUFFIX>.cmd ;" >> job2.template
            echo "mpirun -np $CPU mb ${chain}${n}_L25<SUFFIX>.cmd ;" >> job2.template
            echo "cd ../" >> job2.template
            echo "mpirun -np $CPU mb ${chain}${n}_L50<SUFFIX>.cmd ;" >> job3.template   
            echo "mpirun -np $CPU mb ${chain}${n}_L75<SUFFIX>.cmd ;" >> job3.template   
            echo "cd ../" >> job3.template
            printf .
        fi

        if echo $split | grep '4' > ./dev/null
        then
            echo '/#!/bin/sh' | sed 's/\/\#!/\#!/g' > job.template
            echo "#SBATCH -n ${CPU}" >> job.template
            echo "#SBATCH -t 4-00:00:00" >> job.template   #Future update? Being able to set the time
            echo "#SBATCH -p compute" >> job.template
            echo "#SBATCH -J <JOBNAME>-Bayesian" >> job.template
            echo "" >> job.template
            cat ../$moduleslist >> job.template
            echo "" >> job.template
            echo "##########################" >> job.template
            echo "#TASK FILE <NTASK> - ${chain}${n}" >> job.template
            echo "##########################" >> job.template    
            echo "cd ${folder}_Bayesianjobs" >> job.template
            cp job.template > job1.template
            cp job.template > job2.template
            cp job.template > job3.template
            mv job.template > job4.template
            echo "mpirun -np $CPU mb ${chain}${n}_L00<SUFFIX>.cmd ;" >> job1.template 
            echo "cd ../" >> job1.template
            echo "mpirun -np $CPU mb ${chain}${n}_L10<SUFFIX>.cmd ;" >> job2.template
            echo "cd ../" >> job2.template
            echo "mpirun -np $CPU mb ${chain}${n}_L25<SUFFIX>.cmd ;" >> job3.template
            echo "cd ../" >> job3.template
            echo "mpirun -np $CPU mb ${chain}${n}_L50<SUFFIX>.cmd ;" >> job4.template  
            echo "mpirun -np $CPU mb ${chain}${n}_L75<SUFFIX>.cmd ;" >> job4.template   
            echo "cd ../" >> job4.template
            printf .
        fi

        if echo $split | grep '5' > ./dev/null
        then
            echo '/#!/bin/sh' | sed 's/\/\#!/\#!/g' > job.template
            echo "#SBATCH -n ${CPU}" >> job.template
            echo "#SBATCH -t 4-00:00:00" >> job.template   #Future update? Being able to set the time
            echo "#SBATCH -p compute" >> job.template
            echo "#SBATCH -J <JOBNAME>-Bayesian" >> job.template
            echo "" >> job.template
            cat ../$moduleslist >> job.template
            echo "" >> job.template
            echo "##########################" >> job.template
            echo "#TASK FILE <NTASK> - ${chain}${n}" >> job.template
            echo "##########################" >> job.template    
            echo "cd ${folder}_Bayesianjobs" >> job.template
            cp job.template > job1.template
            cp job.template > job2.template
            cp job.template > job3.template
            cp job.template > job4.template
            mv job.template > job5.template
            echo "mpirun -np $CPU mb ${chain}${n}_L00<SUFFIX>.cmd ;" >> job1.template 
            echo "cd ../" >> job1.template
            echo "mpirun -np $CPU mb ${chain}${n}_L10<SUFFIX>.cmd ;" >> job2.template
            echo "cd ../" >> job2.template
            echo "mpirun -np $CPU mb ${chain}${n}_L25<SUFFIX>.cmd ;" >> job3.template
            echo "cd ../" >> job3.template
            echo "mpirun -np $CPU mb ${chain}${n}_L50<SUFFIX>.cmd ;" >> job4.template
            echo "cd ../" >> job4.template
            echo "mpirun -np $CPU mb ${chain}${n}_L75<SUFFIX>.cmd ;" >> job5.template   
            echo "cd ../" >> job5.template
            printf .
        fi

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
            if echo $split | grep '1' > ./dev/null
            then
                sed 's/<NTASK>/'"${task}"'/g' job.template | sed 's/<SUFFIX>/'"${SUFFIX}"'/g' | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task}.job
                printf .
            fi
            if echo $split | grep '2' > ./dev/null
            then
                sed 's/<NTASK>/'"${task}"'/g' job1.template | sed 's/<SUFFIX>/'"${SUFFIX}"'/g' | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task}_1.job
                sed 's/<NTASK>/'"${task}"'/g' job2.template | sed 's/<SUFFIX>/'"${SUFFIX}"'/g' | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task}_2.job
                printf .
            fi 
            if echo $split | grep '3' > ./dev/null
            then
                sed 's/<NTASK>/'"${task}"'/g' job1.template | sed 's/<SUFFIX>/'"${SUFFIX}"'/g' | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task}_1.job
                sed 's/<NTASK>/'"${task}"'/g' job2.template | sed 's/<SUFFIX>/'"${SUFFIX}"'/g' | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task}_2.job
                sed 's/<NTASK>/'"${task}"'/g' job3.template | sed 's/<SUFFIX>/'"${SUFFIX}"'/g' | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task}_3.job
                printf .
            fi 
            if echo $split | grep '4' > ./dev/null
            then
                sed 's/<NTASK>/'"${task}"'/g' job1.template | sed 's/<SUFFIX>/'"${SUFFIX}"'/g' | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task}_1.job
                sed 's/<NTASK>/'"${task}"'/g' job2.template | sed 's/<SUFFIX>/'"${SUFFIX}"'/g' | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task}_2.job
                sed 's/<NTASK>/'"${task}"'/g' job3.template | sed 's/<SUFFIX>/'"${SUFFIX}"'/g' | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task}_3.job
                sed 's/<NTASK>/'"${task}"'/g' job4.template | sed 's/<SUFFIX>/'"${SUFFIX}"'/g' | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task}_4.job
                printf .
            fi 
            if echo $split | grep '5' > ./dev/null
            then
                sed 's/<NTASK>/'"${task}"'/g' job1.template | sed 's/<SUFFIX>/'"${SUFFIX}"'/g' | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task}_1.job
                sed 's/<NTASK>/'"${task}"'/g' job2.template | sed 's/<SUFFIX>/'"${SUFFIX}"'/g' | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task}_2.job
                sed 's/<NTASK>/'"${task}"'/g' job3.template | sed 's/<SUFFIX>/'"${SUFFIX}"'/g' | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task}_3.job
                sed 's/<NTASK>/'"${task}"'/g' job4.template | sed 's/<SUFFIX>/'"${SUFFIX}"'/g' | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task}_4.job
                sed 's/<NTASK>/'"${task}"'/g' job5.template | sed 's/<SUFFIX>/'"${SUFFIX}"'/g' | sed 's/<JOBNAME>/'"${JOBNAME}"'/g' > ${chain}${n}_${task}_5.job
                printf .
            fi                       
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
        echo "##########################" >> job.template
        echo "#TASK FILE <NTASK> - ${chain}${n}" >> job.template
        echo "##########################" >> job.template    
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

    echo "\nJob files ready for ${chain}${n} in ${method} framework."
    cd ..

done

echo 'Next step:'
echo "for f in *.job ; do echo $f ; sbatch $f ; done ;"
#End
