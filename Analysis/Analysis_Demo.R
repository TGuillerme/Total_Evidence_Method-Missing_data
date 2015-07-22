# This is a cleaned up a explained version on how the results where obtained for the paper "Effects of missing data on topological inference using a Total Evidence approach"
# Please email me any questions or query (guillert@tcd.ie).

# The whole analysis is divided in four parts
# A. Generating the matrix
# B. Removing data
# C. Estimating phylogenies
# D. Comparing topologies
# The three first parts of the analysis are time consuming (~150 CPU years) and therefore not covered in this demo.
# However you can find explanations and details about the code used in these parts in the README.md file link to this repository.
# This part only covers the analysis ran in R and will be outlined as follows
# 1. Extracting the tree comparisons from the TreeCmp java script.
# 2. Calculating the normalised metrics and visualising the results (Figure 5 in the paper)
# 3. Calculating the pairwise Bhattacharyya Coefficients between the "best" trees and the "missing data" trees (as outlined in figure 2 in the paper)
# 4. Calculating the pairwise Bhattacharyya Coefficients between the methods and the metrics (as outlined in figure 3 in the paper)