##########################
#TreeCmp functions examples
##########################
#TreeCmp.pairPlot
##########################
#----
#guillert(at)tcd.ie - 30/05/2014
##########################
#Requirements:
#-R 3
##########################

#TreeCmp.pairPlot

    #Generating a random group comparison list (100 groups)
    #factors<-NULL ; for (i in 1:100){factors<-c(factors,rep(i, 50))}
    #factors<-as.factor(factors)
    #values<-NULL ; for (i in 1:100){values<-c(values, rnorm(50, sample(i:100,1)))}
    #example<-list("factors"=factors, "values"=values)

    #non-parametric test (untested assumption, just for the example)
    #require(pgirmess)
    #posthoc<-kruskalmc(values ~ factors, data=example)
    #posthoc.nonpar<-posthoc$dif.com

    #parametric test (untested assumption, just for the example)
    #aov<-aov(values ~ factors, data=example)
    #posthoc<-TukeyHSD(aov)
    #posthoc.par<-posthoc$factors

    #posthoc pairwise comparisons heat plot
    #TreeCmp.pairPlot(posthoc.nonpar, parametric=FALSE)
    #TreeCmp.pairPlot(posthoc.par, parametric=TRUE)