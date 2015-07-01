# Effect of missing data on topological inference using a total evidence approach
[Thomas Guillerme](http://tguillerme.github.io) and [Natalie Cooper](https://http://nhcooper123.github.io/).

This repository contains all the code and data used in the manuscript.
###### Manuscript in review in Molecular Phylogenetics and Evolution.

## Manuscript
The latest version of the manuscript is available in the Manuscript folder.

To compile the paper:

```
make -C Manuscript
```

## Data
All the data is available on [figshare](http://figshare.com/articles/Effect_of_missing_data_on_topological_inference_using_a_total_evidence_approach/1306861).

#####True trees
The "True" trees are available in the `True_trees.zip` file.
#####Missing data trees
The missing data trees are available in the `ML_trees.zip` and `ChainX_Bayesian.zip` files.
#####Tree comparisons
The tree comparisons results are available in the `Tree_Comparisons.zip` file.

Note that because of the size of the data files (33.55 GB in total) and the limitations of the size of the files uploadable on figshare, the zip files are split in roughly 200 MB files.

## Analysis
This folder contains details on the code used to run the analyses as detailed in the paper.
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
* (3) We built phylogenetic trees from each matrix using both Maximum Likelihood and Bayesian methods.
The two previous steps (1 & 2) and this one can be wrapped in the `TEM_treesim.sh` code in the function folder, [tree building section](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Functions/TreeBuilding). The syntax used is:

`sh TEM_treesim.sh <Living Species> <Molecular characters> <Morphological characters> <Evolutionary model> <Method> <Replicates> <Number of simulations> <Chain name> <CPU>`

with:
  * the first 4 arguments being identical as above (passed to `TEM_matsim.sh`)
  * `<Method>` can be chosen between ML, Bayesian or Both
  * `<Replicates>` being either a number of bootstraps (if method is ML) or any entire number of mega generations (10e6) (if method is Bayesian). If method is set to both, replicates are set to default of 50.10e6 Bayesian generations and 1000 Bootstraps.
  * `<Number of simulations>` being any entire number of repetitions of the simulations.
  * `<Chain name>` being any string of characters used as the chain name.
  * `<CPU>` number of CPUs available

For example, in our simulations:
```
sh TEM_matsim.sh 25 1000 100 HKY ML 1000 1 Dummy_chain_name 8
```
This will generate a "true" tree, 125 phylip matrices with various amounts of missing data and save all the random values (birth-death, morphological rates, etc...) and an additional 125 `RAxML` or `MrBayes` scripts. It is then possible to run the 125 `RAxML` or `MrBayes` scripts individually.

To facilitate this operation, we created a script to generate task files to run on a computer cluster using the `TEM_tasker.sh` script available in the function folder, [tree building section](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Functions/TreeBuilding). This is designed for 8 CPU. The syntax is:

`sh TEM_treesim.sh <Chain names> <method> <modulelist> <split>`

with:
  * `<chain>` the name of the chain to generate task files for
  * `<method>` ML or Bayesian
  * `<modules.list>` a text file containing the list of modules to load before submitting the individual jobs
  * `<split>` a value between 1 and 5 for splitting the jobs (1=1 job: 5 tasks, 5=1 job: 1 task)

For example, in our simulations:
```
sh TEM_tasker.sh Dummy_chain_name ML modules.list.txt 5
```

####Comparing the trees (`shell` & `R`)
* (4) We compared the "missing-data" trees to the "best" tree.

This operation is run in two steps, the first one, using a `java` script to compare the trees and the second one using a `R` script to analyse the results. The code for both operations in available in the function folder, [tree comparisons section](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Functions/TreeComparisons).

#####TreeCmp wrapper
The first step is using the `TreeCmp.jar` script to compare the trees. We created a wrapping `shell` script to automate the task that is available in the [TreeCmp-shell folder](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Functions/TreeComparisons/TreeCmp-Shell). The `TEM_TreeCmp_wrapper.sh` script work as follow:

`sh TEM_TreeCmp_wrapper.sh <list> <x> <method> <type>`

with:
  * `<list>` the list of chains numbers
  * `<x>` the number of chains
  * `<method>` either Bayesian or ML
  * `<type>` either single or treeset

For example, in our simulations:
```
sh TEM_TreeCmp_wrapper.sh Dummy_chain_name 1 ML single
```
This operation will perform single tree comparisons between the `RAxML_besttree` with no missing data and the 125 `RAxML_besttree` trees (including the one with no missing data).

#####R analysis
Finally we ran a series of analyses presented in the final manuscript version using the various `R` scripts available in the [analysis folder](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Analysis).

The first step is to load the various functions stored in the [tree comparisons folder](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Functions/TreeComparisons/) in `R`.
```
load("MissingData_fun.R")
```
After that, various analyses can be run as follow:

  * [Generating/loading the data](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/blob/master/Analysis/MissingData_load.R)
  * [Calculating the differences between methods or parameters](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/blob/master/Analysis/MissingData_differences.R)
  * [Visualising the effect of missing data](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/blob/master/Analysis/MissingData_plot.R)
  * [Summarizing the tree comparisons metrics](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/blob/master/Analysis/MissingData_modetable.R)

#####Supplementary analysis
An additional analysis has been run in the online Appendix 1 to determine the frequency of character states per simulated morphological characters. The whole analysis can be run on UNIX based machines (LINUX/MAC) through the [following code](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/blob/master/Analysis/MorphologicalCharacterStates.R).
