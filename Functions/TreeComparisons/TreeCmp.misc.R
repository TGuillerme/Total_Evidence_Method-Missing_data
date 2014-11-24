#Selecting the given parameter from the data set
sub.data<-function(data.set, parameter) {
    sub.data<-data.set[parameter]
    class(sub.data)<-class(data.set)
    return(sub.data)
}