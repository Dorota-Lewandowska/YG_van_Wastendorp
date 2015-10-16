
rm(list=ls()) 



library(foreign)
library(rCharts)
library(dplyr)
library(Hmisc)
library(reshape)
library(zoo)
require(rCharts)

##choose the data to use
val<-read.csv("datasss2.csv")

##reshape
mdata <- melt(val, id="sum")
mdata$variable<-as.character(mdata$variable)
mdata$variable[mdata$variable == "too_expensive"] <- "Too expensive"
mdata$variable[mdata$variable == "too_cheap"] <- "Too cheap"
mdata$variable<-as.factor(mdata$variable)


mdata$value<-round(mdata$value,2)



###########1st one

# Create the chart
dataPlot <- nPlot(
value ~ sum,
data = mdata,
group = "variable",
type = "lineChart")

# Add axis labels and format the tooltip
dataPlot$yAxis(axisLabel = "Percentage of respondents", width = 52)
dataPlot$xAxis(axisLabel = "Price")
dataPlot$set(pointSize = 0, lineWidth = 0.1)
dataPlot$chart(tooltipContent = "#! function(key, x, y){
return '<h3>' + key + '</h3>' +
'<p>' + y + '%, price:' + x + '</p>'
} !#")

dataPlot

