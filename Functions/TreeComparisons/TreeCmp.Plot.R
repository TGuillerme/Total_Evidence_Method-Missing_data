##########################
#Plot TreeCmp output
##########################
#Calculate the CI and the mode of a given metric using TreeCmp class objects
#Function modified from sumBTC (guillert(at)tcd.ie - 19/02/2014)
#v.2.1
#Update: the three core functions have been isolated
#Update: in FUN.hdr, allows to read TreeCmp from similar tree comparison (NTS=1), setting $hdr and $alpha to NA and $mode to 1 if var(TreeCmp) == 0
#Update: in FUN.densityplot, allows to plot TreeCmp from similar tree comparison (NTS=1), ignoring $hdr and $alpha and ploting only the mode (=1)
#Update: the number of probabilities level don't need to be 3 any more
#Update: colours are now accepted
#Update: results can be plotted as lines
#Update: allow to stack the plots with add=TRUE
#Update: allow window scaling option (ylim)
#Update: typo in as.data.frame - fixed colour of single points
#Update: allowed optional arguments to the plot function
#Update: changed the shift option to work also for single points
#Update: is now more plastic for using the optional plot(...) arguments
##########################
#SYNTAX :
#<TreeCmp> an object of the class TreeCmp
#<metric> the name of the metric of interest
#<probs> a vector probabilities levels (default = c(95,75,50)).
#<plot> whether to plot the results or not (default = TRUE).
#<col> a colour for the ploting (default="black"). Is ignored if plot=FALSE.
#<lines> whether to plot the results as lines instead than as boxplots (default=FALSE). Is ignored if plot=FALSE.
#<add> whether to add to the current plot (default=FALSE). Is ignored if plot=FALSE.
#<shift> a numerical value between 0 and 0.6 for shifting the lines. Is ignored if plot=FALSE, lines=FALSE, add=FALSE.
#<ylim> two numerical values to scale the y axis of the plot. If set to 'auto' (default), the window is automatically scaled with the minimum and the maximum value from the TreeCmp.
#<xlab> and <ylab> the labels names, can be a user value or set to 'auto' (default). Can be ignored if NULL. Is ignored if plot=FALSE.
#<xaxis> the labels to be plotted on the x axis (default = NULL). Is ignored if xlab is set to 'auto'.
#<save.details> whether to save the details of each comparison (default=FALSE). If TRUE, saves a density plot for each comparison. The chain name will be the one given in 'TreeCmp'. Is ignored if plot=FALSE.
#<...> any optional arguments to be passed to plot()
##########################
#----
#guillert(at)tcd.ie - 24/11/2014
##########################
#Requirements:
#-R 3
#-R package 'hdrcde'
#-R TreeCmp objects
##########################

