library(shiny)
library(foreign)
library(rCharts)
library(dplyr)
library(Hmisc)
library(reshape)
library(zoo)

rm(list=ls()) 

###change the max size of the file (5MB by defoult)
options(shiny.maxRequestSize=100*1024^2)  ###check what would be a reasonable here

##########################
#Function to get the data
#########################
myfunction <- function(file=NULL,too_expensive=NULL, too_cheap=NULL, cheap=NULL, expensive=NULL,
                       weight="not applicable", filter_variable="not applicable",filter_value="not applicable",  user_treshold="not applicable" )
{ 
  #read file
  #file<-read.spss(file_name, use.value.labels=FALSE, to.data.frame=TRUE)
  
  #create dummy weight var = 1 if user doesn't want to weight the data
  if(weight=="not applicable"){
    file$weight<- 1
  }
  
  ###Apply filter
  if(filter_variable!="not applicable"){
    
    
    if (weight=="not applicable"){
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
  
  if(filter_variable=="not applicable"){
    if(weight == "not applicable")
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
  if(is.na(user_treshold)==FALSE){
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
  if(is.na(user_treshold)==TRUE){max_val = max(a,b,c,d)
  }else {max_val = user_treshold}
  
  val<-c(0:max_val)
  val<-as.data.frame(val)
  
  ###change into percentages
  n<-sum(file$weight)
  
  freq_too_exp$sum<- freq_too_exp$sum/n*100.00
  freq_too_cheap$sum<- freq_too_cheap$sum/n*100.00  
  freq_exp$sum<- freq_exp$sum/n*100.00
  freq_cheap$sum<- freq_cheap$sum/n*100.00 
  
  
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
  val[1,2]<-0.00
  val[1,3]<-100.00
  val[1,4]<-0.00
  val[1,5]<-100.00
  
  val[nrow(val),2]<-100.00
  val[nrow(val),3]<-0.00
  val[nrow(val),4]<-100.00
  val[nrow(val),5]<-0.00
  
  ###Impute values
  val$too_expensive <- na.locf(val$too_expensive)
  val$too_cheap <- na.locf(val$too_cheap, fromLast = TRUE)
  val$expensive <- na.locf(val$expensive)
  val$cheap <- na.locf(val$cheap, fromLast = TRUE)
  
  val <- melt(val, id="sum")
  val$variable<-as.character(val$variable)
  val$variable[val$variable == "too_expensive"] <- "Too expensive"
  val$variable[val$variable == "too_cheap"] <- "Too cheap"
  val$variable<-as.factor(val$variable)
  val$value<-round(val$value,2)
  
  return(val)
}

################
##server function
##################

shinyServer(function(session,input, output) {
  
  
  ##Upload file
  Dataset <- reactive({
    infile <- input$datafile
    if (is.null(infile)) {
      
      return(NULL)
    }
    read.spss(infile$datapath, use.value.labels=FALSE, to.data.frame=TRUE)
  })
  
  
  ###choice of 4 variables  !!!!!!!!!!!!!!!!!to do: TRY TO HIDE FILTER VALUE BUTTON IF NO FILTER VARIABLE SELECTED!!!!!!!!!!!!!
  
  output$too_expensive <- renderUI({
    if (identical(Dataset(), '') || identical(Dataset(),data.frame())) return(NULL)
    cols <- names(Dataset())
    selectInput("too_expensive", "TOO EXPENSIVE variable:",choices=cols, selected=cols, multiple=F)  
  })
  
  output$too_cheap <- renderUI({
    if (identical(Dataset(), '') || identical(Dataset(),data.frame())) return(NULL)
    cols <- names(Dataset())
    selectInput("too_cheap", "TOO CHEAP variable:",choices=cols, selected=cols, multiple=F)  
  })
  
  output$expensive <- renderUI({
    if (identical(Dataset(), '') || identical(Dataset(),data.frame())) return(NULL)
    cols <- names(Dataset())
    selectInput("expensive", "EXPENSIVE variable:",choices=cols, selected=cols, multiple=F)  
  })
  
  output$cheap <- renderUI({
    if (identical(Dataset(), '') || identical(Dataset(),data.frame())) return(NULL)
    cols <- names(Dataset())
    selectInput("cheap", "CHEAP variable:",choices=cols, selected=cols, multiple=F)  
  })
  
  output$filter_variable <- renderUI({
    if (identical(Dataset(), '') || identical(Dataset(),data.frame())) return(NULL)
    cols <- names(Dataset())
    selectInput("filter_variable", "Filter variable:",choices=c(cols, "not applicable"), multiple=F, selected="not applicable")   
  })
  
  output$weight<- renderUI({
    if (identical(Dataset(), '') || identical(Dataset(),data.frame())) return(NULL)
    cols <- names(Dataset())
    selectInput("weight", "Weighting variable:",choices=c(cols, "not applicable"), multiple=F, selected="not applicable")  
  })
  
  

  
  
  ##render output
  
  data_funct<-eventReactive(input$goButton, {

    
    
    myfunction(file = Dataset(),too_expensive = input$too_expensive, too_cheap = input$too_cheap, 
               cheap = input$cheap, expensive = input$expensive,
               weight = input$weight, filter_variable = input$filter_variable,filter_value = input$filter_value,  
               user_treshold = input$user_treshold)})
  
  output$table <-DT::renderDataTable(datatable(
    data_funct(), filter = "top",  
    options = list(pageLength = 16, autoWidth = TRUE, lengthMenu = c(5, 10, 16)),
    rownames= FALSE
  ))
  
})