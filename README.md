# Effects of missing data on topological inference using a Total Evidence approach
[Thomas Guillerme](http://tguillerme.github.io) and [Natalie Cooper](https://http://nhcooper123.github.io/).

This repository contains all the code and data used in this study.
###### Paper [published](http://www.sciencedirect.com/science/article/pii/S1055790315002547) in Molecular Phylogenetics and Evolution.<a href="http://www.sciencedirect.com/science/article/pii/S1055790315002547"><img src="http://tguillerme.github.io/images/OA.png" height="20" widht="20"/></a> <a href="https://scholar.google.com/citations?view_op=view_citation&hl=en&user=LA9l9EkAAAAJ&citation_for_view=LA9l9EkAAAAJ:zYLM7Y9cAGgC"><img src="http://tguillerme.github.io/images/logo-GS.png" height="20" widht="20"/></a>

## Data <a href="http://figshare.com/articles/Effect_of_missing_data_on_topological_inference_using_a_total_evidence_approach/1306861"><img src="http://tguillerme.github.io/images/logo-FS.png" height="26" widht="26"/></a> 
All the data is available on [figshare](http://figshare.com/articles/Effect_of_missing_data_on_topological_inference_using_a_total_evidence_approach/1306861).

#####True trees
The "True" trees are available in the `True_trees.zip` file.
#####Missing data trees
The missing data trees are available in the `ML_trees.zip` and `ChainX_Bayesian.zip` files.
#####Tree comparisons
The tree comparisons results are available in the `Tree_Comparisons.zip` file.

Note that because of the size of the data files (33.55 GB in total) and the limitations of the size of the files uploadable on figshare, the zip files are split in roughly 200 MB files. Several solutions exist to unzip the whole files (such as [The Unarchiver](http://wakaba.c3.cx/s/apps/unarchiver.html)).
Some files might have been corrupted while uploading. We are currently trying to find a better solution to store all the data but in the mean time, please [email me](mailto:guillert@tcd.ie) if you find a corrupted file.

#### R data
You can also use the pre-analysed data in [this folder](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Data/R_data).


## Analysis
The whole analysis is divided in four parts:

* A. Generating the matrix
* B. Removing data
* C. Estimating phylogenies
* D. Comparing topologies

The three first parts of the analysis are time consuming (~150 CPU years). Examples of the scripts and functions to use are outlined below. The final part is divided in two sub parts, one involving `shell` and `java` scripts (outlined below) and a second one involving `R` scripts and functions (outlined at the end of this README file).

However, a quick go through demo is available [here](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/blob/master/Analysis/Analysis_Demo.R) as an `R` script. This part covers in a more thorough way the following points
* 1. Extracting the tree comparisons from the TreeCmp java script.
* 2. Calculating the normalised metrics and visualising the results (Figure 5 in the paper)
* 3. Calculating the pairwise Bhattacharyya Coefficients between the "best" trees and the "missing data" trees (as outlined in figure 2 in the paper)
* 4. Calculating the pairwise Bhattacharyya Coefficients between the methods and the metrics (as outlined in figure 3 in the paper)

### Part A and B
#### Building the "complete" phylogenies and removing the data (`shell`)
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

### Part C
#### Building the phylogenies (`shell` - RAxML & MrBayes)
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
### Part D
#### Comparing the trees (`shell` & `R`)
* (4) We compared the "missing-data" trees to the "best" tree.

This operation is run in two steps, the first one, using a `java` script to compare the trees and the second one using a `R` script to analyse the results. The code for both operations in available in the function folder, [tree comparisons section](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Functions/TreeComparisons).

##### TreeCmp wrapper
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

##### R analysis

###### A quick go through demonstration is available [here](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/blob/master/Analysis/Analysis_Demo.R).

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
Additional analysis has been run in the Appendices:
* [Morphological characters states](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/blob/master/Analysis/MorphologicalCharacterStates.R), in Appendix A: extracting the proportion of 2 states and 3 states characters from empirical data (for `UNIX` based machines only; LINUX/MAC).
* [Starting tree effect](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/blob/master/Analysis/Starting_tree.R), in Appendix A: measuring the effect of using the "true" tree or not as a starting tree for the MCMC.
* [Morphological rates estimations](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/blob/master/Analysis/Rates_estimates.R), in Appendix A: effect of missing data on the posterior alpha parameter estimation (for `UNIX` based machines only; LINUX/MAC).
* [Differences between the "true" and "best" trees](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/blob/master/Analysis/True_vs_best_tree.R), in Appendix B: measuring the ability of recovering the "true" tree (i.e. the pseudo-random seed for each simulation chain).
* [Marginal probabilities](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/blob/master/Analysis/Marginal_probabilities.R) in Appendix C: calculating the marginal distribution of each missing data parameter individually and each method.

## Citation
If you are using this code, please cite:

* Guillerme, T. & Cooper, N. (**2015**). Effects of missing data on topological inference using a Total Evidence approach. Molecular Phylogenetics and Evolution. doi:10.1016/j.ympev.2015.08.023

[Citation formats](http://www.sciencedirect.com/science/article/pii/S1055790315002547)