TreeCmp.Plot<-function(TreeCmp, metric, probs=c(95, 75, 50), plot=TRUE, col='black', lines=FALSE, add=FALSE, shift=0, ylim='auto', save.details=FALSE, xaxis='auto', ylab='auto', xlab=NULL, ...) {
#HEADER

#Loading the libraries
    require(hdrcde)

#SANITIZING

    #TreeCmp
    if(class(TreeCmp) != 'TreeCmp') {
        stop('TreeCmp is not a "TreeCmp" object')
    } else {
        TreeCmp.length<-length(TreeCmp)
        if(TreeCmp.length == 0) {
            stop('The provided "TreeCmp" object is empty')
        } else {
            TreeCmp.columns<-length(TreeCmp[[1]])
            if(TreeCmp.columns == 0) {
                stop('The provided "TreeCmp" object is empty')
            }
        }
    }

    #metric
    if(class(metric) != 'character') {
        stop('Provided metric name is not found in the "TreeCmp" object')
    } else {
        if(length(metric) != 1) {
            stop('Only one metric name can be provided')
        } else {
            metric.column<-grep(metric, colnames(TreeCmp[[1]]))
            if(length(metric.column) == 0) {
                stop('Provided metric name is not found in the "TreeCmp" object')
            } else {
                TreeCmp.rows<-NULL
                for (i in 1:TreeCmp.length) {
                    TreeCmp.rows[i]<-length(TreeCmp[[i]][,metric.column])
                }
            }
        }
    }

    #probs
    if(class(probs) != 'numeric'){
        stop('Probs are not numeric')
    }

    #plot
    if(class(plot) != 'logical'){
        stop('Plot is not logical')
    }

    #col
    if(class(col) != 'character'){
        stop('Unknown color')
    } else {
        border<-col
    }

    #lines
    if(class(lines) != 'logical'){
        stop('Lines is not logical')
    }

    #add
    if(class(add) != 'logical'){
        stop('Lines is not logical')
    }

    #shift
    if(plot==TRUE){
        if(lines==TRUE){
            if(add==TRUE){
                if(class(shift) != 'numeric'){
                    stop('Shift value must be within the interval [0:0.6]')
                }
                if(shift > 0.6 ){
                    stop('Shift value must be within the interval [0:0.6]')
                }
                if(shift < 0){
                    stop('Shift value must be within the interval [0:0.6]')
                }
            } else {shift=0}
        } else {shift=0}
    } else {shift=0}

    #ylim
    options(warn=-1) #no warn
    if(ylim != 'auto'){
        if(class(ylim) == 'numeric'){
            if(length(ylim) != 2){
                stop('ylim must be a vector of two numerical values')
            }
        } else {
            stop('ylim must be a vector of two numerical values')
        }
    }

    #xaxis, xlab and ylab
    if(plot==TRUE) {
        if(is.null(xaxis)) {
            xaxis<-NULL
        } else {
            if(xaxis != 'auto') {
                if(class(xaxis) != 'character') {
                    stop('xaxis must be a character string')
                }
            }
        }
        if(is.null(ylab)) {
            ylab<-NULL
        } else {
            if(ylab != 'auto') {
                if(class(ylab) != 'character') {
                    stop('ylab must be a character string')
                }
            }
        }
        if(!is.null(xaxis)) {
            if(xaxis == 'auto') {
                xlab<-NULL
            } else {
                if(!is.null(xlab)) {
                    if(class(xlab) != 'character') {
                        stop('xlab must be a character string')
                    }
                }
            }
        }
    }
    options(warn=1)

    #save.details
    if(class(save.details) != 'logical'){
        stop('Save.details is not logical')
    }
    if(save.details == TRUE){
        cat('Save.details options is enabled and will generate a pdf file for each comparison', '\n')
        cat('This options might increase the computational time','\n')
    }
    
#FUNCTIONS

    #Calculates the hdr for each comparison set
    FUN.hdr<-function(TreeCmp, metric.column, probs) {
        hdr.results<-NULL

        for (i in 1:length(TreeCmp)) {
            if(var(TreeCmp[[i]][,metric.column]) == 0) {
                #If no variance, make the results equal to 1
                hdr.results[[i]]<-list(hdr=NA,mode=1,alpha=NA)
            } else {
                #Else calculate the normal hdr
                hdr.results[[i]]<-hdr(TreeCmp[[i]][,metric.column], probs, h = bw.nrd0(TreeCmp[[i]][,metric.column]))  #problem with bw.nrd0?
            }
        }

        names(hdr.results)<-names(TreeCmp)

        return(hdr.results)
    }

    #Density Plot function (from densityplot.R by Andrew Jackson - a.jackson@tcd.ie)
    FUN.densityplot<-function (TreeCmp, metric.column, TreeCmp.rows, probs, hdr.results, border, lines, add, shift, ylim, ylab, xaxis, ...) {

        #Transform dat into a column format
        dat<-matrix(NA, nrow=max(TreeCmp.rows), ncol=TreeCmp.length)
        dat<-as.data.frame(dat)
        for (i in 1:length(TreeCmp)) {
            #The number of rows in the TreeCmp frame is equal to the maximum number of rows in the list. If the elements in the list don't have the same number of rows, NAs are added.
            dat[,i]<-c(TreeCmp[[i]][,metric.column], rep(NA,(max(TreeCmp.rows)-length(TreeCmp[[i]][,metric.column]))))
        }

        #Renaming dat
        names(dat)<-names(TreeCmp)

        #Set the column numbers
        n<-ncol(dat)

        #Set the y axis as the label name
        options(warn=-1) #no warn
        if(is.null(ylab)) {
            ylabels=''
        } else {
            if(ylab == 'auto') {
                ylabels<-colnames(TreeCmp[[1]][metric.column])
            } else {
                ylabels<-ylab
            }
        }

        #Set the x axis values 
        if(is.null(xaxis)) {
            xlabels=rep('',n)
        } else {
            if(xaxis == 'auto') {
                xlabels<-as.character(names(dat))
            } else {
                xlabels<-xaxis
            }
        }
        options(warn=1)

        #Set up the plot
        if (add==FALSE) {

            #Setting ylim if 'auto'
            options(warn=-1) #no warn
            if(ylim == 'auto') {
                ylims<-c(min(dat, na.rm=TRUE) - 0.1*min(dat, na.rm=TRUE), max(dat, na.rm=TRUE) + 0.1*(max(dat, na.rm=TRUE)))
            } else {
            #Fixed ylim
                ylims<-ylim
            }
            options(warn=1)
            xspc<-0.5
            
            #plotting the plot frame with the ylabels and xlabels
            if(is.null(xlab)) {
                if(is.null(ylab)) {
                    plot(1,1, xlab='', ylab='', xlim= c(1 - xspc, n + xspc), ylim=ylims, type='n', xaxt='n', yaxt='n', ...)
                    axis(side = 2, col.axis='white')
                } else {
                    plot(1,1, xlab='', ylab=ylabels, xlim= c(1 - xspc, n + xspc), ylim=ylims, type='n', xaxt='n', ...)
                }
            } else {
                if(is.null(ylab)) {
                    plot(1,1, xlab=xlab, ylab='', xlim= c(1 - xspc, n + xspc), ylim=ylims, type='n', xaxt='n', yaxt='n', ...)
                    axis(side = 2, col.axis='white')
                } else {
                    plot(1,1, xlab=xlab, ylab=ylabels, xlim= c(1 - xspc, n + xspc), ylim=ylims, type='n', xaxt='n', ...)
                }                
            }

            #Adding xlabels
            if(is.null(xaxis)){
                axis(side = 1, at = 1:n, labels=xlabels, cex=0.75)
            } else {
                options(warn=-1) #no warn
                if(xaxis=='auto') {
                    axis(side = 1, at = 1:n, labels=xlabels, las=2, cex=0.75)
                } else {
                    axis(side = 1, at = 1:n, labels=xlabels, las=1, cex=0.75)
                }
                options(warn=1)
            }

        }

        #Set the colors (grayscale)
        clr = gray((9:1)/10)
        clrs <- rep(clr, 5)

        #Plotting the TreeCmp distribution

        #disable warnings if one hdr value = NA
        options(warn=-1)

        for (j in 1:n) {
            temp <- hdr.results[[j]]
            line_widths <- seq(2, 20, by = 4)
            bwd <- c(0.1, 0.15, 0.2, 0.25, 0.3)

            for (k in 1:length(probs)) {
                if(is.na(temp$hdr)) {
                    #Ploting only the mode if hdr=NA
                    if(lines==FALSE) {
                        #Points with no shift
                        points(j,temp$mode,pch=19, col=border)
                    } else {
                        #Points with shift
                        points(j+shift,temp$mode,pch=19, col=border)
                    }

                } else {

                    #Plot the probabilities distribution
                    temp2 <- temp$hdr[k, ]

                    #Lines options
                    if(lines==FALSE) {
                        polygon(c(j - bwd[k], j - bwd[k], j + bwd[k], j + bwd[k]), c(min(temp2[!is.na(temp2)]), max(temp2[!is.na(temp2)]), max(temp2[!is.na(temp2)]), min(temp2[!is.na(temp2)])), col = clrs[k], border=border)
                    } else {
                        lines(c(j+shift,j+shift), c(min(temp2[!is.na(temp2)]), max(temp2[!is.na(temp2)])), lwd=1+(k*2-2), lty=(length(probs)-(k-1)), col=border)  
                    }
                    points(j+shift,temp$mode,pch=19, col=border)
                }
            }
        }
        #enable warnings
        options(warn=1)
    }  

    #Saves the details for each comparison (graph and values)
    FUN.details.save<-function(TreeCmp, metric.column, probs) {
        #Compute hdr for one metric
        hdr.saving<-NULL

        for (i in 1:length(TreeCmp)) {
            pdf(paste(names(TreeCmp[i]), colnames(TreeCmp[[1]][metric.column]), 'pdf', sep='.'))
            hdr.saving[[i]]<-hdr.den(TreeCmp[[i]][,metric.column], prob=probs, xaxis=colnames(TreeCmp[[1]][metric.column]), main=paste(names(TreeCmp[i]), 'comparison',sep=' '))
            dev.off()
            cat(paste(names(TreeCmp[i]), colnames(TreeCmp[[1]][metric.column]), 'pdf', sep='.'), 'density plot saved', '\n')
        }

        #rename the list
        names(hdr.saving)<-paste(names(TreeCmp),colnames(TreeCmp[[1]][metric.column]), sep='.')
    }

#SUMMARIZE THE LIST

    #Calculate the hdr for each comparion
    hdr.results<-FUN.hdr(TreeCmp, metric.column, probs)

    #Optional plot
    if (plot == TRUE) {
        FUN.densityplot(TreeCmp, metric.column, TreeCmp.rows, probs, hdr.results, border, lines, add, shift, ylim, ylab, xaxis, ...)
    }

    #Optional saving
    if (save.details == TRUE) {
        FUN.details.save(TreeCmp, metric.column, probs)
    }

    #Output
    return(hdr.results)

#End
}

