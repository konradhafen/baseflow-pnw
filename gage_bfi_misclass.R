# Load data ---------------------------------------------------------------

rm(list=ls())

setwd("E:/konrad/Projects/usgs/baseflow-pnw/data/outputs/csv")
fn <- "baseflow_misclass.csv"

indat <- read.csv(fn)



# Manipulate data ---------------------------------------------------------

indat$mc <- mapply(misclass, indat$FCODE, indat$Category)
indat$nhdclass <- mapply(nhdclass, indat$FCODE)
indat$wet <- ifelse(indat$nhdclass=="Permanent", 1, 0)
indat$mctype <- mapply(misclass_type, indat$nhdclass, indat$Category)


# LR Model related to BFI -------------------------------------------------

lr.bfi <- glm(mc ~ BFI_AVE, data=indat, family="binomial")
library(pscl)
pR2(lr.bfi)
library(pROC)
roc.data <- augment(lr.bfi)
roc.bfi <- roc(wet ~ plogis(.fitted), data=roc.data)
auc(roc.bfi)
plot.roc(roc.bfi, xlim=c(0,1), ylim=c(0,1))
