#Extracting the proportion of character states from 100 matrices.

#Transform the matrices using the MatRead.sh script file
warning("UNIX based computers only.")
system('sh ../Functions/MatRead.sh ../Data/100_Matrices')

#Load the matrices from the "transformed_mat" folder (just generated from above)

setwd("transformed_matrices/")

#Empty list
tab<-list() #rep('NA',length(list.files(pattern='.mat')))

for (i in 1:length(list.files())) {
	try(tmp<-read.table(list.files()[i], sep=' ',header=F), silent=TRUE)
	try(tab.tmp<-rep(NA, ncol(tmp)), silent=TRUE)	
	for (j in 1:ncol(tmp)) {
		#Isolating the number of levels excluding "?" and odd ones
		try(tab.tmp[j]<-length(grep('[0-9]', levels(as.factor(tmp[,j])))), silent=TRUE)
	}
	try(tab[[i]]<-tab.tmp, silent=TRUE)
}
	
setwd("..")

#Remove the generated folder
system('rm -R transformed_matrices/')


#Creating the states vector excluding chacters 0 | 1 |>10
mat<-unlist(tab)
matr<-mat[-c(which(mat == 0 | mat == 1 | mat > 10))]

#Plotting the results
states_probabilities<-hist(matr, breaks=c(1,2,3,4,5,6,7,8,9,10), plot=FALSE)$counts/length(matr)
barplot(states_probabilities, xlab="Number of character states", ylab="Probabilities", names.arg=c("2","3","4","5","6","7","8","9","10"))

#Saving the results
#pdf("../Manuscript/Figures/Supplementary/TEM_Fig-AppendixCharacters.pdf")
#barplot(states_probabilities, xlab="Number of character states", ylab="Probabilities", names.arg=c("2","3","4","5","6","7","8","9","10"), main="")
#dev.off()