##########################
#Plot multiple TreeCmp plots
##########################
#v.0.2
##########################
#SYNTAX :
#<data.list> a character list of the different datasets to plot
#<parameters> a numerical list of parameters to select per dataset
#<metrics> the list of metrics
#<col> the colour palette matching the list
#<...> any optional arguments to be passed to TreeCmp.Plot()
##########################
#----
#guillert(at)tcd.ie - 23/11/2014
##########################

multi.TreeCmp.plot<-function(data.list, parameter, metrics, col, shift='auto', ...) {

    #Substracting the parameter of the data
    sub.data<-function(data.set, parameter) {
        sub.data<-data.set[parameter]
        class(sub.data)<-class(data.set)
        return(sub.data)
    }

    #Plotting the data
    for(metric in 1:length(metrics)) {
        TreeCmp.Plot(sub.data(get(data.list[1]), parameter), metrics[metric], lines=TRUE, col=col[1], ...)
        for(data in 2:length(data.list)) {
            if(shift=='auto') {
                TreeCmp.Plot(sub.data(get(data.list[data]), parameter), metrics[metric], col=col[data], lines=TRUE, add=TRUE, shift=as.numeric(paste(0,(data-1), sep=".")), ...)
            } else {
                TreeCmp.Plot(sub.data(get(data.list[data]), parameter), metrics[metric], col=col[data], lines=TRUE, add=TRUE, shift=shift, ...)
            }
        }
    }
}

