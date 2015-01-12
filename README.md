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
#####Generating the
To be hosted online soon...
#####Tree comparisons
To be hosted online soon...


## Analysis
This section contains details on the code used to run the analysis as detailed in the paper.
####Building the "complete" phylogenies and removing the data (`shell`)
(1) We randomly generated a birth-death tree (the "true" tree) and used it to infer a matrix with no missing data (the "complete" matrix).

See code in the function folder, [tree building section](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Functions/TreeBuilding).
```
shell example (soon)
```

(2) We removed data from the morphological part of the "complete" matrix resulting in 125 "missing-data" matrices.

See code in the function folder, [tree building section](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Functions/TreeBuilding).
```
shell example (soon)
```

####Building the phylogenies (`shell` - RAxML & MrBayes)
(3) We built phylogenetic trees from each matrix using both Maximum Likelihood and Bayesian methods.
See code in the function folder, [tree building section](https://github.com/TGuillerme/Total_Evidence_Method-Missing_data/tree/master/Functions/TreeBuilding).
```
shell example (soon)
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
