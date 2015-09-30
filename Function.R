#setwd("C:/Users/dorota.lewandowska/Documents/my projects/YG_van_Wastendorp")

##require(devtools)
##install_github('rCharts', 'ramnathv')

library(foreign)
library(rCharts)
library(dplyr)
library(Hmisc)
library(reshape)
library(zoo)

###Read file

data1<-read.spss("mergedABCD_final_all_24_inch.sav", use.value.labels=FALSE, to.data.frame=TRUE)


###Change variable names and variable labels


cols <- c("val", "Too_expensive","Too_cheap", "Expensive", "Cheap")

colnames(data1) <- cols

label(data1$Too_expensive) <- "Too expensive"
label(data1$Too_cheap) <- "Too cheap" 
label(data1$Expensive) <- "Expensive" 
label(data1$Cheap) <- "Cheap" 




val<-c(0:max(data1$val))
val<-as.data.frame(val)

data1<-left_join(val, data1, by = "val")
rm(val)

###impute values
data1[1,2]<-0
data1[1,4]<-0
data1[1,3]<-100
data1[1,5]<-100


data1[nrow(data1),2]<-100
data1[nrow(data1),4]<-100
data1[nrow(data1),3]<-0
data1[nrow(data1),5]<-0

###Impute values
data1$Too_expensive <- na.locf(data1$Too_expensive)
data1$Too_cheap <- na.locf(data1$Too_cheap, fromLast = TRUE)
data1$Expensive <- na.locf(data1$Expensive)
data1$Cheap <- na.locf(data1$Cheap, fromLast = TRUE)

##reshape
mdata <- melt(data1, id="val")

mdata$variable<-as.character(mdata$variable)

mdata$variable[mdata$variable == "Too_expensive"] <- "Too expensive"
mdata$variable[mdata$variable == "Too_cheap"] <- "Too cheap"

mdata$variable<-as.factor(mdata$variable)

###round values of percentages
mdata$value<-round(mdata$value,1)


###Generate a plot
## http://ramnathv.github.io/rChartsShiny/
##http://walkerke.github.io/2014/03/tfr-in-europe/


require(rCharts)

# Create the chart
dataPlot <- nPlot(
  value ~ val, 
  data = mdata, 
  group = "variable",
  type = "lineChart")

# Add axis labels and format the tooltip
dataPlot$yAxis(axisLabel = "Total fertility rate", width = 62)

dataPlot$xAxis(axisLabel = "Year")

dataPlot$chart(tooltipContent = "#! function(key, x, y){
              return '<h3>' + key + '</h3>' + 
              '<p>' + y + '%, value:' + x + '</p>'
              } !#")

dataPlot



