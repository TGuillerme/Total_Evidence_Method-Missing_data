# Effect of missing data on topological inference using a total evidence approach
[Thomas Guillerme](http://tguillerme.github.io) and [Natalie Cooper](https://www.tcd.ie/Zoology/research/ncooper/nataliecooper.php).

This repository contains all the code and data used in the manuscript.
###### Manuscript in prep.

## Manuscript
The latest presubmition version of the manuscript can be obtained in [pdf here](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/blob/master/Manuscript/TEM_draft.pdf) or built from the LaTeX file in [this folder](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Manuscript).

## Data
The data is not yet uploaded online but will be available soon.

#####True trees
To be hosted online soon...
#####Missing data trees
To be hosted online soon...
#####Tree comparisons
To be hosted online soon...


## Analysis
This section contains details on the code used to run the analysis as detailed in the paper.
####Building the "complete" phylogenies and removing the data (`shell`)
* (1) We randomly generated a birth-death tree (the "true" tree) and used it to infer a matrix with no missing data (the "complete" matrix).

* (2) We removed data from the morphological part of the "complete" matrix resulting in 125 "missing-data" matrices.

Both operations can be performed using the `TEM_matsim.sh` code in the function folder, [tree building section](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Functions/TreeBuilding). The syntax used is:

`sh TEM_mastsim.sh <Living Species> <Molecular characters> <Morphological characters> <Evolutionary model>`

with:
* `<Living Species>` being any entire number of living species to put into the matrices.
* `<Molecular characters>` being any entire number of molecular characters to put into the matrices.
* `<Morphological characters>` being any entire number of morphological characters to put into the matrices.
* `<Evolutionary model>` can be chosen between HKY or GTR as an evolutionary model to build the matrices. Is ignored if an input matrix is given.

For example, in our simulations:
```
sh TEM_matsim.sh 25 1000 100 HKY
```
This will generate a "True" tree, 125 phylip matrices with various amounts of missing data and save all the random values (birth-death, morphological rates, etc...).

####Building the phylogenies (`shell` - RAxML & MrBayes)
(3) We built phylogenetic trees from each matrix using both Maximum Likelihood and Bayesian methods.
The two previous steps (1 & 2) and this one can be wrapped in the `TEM_treesim.sh` code in the function folder, [tree building section](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Functions/TreeBuilding). The syntax used is:

`sh TEM_treesim.sh <Living Species> <Molecular characters> <Morphological characters> <Evolutionary model> <Method> <Replicates> <Number of simulations> <Chain name> <CPU>`

with:
* the first 4 arguments beeing indentical as above (passed to `TEM_matsim.sh`)
* `<Method>` can be chosen between ML, Bayesian or Both
* `<Replicates>` being either a number of bootstraps (if method is ML) or any entire number of mega generations (10e6) (if method is Bayesian). If method is set to both, replicates are set to default of 50.10e6 Bayesian generations and 1000 Bootstraps.
* `<Number of simulations>` being any entire number of repetitions of the simulations.
* `<Chain name>` being any string of characters used as the chain name.
* `<CPU>` number of CPUs available

For example, in our simulations:
```
sh TEM_matsim.sh 25 1000 100 HKY ML 1000 1 Dummy_chain_name 8
```
This will generate a "True" tree, 125 phylip matrices with various amounts of missing data and save all the random values (birth-death, morphological rates, etc...) and an additional 125 `RAxML` or `MrBayes` scripts. It is then possible to run the 125 `RAxML` or `MrBayes` scripts individually.

To facilitate this operation, we created a script to generate task files to run on a computer cluster using the `TEM_tasker.sh` script available in the function folder, [tree building section](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Functions/TreeBuilding). This is designed for 8 CPU. The syntax is:

`sh TEM_treesim.sh <Chain names> <method> <modulelist> <split>`

with:
* `<chain>` the name of the chain to generate task files for
* `<method>` ML or Bayesian
* `<modules.list>` a text file containing the list of modules to load before submitting the individual jobs
* `<split>` a value between 1 and 5 for splitting the jobs (1=1 job: 5 tasks, 5=1 job: 1 task)
```
sh TEM_tasker.sh Dummy_chain_name ML modules.list.txt 5
```

####Comparing the trees (`shell` & `R`)
(4) We compared the "missing-data" trees to the "best" tree.

#####TreeCmp wrapper
See code in the function folder, [tree building section](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Functions/TreeComparisons).
```
shell example (soon)
```

#####R analysis
See code in the function folder, [tree building section](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Functions/TreeComparisons).
```
R example (soon)
```