##########################
#Plot the significance levels using the data input in the plot
##########################
#v.0.2
#Update: fixed metric input
##########################
#SYNTAX :
#<data.list> a character list of the different datasets to plot
#<parameters> a numerical list of parameters to select per dataset
#<metric> the metric of interest
#<col> the colour palette matching the list, can be default (a star) or a list of symbols or values
#<pch> symbol for the significant comparison
#<position> either 'above' or 'below' whether to plot the symbol above or below the data
#<diff.type> either 'method' or 'parameter' whether the difference must be calculated on the method or the parameters.
#<diff.matrix> the matrix containing the significant differences
##########################
#----
#guillert(at)tcd.ie - 25/11/2014
##########################

signi.TreeCmp.plot<-function(data.list, parameter, metric, probs, diff.type, position, col, pch='default', shift='auto') {

    debug=FALSE
    if(debug==TRUE) {
        data.list<-c("ML_besttrees","Bayesian_contrees","ML_bootstraps","Bayesian_treesets")
        metrics<-c("R.F_Cluster","Triples")
        metrics<-"R.F_Cluster"
        data<-1
        metric<-1
        parameter<-par_ML
        col<-palette()
        pch<-'default'
        #pch<-c(1,2,3,4,5,6)
        #pch<-c("0","10", "25", "50", "75")
        #pch<-c("ML", "Ba", "BS", "Tr")
        position<-'below'
        probs<-c(95,50)
        shift='auto'
        diff.type<-'method'
        multi.TreeCmp.plot( data.sets , par_ML, metrics[1], col=palette(), las=2, probs=c(95, 50), ylim=ylim, xaxis=NULL, xlab=NULL, ylab="Robinson-Foulds distance", las=2)
    }


#SANITIZING
    options(warn=-1)
    if(pch=='default') {
        if(diff.type=='method') {
            pch<-8
        } else {
            pch<-c(0,1,2,3,4,5,6)
        }
    }
    options(warn=1)

    if(class(pch) != 'numeric') {
        if(class(pch) != 'character') {
            stop('pch must be either "default" or a string of numerical or character values.')
        }
    }
    pch.type<-class(pch)


#FUNCTIONS
    #Substracting the parameter of the data
    sub.data<-function(data.set, parameter) {
        sub.data<-data.set[parameter]
        class(sub.data)<-class(data.set)
        return(sub.data)
    }

    FUN.hdr<-function(TreeCmp, metric.column, probs) {
        hdr.results<-NULL

        for (i in 1:length(TreeCmp)) {
            if(var(TreeCmp[[i]][,metric.column]) == 0) {
                #If no variance, make the results equal to 1
                hdr.results[[i]]<-list(hdr=NA,mode=1,alpha=NA)
            } else {
                #Else calculate the normal hdr
                hdr.results[[i]]<-hdr(TreeCmp[[i]][,metric.column], probs, h = bw.nrd0(TreeCmp[[i]][,metric.column]))  #problem with bw.nrd0?
            }
        }

        names(hdr.results)<-names(TreeCmp)

        return(hdr.results)
    }


#ADDING THE SIGNIFICANCE LEVELS TO A PLOT

    #Plotting the significant difference between the methods
    if(diff.type == 'method') {
        
        #Looping through the different data lists (=the focus data, the distribution compared to the other)
        for(data in 1:length(data.list)) {
            #Setting the new colours (excluding the colour of the focus data)
            new.col<-col[-data]
            #Setting the pch (unique)
            new.pch<-pch[1]

            #Calculating the hdr results
            hdr.results<-FUN.hdr(sub.data(get(data.list[data]), parameter), grep(metric, colnames(sub.data(get(data.list[data]), parameter)[[1]])), probs)            
            
            #Looping through the different parameters combinations in data 
            for(X in 1:length(sub.data(get(data.list[data]), parameter))) {

                #Testing if their is variance in the data
                if(length(hdr.results[[X]][[1]])==1) {
                    #Use the raw values
                    y.values<-sub.data(get(data.list[data]), parameter)[[X]][,metric]
                } else {
                    #Use the 95%CI values
                    if(any(is.na(hdr.results[[X]][[1]]))) {
                        #remove NAs if necessary
                        y.values<-unlist(hdr.results[[X]][1])[-which(is.na(unlist(hdr.results[[X]][1])))]
                    } else {
                        y.values<-unlist(hdr.results[[X]][1])
                    }
                }

                #Setting the shifting value if necessary
                if(shift=='auto') {
                    shift=0.1
                }

                
                #Looping though the remaining elements of the data list (not the focus data)
                for (Y in 2:length(data.list)) {
                    
                    #Plotting the points
                    if(position == 'below') {
                        #Add the object below
                        if(pch.type == 'character') {
                            #Adding the text if pch is character
                            text(X+(shift*data-shift), min(y.values)-(0.03*(Y-1)), as.character(new.pch), cex=0.5, col=new.col[Y-1])
                        } else {
                            #Adding the point if pch is numeric
                            points(X+(shift*data-shift), min(y.values)-(0.03*(Y-1)), pch=new.pch, col=new.col[Y-1])
                        }
                    } else {
                        #Add the object above
                        if(pch.type == 'character') {
                            #Adding the text if pch is character
                            text(X+(shift*data-shift), max(y.values)+(0.03*(Y-1)), as.character(new.pch), cex=0.5, col=new.col[Y-1])
                        } else {
                            #Adding the point if pch is numeric
                            points(X+(shift*data-shift), max(y.values)+(0.03*(Y-1)), pch=new.pch, col=new.col[Y-1])
                        }
                    }
                }
            }
        }

    } else {
    #Plotting the significant difference between groups

        #Looping through the different data lists (the focus data)
        for(data in 1:length(data.list)) {
            #Setting the colour (unique)
            new.col<-col[1]
            #Setting the new pch (excluding the one of the focus data)
            new.pch<-pch[-data]

            #Calculating the hdr results
            hdr.results<-FUN.hdr(sub.data(get(data.list[data]), parameter), grep(metric, colnames(sub.data(get(data.list[data]), parameter)[[1]])), probs)
            
            #Looping through the different parameters combinations in data (focus parameter, the distribution compared to the other)
            for(X in 1:length(sub.data(get(data.list[data]), parameter))) {      
                #Testing if their is variance in the data
                if(length(hdr.results[[X]][[1]])==1) {
                    #Use the raw values
                    y.values<-sub.data(get(data.list[data]), parameter)[[X]][,metric]
                } else {
                    #Use the 95%CI values
                    if(any(is.na(hdr.results[[X]][[1]]))) {
                        #remove NAs if necessary
                        y.values<-unlist(hdr.results[[X]][1])[-which(is.na(unlist(hdr.results[[X]][1])))]
                    } else {
                        y.values<-unlist(hdr.results[[X]][1])
                    }
                }
                #Setting the shifting value if necessary
                if(shift=='auto') {
                    shift=0.1
                }
                #Looping though the remaining parameter combinations in data
                for (Y in 2:length(sub.data(get(data.list[data]), parameter))) {
                    #Plotting the points
                    if(position == 'below') {
                        #Add the object above
                        if(pch.type == 'character') {
                            #Adding the text if pch is character
                            text(X+(shift*data-shift), min(y.values)-(0.03*(Y-1)), as.character(new.pch[Y-1]), cex=0.5, col=new.col)
                        } else {
                            #Adding the point if pch is numeric
                            points(X+(shift*data-shift), min(y.values)-(0.03*(Y-1)), pch=new.pch[Y-1], col=new.col)
                        }
                    } else {
                        #Add the object above
                        if(pch.type == 'character') {
                            #Adding the text if pch is character
                            text(X+(shift*data-shift), max(y.values)+(0.03*(Y-1)), as.character(new.pch[Y-1]), cex=0.5, col=new.col)
                        } else {
                            #Adding the point if pch is numeric
                            points(X+(shift*data-shift), max(y.values)+(0.03*(Y-1)), pch=new.pch[Y-1], col=new.col)
                        }
                    }
                }
            }
        }
    }
}



