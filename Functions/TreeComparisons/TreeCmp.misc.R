#Selecting the given parameter from the data set
sub.data<-function(data.set, parameter, metric=NULL) {
    if(is.null(metric)) {
        sub.data<-data.set[parameter]
        class(sub.data)<-class(data.set)
        return(sub.data)
    } else {
        sub.data<-data.set[parameter]
        metric.column<-grep(metric, colnames(sub.data[[1]]))
        new.list<-list()
        for (i in 1:length(sub.data)) {
            new.list[[i]]<-sub.data[[i]][, metric.column]
        }
        names(new.list)<-names(sub.data)
        return(new.list)        
    }
}