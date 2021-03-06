library(flowCore)

# Can we do everything Perry does in example1.R (filtering related)?

## create the data to be used
## these are three interesting wells from a BD FACS CAP(TM) plate
## with PBMS (perpheral blood monocytes) on the plate
b08 = read.FCS(system.file("extdata","0877408774.B08",package="flowCore"),transformation="scale")
e07 = read.FCS(system.file("extdata","0877408774.E07",package="flowCore"),transformation="scale")
f06 = read.FCS(system.file("extdata","0877408774.F06",package="flowCore"),transformation="scale")

# I sort of wish that as.logical would attempt to coerce using S4 rather than doing the hard coded
# thing. Might be something to propose to R-devel.

filter1 = rectangleGate("FSC-H"=c(.2,.8),"SSC-H"=c(0,.8))
b08.result1 = filter(b08,filter1)
summary(b08.result1)
sum(b08 %in% filter1)
# [1] 8291

e07.result1 = filter(e07,filter1)
summary(e07.result1)
sum(e07 %in% filter1)
# [1] 8514

f06.result1 = filter(f06,filter1)
summary(f06.result1)
sum(f06 %in% filter1)
# [1] 8765

filter2 = norm2Filter("FSC-H","SSC-H",scale.factor=2,filterId="Live Cells")
b08.result2 = filter(b08,filter2 %subset% b08.result1)
filterDetails(b08.result2)
summary(b08.result2)
sum(b08 %in% (filter2 %subset% b08.result1))
# [1] 6496

e07.result2 = filter(e07,filter2 %subset% e07.result1)
summary(e07.result2)
sum(e07 %in% (filter2 %subset% e07.result1))
# [1] 6416

f06.result2 = filter(f06,filter2 %subset% f06.result1)
summary(f06.result2)
sum(f06 %in% (filter2 %subset% f06.result1))
# [1] 6959

## the third-fifth gates get the positive cells for the marker in FL1-H
## this is a really interesting example because it illustrates that there
## are two subpopulations. Naturally we would like to automatically find them
## In this case we want to now what percent the positive population in FL1-H is of the
## total population

filter3 = rectangleGate("FL1-H"=c(.4,Inf),filterId="FL1-H+")
b08.result3 = filter(b08,filter3 %subset% b08.result2)
summary(b08.result3)
# An example of doing manipulations with filterResult objects 
# since they are now also filter objects. The %subset% argument
# has a special summary meaning because it does it's calculations
# relative to the RHS argument, whereas filterResults are ALWAYS
# wrt to the full dataset. So, the value below should differ from 
# the value above.
summary(b08.result3 %subset% b08.result2)

filter4 = norm2Filter("FSC-H","FL1-H",scale.factor=2,filterId="FL1-H+")
b08.result4 = filter(b08,filter4 %subset% b08.result2)
summary(b08.result4)
# [1] 3490
summary(b08.result4 %subset% b08.result2)
# ~53.73%

#We now have NOT gates so we can proceed!
b08.result5 = filter(b08,filter4 %subset% (b08.result2 & !b08.result4))
summary(b08.result5)
# [1] 2568
summary(b08.result4 %subset% (b08.result4 | b08.result5))$p
# [1] 0.5758877
q()



## the sixth-eighth gates get the positive cells for the marker in FL2-H
## in this case there is only a negative population
plot(b08,parent=b08.result2@subSet,plotParameters=c("FSC-H","FL2-H"),ylim=c(0,1024),xlim=c(0,1024))
filter6 = new("rectangleGate",filterId="FL2-H+",parameters="FL2-H",min=600,max=Inf)
b08.result6 = applyFilter(filter6,b08,b08.result2@subSet)
plot(b08,y=b08.result6,parent=b08.result2@subSet,plotParameters=c("FSC-H","FL2-H"),
          xlim=c(0,1024),ylim=c(0,1024))
sum(b08.result6@subSet)
#[1] 12
sum(b08.result6@subSet)/sum(b08.result2@subSet)
#[1] 0.001
filter7=new("norm2Filter",filterId="FL2-H-",scale.factor=2,method="covMcd",parameters=c("FSC-H","FL2-H"))
b08.result7 = applyFilter(filter7,b08,b08.result2@subSet)
plot(b08,y=b08.result7,parent=b08.result2@subSet,plotParameters=c("FSC-H","FL2-H"),
          xlim=c(0,1024),ylim=c(0,1024))
sum(b08.result7@subSet)
sum(b08 %in% (b08.result2 & filter7))
#[1] 5422

## this doesn't produce a sensible result since there is no positive population remaining
b08.result8 = applyFilter(filter7,b08,b08.result2@subSet-b08.result7@subSet)
plot(b08,y=b08.result8,parent=b08.result2@subSet,plotParameters=c("FSC-H","FL2-H"),
          xlim=c(0,1024),ylim=c(0,1024))
sum(b08.result8@subSet)
#[1] 
sum(b08.result8@subSet8)/(sum(b08.result7@subSet)+sum(b08.result8@subSet))
#[1] 


## the ninth-eleventh gates get the positive cells for the marker in FL3-H
## again, there is only a negativ3e population here
plot(b08,parent=b08.result2@subSet,plotParameters=c("FSC-H","FL3-H"),ylim=c(0,1024),xlim=c(0,1024))
filter9 = new("rectangleGate",filterId="FL3-H+",parameters="FL3-H",min=500,max=Inf)
b08.result9 = applyFilter(filter9,b08,b08.result2@subSet)
plot(b08,y=b08.result9,parent=b08.result2@subSet,plotParameters=c("FSC-H","FL3-H"),
          xlim=c(0,1024),ylim=c(0,1024))
sum(b08.result9@subSet)
#[1] 0
sum(b08.result9@subSet)/sum(b08.result2@subSet)
#[1] 0
filter10=new("norm2Filter",filterId="FL3-H-",scale.factor=2,method="covMcd",parameters=c("FSC-H","FL3-H"))
b08.result10 = applyFilter(filter10,b08,b08.result2@subSet)
plot(b08,y=b08.result10,parent=b08.result2@subSet,plotParameters=c("FSC-H","FL3-H"),
          xlim=c(0,1024),ylim=c(0,1024))
sum(b08.result10@subSet)
#[1] 5834

## this doesn't produce a sensible result since there is no positive population remaining
b08.result11 = applyFilter(filter10,b08,b08.result2@subSet-b08.result10@subSet)
plot(b08,y=b08.result11,parent=b08.result2@subSet,plotParameters=c("FSC-H","FL3-H"),
          xlim=c(0,1024),ylim=c(0,1024))
sum(b08.result11@subSet)
#[1] 
sum(b08.result11@subSet)/(sum(b08.result11@subSet)+sum(b08.result10@subSet))
#[1] 




