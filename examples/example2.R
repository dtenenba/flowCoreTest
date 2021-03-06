## compensation.R
## 
## Read in the plates of compensation tubes, compensate and be sure it is done correctly.
##
## Author: haaland
###############################################################################
library(flowCore)

## get the compensation matrix
comp.mat = as.matrix(read.table("./inst/extdata/compdata/compmatrix",header=TRUE,skip=2))
colnames(comp.mat)
#[1] "FL1.H" "FL2.H" "FL3.H" "FL4.H"
colnames(comp.mat) = c("FL1-H","FL2-H","FL3-H","FL4-H")
## read in the compensation tubes
## I think the default linearlization is the correct thing
comp.fset1 = read.flowSet(path="~/rglab/workspace/flowCore/inst/extdata/compdata/data/",dataset=2)
ap = phenoData(comp.fset1)
pData(ap)$Tube = 1:5
phenoData(comp.fset1) = ap
pData(ap)
eapply(comp.fset1@frames,function(x) apply(x@exprs,2,range))
colnames(comp.fset1)
apply(comp.fset1[[1]]@exprs,2,range)

## compensate the linearized data
comp.fset1b = compensate(comp.fset1,comp.mat)
colnames(comp.fset1b)
eapply(comp.fset1b@frames,function(x) apply(x@exprs,2,range))
apply(comp.fset1b[[1]]@exprs,2,range)

truncTrans = truncateTransform("truncate",a=1)
linearTrans = linearTransform(transformationId="linearTransformation",a=2,b=0)
transform(comp.fset1b[[1]],`FL1-H`=linearTrans(`FL1-H`))
apply(comp.fset1b[[1]]@exprs,2,range)
apply(transform(comp.fset1b[[1]],`FL1-H`=linearTrans(`FL1-H`))@exprs,2,range)
apply(transform(comp.fset1b[[1]],`FL1-H`=truncTrans(`FL1-H`))@exprs,2,range)

linearTrans2 = linearTransform("linearTransformation",a=1,b=0)
comp.fset1ba = transform(comp.fset1b,`SSC-H`=linearTrans2(`SSC-H`))
apply(comp.fset1ba[[1]]@exprs,2,range)


## truncate values
comp.fset1c = transform(comp.fset1b,`FL1-H`=truncTrans(`FL1-H`),`FL2-H`=truncTrans(`FL2-H`),
	`FL3-H`=truncTrans(`FL3-H`),`FL4-H`=truncTrans(`FL4-H`))
colnames(comp.fset1c)
eapply(comp.fset1c@frames,function(x) apply(x@exprs,2,range))
apply(comp.fset1c[[1]]@exprs,2,range)

## scale FSC and SSC to go from 0 to 1
scScaleTrans = scaleTransform("scatter-scale",a=0,b=1023)
comp.fset1d = transform(comp.fset1c,`SSC-H`=scScaleTrans(`SSC-H`))#,`FSC-H`=scScaleTrans(`FSC-H`))
colnames(comp.fset1d)
eapply(comp.fset1d@frames,function(x) apply(x@exprs,2,range))
apply(comp.fset1d[[1]]@exprs,2,range)

