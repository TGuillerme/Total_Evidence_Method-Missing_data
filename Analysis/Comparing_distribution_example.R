#This is a script to illustrate the difference between using a t-test and the Bhattacharyya Coefficient.

#####################
#Sourcing the Bhattacharyya Coefficient from GitHub
#####################

#Installing RCurl package
install.packages("RCurl")

#Source GitHub function
source_github <- function(u) {
  # load package
  require(RCurl)
  # read script lines from website and evaluate
  script <- getURL(u, ssl.verifypeer = FALSE)
  eval(parse(text = script))
}  

#Sourcing the Bhattacharyya Coefficient function (bhatt.coeff)
source_github("https://raw.githubusercontent.com/TGuillerme/Total_Evidence_Method-Missing_data/master/Functions/TreeComparisons/bhatt.coef.R")

#####################
#Generating the two distributions
#####################

#Setting seed for reproducibility
set.seed(12345)

#Generating the two normal distribution with a sd of 1 and a slightly different mean (1/20 of the sd) with 50000 data points each
#This corresponds to the number of tree comparisons between two distributions for the Maximum Likelihood boostraps trees or the Bayesian posterior distribution trees
distribution_1<-rnorm(50000, mean=0.05, sd=1)
distribution_2<-rnorm(50000, mean=0, sd=1)

#####################
#Calculating the differences between both distribution
#####################

#Differences between the means (classic t-test)
t_test_results<-t.test(distribution_1, distribution_2)
#Isolating difference
difference<-sqrt((t_test_results$estimate[[1]])^2-(t_test_results$estimate[[2]])^2)
#Isolating the p-value
p_value<-t_test_results$p.value

#Calculating the Bhattacharyya Coefficient (the probability of the two distributions being the same) 
bhatt_coeff<-bhatt.coeff(distribution_1, distribution_2)

#####################
#Plotting the results
#####################

#Graphical options
op<-par(bty="l")

#Plotting the first distribution
plot(density(distribution_1), col="red", main="", xlab="Values")
#Plotting the second distribution
lines(density(distribution_2), col="blue")

#Adding the calculated differences
text(3, 0.4, "Difference between means (t-test):", cex=0.8)
text(3, 0.388, paste(round(difference, digit=3), " ; p-value = ", round(p_value, digit=19), sep=""), cex=0.8)
text(3, 0.35, "Probability of distribution overlap\n(Bhattacharyya Coefficient):", cex=0.8)
text(3, 0.328, round(bhatt_coeff, digit=3), cex=0.8)
