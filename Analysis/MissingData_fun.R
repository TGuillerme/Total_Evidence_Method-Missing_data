#Data loading for Total Evidence Missing Data Analysis
setwd('~/PhD/Projects/Total_Evidence_Method-Missing_data/Analysis/')


#######################
#Loading the functions
#######################

sourceDir <- function(path, trace = TRUE, ...) {
    for (nm in list.files(path, pattern = "[.][RrSsQq]$")) {
    if(trace) cat(nm,":")
        source(file.path(path, nm), ...)
        if(trace) cat("\n")
    }
}
sourceDir(path="../Functions/TreeComparisons/")
library(ape)