##########################
#Plot the global data
##########################
#v.0.2
#Update: added fix colour gradient
#Update: added double plot
##########################
#SYNTAX :
#<data.list> a character list of the different datasets to plot
#<parameters> a numerical list of parameters to select per dataset
#<metrics> the list of metrics
#<col> the colour palette matching the list
#<colgrad> the colour palette matching the 5 parameters combinations
#<shift> shift parameter to be passed to TreeCmp.Plot()
#<format> plot window size (A5 or A4)
#<...> any optional arguments to be passed to TreeCmp.Plot()
##########################
#----
#guillert(at)tcd.ie - 25/11/2014
##########################

global.TreeCmp.plot<-function(data.list, parameter, metrics, col, col.grad=c('blue','red'), shift='auto', format='A5',...) {

    #Graphic layout
    if(format == 'A5') {
        quartz(width = 8.3, height = 5.8)
    } else {
        quartz(width = 16.6, height = 11.6)
    }
    nf <- layout(matrix(c(1,2,3,4),4, byrow=TRUE), widths=c(1,1), heights=c(4,1,4,1), FALSE)
    #layout.show(nf)

    #Colour settings
    colfunc<-colorRampPalette(col.grad)
    colgrad<-colfunc(5)

    #FIRST PLOT

    #Plot the TreeCmp results
    par(mar=c(0,4,2,2), bty="l")
    multi.TreeCmp.plot(data.list=data.list, parameter=parameter, metrics=metrics[1], col=col, shift=shift, ylab="Robinson-Foulds distance", ...)
    
    #Add the legend bars
    par(mar=c(2,4,0,2))
    plot(1,1, xlab='', ylab='', xlim=c(1,125), ylim=c(0,3), type='n', yaxt='n', bty='n', xaxt='n') #
    text(-2, 2.5, "ML")
    text(-2, 1.5, "MF")
    text(-2, 0.5, "MC")
    #ML
    col.new<-colgrad[1:5]
    for(i in 1:5) {
        rect(xleft=(25*i-25), ybottom=2, xright=(25*i), ytop=3, col=col.new[i], broder=NULL, lty='blank')
    }
    #MF
    col.new<-rep(colgrad[1:5], 5)
    for(i in 1:25) {
        rect(xleft=(5*i-5), ybottom=1, xright=(5*i), ytop=2, col=col.new[i], broder=NULL, lty='blank')
    }
    #MC
    col.new<-rep(colgrad[1:5], 25)
    for(i in 1:125) {
        rect(xleft=(1*i-1), ybottom=0, xright=(1*i), ytop=1, col=col.new[i], broder=NULL, lty='blank')
    }


    #SECOND PLOT

    #Plot the TreeCmp results
    par(mar=c(0,4,2,2), bty="l")
    multi.TreeCmp.plot(data.list=data.list, parameter=parameter, metrics=metrics[2], col=col, shift=shift, ylab="Triplets distance", ...)

        #Add the legend bars
    par(mar=c(2,4,0,2))
    plot(1,1, xlab='', ylab='', xlim=c(1,125), ylim=c(0,3), type='n', xaxt='n', yaxt='n', bty='n')
    text(-2, 2.5, "ML")
    text(-2, 1.5, "MF")
    text(-2, 0.5, "MC")
    #ML
    col.new<-colgrad[1:5]
    for(i in 1:5) {
        rect(xleft=(25*i-25), ybottom=2, xright=(25*i), ytop=3, col=col.new[i], broder=NULL, lty='blank')
    }
    #MF
    col.new<-rep(colgrad[1:5], 5)
    for(i in 1:25) {
        rect(xleft=(5*i-5), ybottom=1, xright=(5*i), ytop=2, col=col.new[i], broder=NULL, lty='blank')
    }
    #MC
    col.new<-rep(colgrad[1:5], 25)
    for(i in 1:125) {
        rect(xleft=(1*i-1), ybottom=0, xright=(1*i), ytop=1, col=col.new[i], broder=NULL, lty='blank')
    }
}