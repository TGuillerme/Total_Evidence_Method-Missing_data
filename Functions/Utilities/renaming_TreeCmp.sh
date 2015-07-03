#Script for renaming TreeCmp meta files

#Bayesian

for n in $(seq -w 01 50)
do
    echo Chain${n}:

    #Select the header
    sed -n '1p' Chain${n}-Bayesian-single-true.Cmp > HEADER

    #Get the total number of lines
    tot_lines=$(wc -l Chain${n}-Bayesian-single-true.Cmp | sed 's/Chain'"${n}"'-Bayesian-single-true.Cmp//g')

    #Loop through each line to create the file
    for line in $(seq 2 $tot_lines)
    do
        #Select the tree name
        tree=$(sed -n ''"${line}"'p' Chain${n}-Bayesian-single-true.Cmp | sed 's/Chain'"${n}"'-Truee[[:space:]]Chain'"${n}"'_//g' | sed 's/[[:space:]][0-9].*//g')

        #Creating the new file
        cat HEADER > Chain${n}_${tree}.Cmp
        sed -n ''"${line}"'p' Chain${n}-Bayesian-single-true.Cmp | sed 's/Chain'"${n}"'-Truee/1/g' | sed 's/Chain'"${n}"'_'"${tree}"'/1/g' >> Chain${n}_${tree}.Cmp
        printf .
    done

    echo "Done."
done

rm HEADER


#ML

for n in $(seq -w 01 50)
do
    echo Chain${n}:

    #Select the header
    sed -n '1p' Chain${n}-ML-single-true.Cmp > HEADER

    #Get the total number of lines
    tot_lines=$(wc -l Chain${n}-ML-single-true.Cmp | sed 's/Chain'"${n}"'-ML-single-true.Cmp//g')

    #Loop through each line to create the file
    for line in $(seq 2 $tot_lines)
    do
        #Select the tree name
        tree=$(sed -n ''"${line}"'p' Chain${n}-ML-single-true.Cmp | sed 's/Chain'"${n}"'-Truee[[:space:]]Chain'"${n}"'_//g' | sed 's/[[:space:]][0-9].*//g')

        #Creating the new file
        cat HEADER > Chain${n}_${tree}.Cmp
        sed -n ''"${line}"'p' Chain${n}-ML-single-true.Cmp | sed 's/Chain'"${n}"'-Truee/1/g' | sed 's/Chain'"${n}"'_'"${tree}"'/1/g' >> Chain${n}_${tree}.Cmp
        printf .
    done

    echo "Done."
done


rm HEADER
