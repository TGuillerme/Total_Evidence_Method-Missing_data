##########################
#Bhattacharyya Coefficient of two distributions
##########################
#Calculates the Bhattacharyya Coefficient (BC) between two distributions:
#BC is the sum of the square root of the multiplication of the elements in bin i for both distributions.
#It ranges from 0 (no overlap) to 1 (full overlap).
#v.0.1
##########################
#SYNTAX :
#<x>    a numeric vector of length >= 2.
#<y>    a numeric vector of length >= 2.
#<bw>   can be either a fixed value of bins or a function to calculate the bandwidth of each bin (see ?bw.nrd). Default is bw.nrd0.
#<...>  any optional arguments to be passed to the given bw function.
##########################c
#----
#guillert(at)tcd.ie - 28/11/2014
##########################
#Requirements:
#-R 3
##########################

bhatt.coeff<-function(x,y, bw=bw.nrd0, ...) {

    #SANITIZING
    #x
    if(class(x) != 'numeric') {
        stop("'x' must be numeric.")
    }
    if(length(x) < 2) {
        stop("'x' need at least two data points.")
    }

    #y
    if(class(y) != 'numeric') {
        stop("'y' must be numeric.")
    }
    if(length(y) < 2) {
        stop("'y' need at least two data points.")
    }

    #bw
    if(length(bw) != 1) {
        stop("'bw' must be either a single numeric value or a single function.")   
    }
    if(class(bw) != 'function') {
        if(class(bw) != 'numeric') {
            stop("'bw' must be either a single numeric value or a single function.")   
        }
    }
    #Avoiding non-entire numbers
    if(class(bw) == 'numeric') {
        bw<-round(bw)
    }

    #BHATTACHARYYA COEFFICIENT
    #sum(sqrt(x relative counts in bin_i * y relative counts in bin_i))

    #Setting the right number of bins (i)
    if(class(bw) == 'function') {
        #Bin width
        band.width<-bw(c(x,y), ...)
        #Bin breaks
        bin.breaks<-seq(from=min(c(x,y)), to=max(c(x,y)+band.width), by=band.width) #adding an extra bandwith to the max to be sure to include all the data
        #Number of bins
        bin.n<-length(bin.breaks)-1
    } else {
        #Bin breaks
        bin.breaks<-hist(c(x,y), breaks=bw, plot=F)$breaks
        #Bin width
        band.width<-diff(bin.breaks)[1]
        #Number of bins
        bin.n<-bw
    }

    #Counting the number of elements per bin
    histx<-hist(x, breaks=bin.breaks, plot=FALSE)[[2]]
    histy<-hist(y, breaks=bin.breaks, plot=FALSE)[[2]]
    #Relative counts
    rel.histx<-histx/sum(histx)
    rel.histy<-histy/sum(histy)
    
    #Calculating the Bhattacharyya Coefficient (sum of the square root of the multiple of the relative counts of both distributions)
    bhatt.coeff<-sum(sqrt(rel.histx*rel.histy))
    return(bhatt.coeff)
#End
}

##########################
#Pairwise Bhattacharyya Coefficient
##########################
#Calculates the pairwise Bhattacharyya Coefficient for n distributions
#v.0.1
##########################
#SYNTAX :
#<X>    a list of vectors
#<bw>   can be either a fixed value of bins or a function to calculate the bandwidth of each bin (see ?bw.nrd). Default is bw.nrd0.
#<diag> logical, whether to compute the Bhattacharyya Coefficient for the same distributions (=1). Default=FALSE.
#<...>  any optional arguments to be passed to the given bw function.
##########################c
#----
#guillert(at)tcd.ie - 28/11/2014
##########################
#Requirements:
#-R 3
##########################

pair.bhatt.coeff<-function(X, bw=bw.nrd0, diag=FALSE, ...) {
    #DEBUG
    debug=FALSE
    if(debug == FALSE) {
        tab.ex<-replicate(5, rnorm(1000))
        X<-list(tab.ex[,1], tab.ex[,3], tab.ex[,3], tab.ex[,4], tab.ex[,5])
        X<-list(rnorm(1000, 0), rnorm(985, 1), rnorm(1250,2), rnorm(800,3), rnorm(1000, 10))
        diag=FALSE
        bw=bw.nrd0
    }

    #SANITIZING
    #X
    if(class(X) != 'list') {
        stop("'X' must be a list of vectors.")
    }

    #diag
    if(class(diag) != 'logical') {
        stop("'diag' must be logical.")
    }

    #PAIRWISE COMPARISONS
    #number of elements in the list
    N<-length(X)

    #Creating the empty matrix
    mat<-matrix(NA, N, N)
    #Adding row names if available in the matrix
    colnames(mat) <- row.names(mat) <- names(X)
    #Creating a vector of the empty cells
    cells<-as.vector(mat)

    #Selecting the lower triangle
    sub<-lower.tri(mat, diag = diag)

    #Bhatt.coeff function in a matrix
    bhatt.coeff.mat<-function(x,y, sub, mat, bw, ...) {
        if(sub[x,y]==TRUE) {
            mat[x,y]<<-bhatt.coeff(X[[x]],X[[y]], bw, ...)
        } else {
            mat[x,y]<<-NA
        }
    }

    #Looping through rows and columns
    for(x in 1:N) {
        for(y in 1:N) {
            bhatt.coeff.mat(x,y, sub, mat, bw, ...)
        }
    }

    return(mat)
#End
}