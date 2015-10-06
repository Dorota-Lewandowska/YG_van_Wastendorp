rm(list=ls()) 

library(foreign)
library(rCharts)
library(dplyr)
library(Hmisc)
library(reshape)
library(zoo)

myfunction <- function(file_name=NULL,too_expensive=NULL, too_cheap=NULL, cheap=NULL, expensive=NULL,weighting=FALSE,
                       weight=NULL, filter=FALSE, filter_variable=FALSE,filter_value=NULL, leave_high_records=TRUE, user_treshold=NULL )
{ 
  #read file
  file<-read.spss(file_name, use.value.labels=FALSE, to.data.frame=TRUE)
    
  #create dummy weight var = 1 if user doesn't want to weight the data
  if(weighting==FALSE){
    file$weight<- 1
  }
  
  ###Apply filter
  if(filter==TRUE){
    
    
    if (weighting==FALSE){
    cols_filt <- c(too_expensive,too_cheap, expensive, cheap, filter_variable, "weight")
    file<-file[,cols_filt]
    file<- file[complete.cases(file), ]
    } else
    {
      cols_filt <- c(too_expensive,too_cheap, expensive, cheap, filter_variable, weight)
      file<-file[,cols_filt]
      file<- file[complete.cases(file), ]        
    }
      cols_filt <- c("too_expensive","too_cheap", "expensive", "cheap", "filter", "weight")
      colnames(file) <- cols_filt
    
      file<-file[file$filter == filter_value, ]
      cols_filt <- c("too_expensive","too_cheap", "expensive", "cheap", "weight")
      file<-file[,cols_filt]       
  }
  
  ###choose only the variables you need - make sure they are in the right order
  
  if(filter==FALSE){
    if(weighting == FALSE)
    {
      cols <- c(too_expensive,too_cheap, expensive, cheap, "weight")
      file<-file[,cols]
    } else{
      
      cols <- c(too_expensive,too_cheap, expensive, cheap, weight)
      file<-file[,cols]
    }
  }
  
  
  ##choose only variables that are needed
  
  ##rename column namess 
  cols_new <- c("too_expensive","too_cheap", "expensive", "cheap", "weight")
  colnames(file) <- cols_new
  
  ###change negative values for NA's
  file$too_expensive[file$too_expensive<0] <- NA
  file$too_cheap[file$too_cheap<0] <- NA
  file$expensive[file$expensive<0] <- NA
  file$cheap[file$cheap<0] <- NA
  
  file<- file[complete.cases(file), ]
  
  ##if treshold set up - remove cases with these extreme values
  if(leave_high_records==FALSE){
    file<-file[!file$too_expensive > user_treshold, ]
    file<-file[!file$too_cheap > user_treshold, ]
    file<-file[!file$expensive > user_treshold, ]
    file<-file[!file$cheap > user_treshold, ]
  }
  
  ###calculate frequencies for every of 4 measures
  
  freq_too_exp<-as.data.frame(as.matrix((cumsum(wtd.table(file$too_expensive, weights=file$weight, type='table', normwt=FALSE, na.rm=TRUE)))))
  freq_too_exp$value<-row.names(freq_too_exp)
  colnames(freq_too_exp)<-c("sum", "val")
  freq_too_exp$val<-as.integer(freq_too_exp$val)
  
  freq_too_cheap<-as.data.frame(as.matrix((cumsum(wtd.table(file$too_cheap, weights=file$weight, type='table', normwt=FALSE, na.rm=TRUE)))))
  freq_too_cheap$value<-row.names(freq_too_cheap)
  colnames(freq_too_cheap)<-c("sum1", "val")
  freq_too_cheap$val<-as.integer(freq_too_cheap$val)
  freq_too_cheap$sum[1]<-freq_too_cheap$sum1 [nrow(freq_too_cheap)]
  
  
  for (i in 2:(nrow(freq_too_cheap)))
  {
    freq_too_cheap$sum[i]<- (freq_too_cheap$sum[1]) - (freq_too_cheap$sum1[i-1])
  }
  freq_too_cheap<-freq_too_cheap[, c("sum","val")]
  
  freq_exp<-as.data.frame(as.matrix((cumsum(wtd.table(file$expensive, weights=file$weight, type='table', normwt=FALSE, na.rm=TRUE)))))
  freq_exp$value<-row.names(freq_exp)
  colnames(freq_exp)<-c("sum", "val")
  freq_exp$val<-as.integer(freq_exp$val)
  
  freq_cheap<-as.data.frame(as.matrix((cumsum(wtd.table(file$cheap, weights=file$weight, type='table', normwt=FALSE, na.rm=TRUE)))))
  freq_cheap$value<-row.names(freq_cheap)
  colnames(freq_cheap)<-c("sum1", "val")
  freq_cheap$val<-as.integer(freq_cheap$val)
  
  freq_cheap$sum[1]<-freq_cheap$sum1 [nrow(freq_cheap)]
  
  for (i in 2:(nrow(freq_cheap)))
  {
    freq_cheap$sum[i]<- (freq_cheap$sum[1]) - (freq_cheap$sum1[i-1])
  }
  
  freq_cheap<-freq_cheap[, c("sum","val")]
  
  ###Generate a table with all measures for all possible prices (from 0 to max)
  a<-max(file$too_cheap, na.rm=TRUE)
  b<-max(file$too_expensive, na.rm=TRUE)
  c<-max(file$cheap, na.rm=TRUE)
  d<-max(file$expensive, na.rm=TRUE)
  
  #### Calculate the table (possibility to exclude extremally weird answers)################IMPORTANT FOR APP
  if(leave_high_records==TRUE){max_val = max(a,b,c,d)
  }else {max_val = user_treshold}
  
  val<-c(0:max_val)
  val<-as.data.frame(val)
  
  ###change into percentages
  n<-sum(file$weight)
  
  freq_too_exp$sum<- freq_too_exp$sum/n*100
  freq_too_cheap$sum<- freq_too_cheap$sum/n*100  
  freq_exp$sum<- freq_exp$sum/n*100
  freq_cheap$sum<- freq_cheap$sum/n*100 
  
  
  #####merge val table with frequencies from 
  val<-left_join(val, freq_too_exp, by = "val")
  val<-left_join(val, freq_too_cheap, by = "val")
  val<-left_join(val, freq_exp, by = "val")
  val<-left_join(val, freq_cheap, by = "val")
  
  cols_freq<-c("sum", "too_expensive", "too_cheap", "expensive", "cheap")
  colnames(val) <- cols_freq
  
  ###remove unnecessary stuff
  rm(list=setdiff(ls(), "val"))
  
  ###Impute missing values - 1st and last line, NA's replaced 
  val[1,2]<-0
  val[1,3]<-100
  val[1,4]<-0
  val[1,5]<-100
  
  val[nrow(val),2]<-100
  val[nrow(val),3]<-0
  val[nrow(val),4]<-100
  val[nrow(val),5]<-0
  
  ###Impute values
  val$too_expensive <- na.locf(val$too_expensive)
  val$too_cheap <- na.locf(val$too_cheap, fromLast = TRUE)
  val$expensive <- na.locf(val$expensive)
  val$cheap <- na.locf(val$cheap, fromLast = TRUE)
  
  return(val)
}
