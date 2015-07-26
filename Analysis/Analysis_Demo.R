# This is a cleaned up a explained version on how the results where obtained for the paper "Effects of missing data on topological 
# inference using a Total Evidence approach"
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
# 3. Calculating the pairwise Bhattacharyya Coefficients between the "best" trees and the "missing data" trees (as outlined in
# figure 2 in the paper)
# 4. Calculating the pairwise Bhattacharyya Coefficients between the methods and the metrics (as outlined in figure 3 in the paper)

# Each function described below has an associated manual at the start of the function files in Functions/TreeComparisons/
# The information contains:
# -The function name
# -A brief function description
# -A version log
# -And a list of requirements


#--------------
# Data
#--------------

# The tree comparisons are available on the following link
browseURL("http://figshare.com/articles/Effect_of_missing_data_on_topological_inference_using_a_total_evidence_approach/1306861")
# The folder containing the tree comparisons is the "Tree_Comparisons.zip" folder.

# The various user functions used for this analysis can be load by sourcing the following file
source("MissingData_fun.R")

# Data can be automatically loaded by running the following script
#source("MissingData_load.R") 
# However, note that this function loads all the data available and can take some time.
# The following indications explain in more details what how the data is loaded and how the metrics can be normalised

#--------------
# 1 - Extracting the tree comparisons from the TreeCmp java script
#--------------

# The tree comparisons are stored in .Cmp files that contain several informations such as the trees that where compared
# and the raw differences between these trees using various metrics.
# All the trees here are compared to the best tree of each chain that is entitled Chain<number>_L00F00C00 where number
# is the number of the chain (from 01 to 50) and L00F00C00 are the different parameters and their different states.
# In the case of the best tree:
# the parameter ML, corresponding to the number of missing living taxa is set at 0%
# the parameter MF, corresponding to the number of missing data in the fossil record is set at 0%
# the parameter MC, corresponding to the number of missing characters from the complete matrix is set at 0%.
# For example, the comparison Chain18_L10F25C50 is the results of the comparison between the best tree of the chain 18
# (Chain18_L00F00C00) and the missing-data tree with the parameters ML=10%, MF=25% and MC=50%.
# These files can be easily converted in a R object called "treeCmp" object that is a concatenation of all the metrics
# for the same tree comparison from the different chain by using the function TreeCmp.Read

# But first, we have to be sure to set the R PATH to the folder containing the .Cmp files.
# For example here, we are going to extract the tree comparisons for the Bayesian consensus trees in the following folder
setwd("../Data/Tree_Comparisons/Bayesian/consensus")

# We can then simply extract the files by specifying the generic chain name to the Read.TreeCmp function:
concatenated_treeCmp_results<-TreeCmp.Read('Chain', verbose=TRUE)

# Once all the comparison has been loaded we need to go back to set the R PATH back to the current directory
setwd("../../../../Analysis")

# The object is a list of each parameter combination that can takes up to several minutes to load
length(concatenated_treeCmp_results)

# Each element corresponds to the difference between the best tree and one of the missing data trees
names(concatenated_treeCmp_results)

# Each element contains the comparisons between the best tree and the element name tree for every chain and every tree
# comparison metric
head(concatenated_treeCmp_results$L10F25C50)

#--------------
# 2. Calculating the normalised metrics and visualising the results (Figure 5 in the paper)
#--------------

# We can then normalised the tree comparison metrics by scaling them with the expected difference between two random trees
# The random tree comparisons are stored as a data frame in the following folder
Random_comparisons<-read.table("../Data/Tree_Comparisons/RandomTrees/51t_Random.Cmp",header=TRUE)

# Note that the data.frame looks similar to the one from the tree comparison but has an extra column RFL which is a metric
# we won't use here.
head(Random_comparisons)

# We can simply remove the RFL
Random_comparisons<-Random_comparisons[,-7]

# We can normalise the metrics using the NTS function by using the observed tree differences and the random tree differences
normalised_treeCmp_results<-NTS(concatenated_treeCmp_results, Random_comparisons)

