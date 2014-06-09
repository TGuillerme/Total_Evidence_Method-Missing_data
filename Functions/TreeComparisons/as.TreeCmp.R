##########################
#as TreeCmp
##########################
#Transform a list or data.frame into a TreeCmp object (if possible)
#v.0.1
##########################
#SYNTAX :
#<data> the input data
##########################
#----
#guillert(at)tcd.ie - 09/06/2014
##########################
#Requirements:
#-R 3
##########################

as.TreeCmp<-function(data) {

#DATA INPUT
    #data
    if(class(data) == 'TreeCmp') {
        data.list<-TRUE
        data.TreeCmp<-TRUE
    } else {
        if(class(data) == 'list') {
            data.list<-TRUE
            data.TreeCmp<-FALSE
            if(class(data[[1]]) != 'data.frame') {
                stop('The given list must be a list of data.frame objects')
            }
        } else {
            if(class(data) == 'data.frame') {
                data.list<-FALSE
                data.TreeCmp<-FALSE
            } else {
                stop('Input data must be a list or a data.frame object')
            }
        }
    }

#TRANSFORMING THE OBJECT IN A TREECMP OBJECT

    if(data.TreeCmp == TRUE){
    #data is already a TreeCmp object
        return(data)
    } else {
        if(data.list == TRUE) {
        #Data is a a list
            class(data)<-"TreeCmp"
            return(data)
        } else {
            #Data is a data.frame
            data<-as.list(data)
            class(data)<-"TreeCmp"
            return(data)
        }
    }


#End
}