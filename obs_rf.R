# Load data ---------------------------------------------------------------

rm(list=ls())

setwd("E:/konrad/Projects/usgs/baseflow-pnw/data/outputs/csv")
fn <- "allpoints_cat.csv"

library(tidyverse)
library(randomForest)

indat <- read_csv(fn)


# Subset variables --------------------------------------------------------

vars <- c("Category", "Year", "Month", "WsAreaSqKm", "BFIWs", "ElevWs", "HydrlCondWs", "CompStrgthWs", "CCONN", "PctImp2011Ws",
          "Precip8110Ws", "Tmin8110Ws", "Tmean8110Ws", "Tmax8110Ws", "NABD_NrmStorWs")
indat <- indat[vars]
indat <- indat[!(indat$Category=="Wet" & indat$Month<8),]

indat$wet <- ifelse(indat$Category=="Wet", 1, 0)

# Try random forests ------------------------------------------------------

varsrf <- c("wet", "WsAreaSqKm", "BFIWs", "ElevWs", "HydrlCondWs", "CompStrgthWs", "CCONN", "PctImp2011Ws", 
            "Precip8110Ws", "Tmin8110Ws", "Tmean8110Ws", "Tmax8110Ws", "NABD_NrmStorWs")
rfdat <- indat[varsrf]
rf <- randomForest(as.factor(wet) ~ ., data=rfdat, importance=T)

rf$confusion

varImpPlot(rf, scale=F)