# The results of the differences are now easier to interpret: 1 means identical trees and 0 means trees no more different than
# random:
head(normalised_treeCmp_results$L10F25C50)

# We can then visualise the result for all the the missing-data trees by using the TreeCmp.Plot function
# Note that this function as many different versions that are used for all the various plots.
# Here we are just going to cover the basics.
# This function calculates the highest density regions using the hdrcde package and plots them for each missing-data tree
# This function has many graphical arguments that are explained in the header of the function source file.
# For this example we are using several intuitive ones:
# -The TreeCmp object
TreeCmp_object<-normalised_treeCmp_results
# -The name of the metric of interest (as in the TreeCmp object)
chosen_metric<-"R.F_Cluster"
# -The confidence intervals
CI<-c(95, 50)

# We can leave all the other options by default except the type of plots (lines=TRUE)
TreeCmp.Plot(TreeCmp=TreeCmp_object, metric=chosen_metric, probs=CI, lines=TRUE)

# For clarity, we can also just plot a subset of parameters, for example, only the trees where the C parameter varies and all the 
# other ones are set to 0. These are the first 5 elements from the TreeCmp object
MC_parameter_only<-normalised_treeCmp_results[1:5]

#However, we need to force this new object to be read as a TreeCmp object using the as.TreeCmp function
MC_parameter_only<-as.TreeCmp(MC_parameter_only)

#We can now plot the subset of parameters with different graphical options
TreeCmp.Plot(TreeCmp=MC_parameter_only, metric=chosen_metric, probs=CI, lines=FALSE, col="red", ylim=c(0,1),
    xaxis=c("0%", "10%", "25%", "50%", "75%"), ylab="Normalised Robinson-Foulds metric", xlab="Missing characters")

#--------------
# 3. Calculating the pairwise Bhattacharyya Coefficients between the "best" trees and the "missing data" trees (as outlined in
# figure 2 in the paper)
#--------------

# The Bhattacharyya Coefficients is the probability of overlap between two distributions, it can be calculated using the
# bhatt.coeff function
bhatt.coeff(rnorm(1000),rnorm(1000))

# Here we want to know the differences between the normalised tree comparisons metrics of each set of parameters.
# We can use the pair.bhatt.coeff function that calculates the pairwise Bhattacharyya Coefficients.
# First, to facilitate the task, we can transform the TreeCmp object directly into a list of distributions for a given metric and
# a given set of parameters using the sub.data function.
MC_parameter_RF_metric<-sub.data(TreeCmp_object, parameter=c(1:5), metric="R.F_Cluster")

# We can then feed this list of distributions to the pair.bhatt.coeff function
pair.bhatt.coeff(MC_parameter_RF_metric, diag=TRUE)

# This outputs a matrix with the probability of overlap between the distributions.
# Note that the diagonal is always equals to 1 and that, in this example, there is a null probability of overlap between
# the normalised Robinson-Foulds metrics between the "best" tree and the two "missing-data" trees with MC=50% and 75%.

# This matrix representation of the probabilities overlaps is understandable when few pairwise comparisons are studied
# but gets more tricky when the number of pairwise comparisons increases.
# For example, if we want to calculate all the pairwise comparisons (7875) the matrix representation is not really helpful.
All_parameter_RF_metric<-sub.data(TreeCmp_object, parameter=c(1:125), metric="R.F_Cluster")
All_parameters_pairwise<-pair.bhatt.coeff(All_parameter_RF_metric, diag=TRUE)
head(All_parameters_pairwise)

# We can use the plot.bhatt.coeff function to represent these results as a heat map.
plot.bhatt.coeff(All_parameters_pairwise, col=c("blue", "orange"), col.grad=c("white", "black"))

#--------------
# 4. Calculating the pairwise Bhattacharyya Coefficients between the methods and the metrics (as outlined in figure 3 in the paper)
#--------------