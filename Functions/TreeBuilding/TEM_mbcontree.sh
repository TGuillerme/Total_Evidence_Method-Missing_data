##########################
#MrBayes post-analysis consensus trees 
##########################
#SYNTAX:
#sh TEM_mbcontree.sh <folder> <chain>
#with:
#<folder> the name of the folder containing the *.run*.t, *.nex and the *.log files
#########################
#version 0.1
TEM_mbcontree_version="TEM_mbcontree v0.1"
#Generates the consensus tree in a chain using the run*.t files
#
#----
#guillert(at)tcd.ie - 30/07/2014
##########################
#Requirements:
#-MrBayes 3.2.1
#-*.run*.t, *.nex and the *.log files
##########################

#Input values
folder=$1
chain=$2

#Initializing the loop
cd $folder
#Generating the template file for calculating the consensus tree in MrBayes
echo "set autoclose=yes nowarn=yes;
execute <PREFIX>;
sumt Relburnin=YES Burninfrac=0.25;" > contree.template


#Extracting the chain names for generating the consensus trees (Analysis must be completed and consensus tree must be absent)
for f in *$chain*.log
do
    prefix=$(basename $f .log)

    #Analysis must be completed ?
    if grep 'Analysis completed' ${prefix}.log > /dev/null
    then
        #Consensus tree must be absent ?
        if ls ${prefix}.* | grep .con.tre > /dev/null
        then
            #Is the consensus tree empty (bug) ?
            if grep '#NEXUS' ${prefix}.con.tre > /dev/null
            then
                echo "${prefix}.con.tre already exist" > /dev/null
            else

                #removing the bugged con.tre file
                rm ${prefix}.con.tre

                #Create the consensus tree in mrBayes
                #removing the suffix of the nexus matrix
                cp ${prefix}.nex ${prefix}
                #Adding the prefix to the template file
                sed 's/<PREFIX>/'"${prefix}"'/g' contree.template > ${prefix}.contree
                #Running mrbayes
                echo "Generating the consensus tree..."
                mb ${prefix}.contree > /dev/null
                echo "${prefix}.con.tre successfully created"
                #Removing the temporary nexus file
                rm ${prefix}

            fi

        else
        
            #Create the consensus tree in mrBayes
            #removing the suffix of the nexus matrix
            cp ${prefix}.nex ${prefix}
            #Adding the prefix to the template file
            sed 's/<PREFIX>/'"${prefix}"'/g' contree.template > ${prefix}.contree
            #Running mrbayes
            echo "Generating the consensus tree..."
            mb ${prefix}.contree > /dev/null
            echo "${prefix}.con.tre successfully created"
            #Removing the temporary nexus file
            rm ${prefix}

        fi

    else
        echo "No completed analysis found" > /dev/null
    fi        
done

rm contree.template

cd ..