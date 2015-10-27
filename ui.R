####Explore the link https://gist.github.com/withr/8799489

library(dplyr)
library(magrittr) 
library(data.table)
library(tidyr)
library(reshape)
library(DT)
library(shinyjs)
library(httr)


# Define UI for application 
shinyUI(fluidPage(
  
  sidebarPanel(
    
    titlePanel("Van Wastendorp Price Model"),
    tags$br(),
    
    ###Upload file
    fileInput('datafile', 'Choose SPSS file'),
    
    uiOutput("too_expensive"),
    uiOutput("too_cheap"),
    uiOutput("expensive"),
    uiOutput("cheap"),

    
    tags$hr(),
    tags$br(),
    tags$br(),
    
    
    h4("Optional parameters - data cleaning"),
    
    # Set up user threshod
    numericInput("user_treshold", 
                 label = h5("Delete respondents who chose prices above:"), 
                 value = NULL),
    
    ###select filter variable
    
    uiOutput("filter_variable"),

    numericInput("filter_value", 
                 label = h5("Value of filter variable"), 
                 value = NULL),
    
    tags$br(),
    tags$br(),
    tags$br(),
    
    
    h4("Optional parameters - weighting"),
    uiOutput("weight"),
    tags$br(),
    tags$br(),
    
    ###Action button
    actionButton("goButton", "Create graph")
    
  ),
  
  mainPanel(
    div(class = "busy",  
        img(height=120, width=600,src="http://www.barchart.com/shared/images/progress_bar.gif")
    ),
    
    ## loading msg
    tagList(
      tags$head(
        tags$link(rel="stylesheet", type="text/css",href="style.css"),
        tags$script(type="text/javascript", src = "busy.js")
      )
    ),
    tags$br(),
    tags$br(),

    
    div(DT::dataTableOutput("table"), style = "font-size:75%")
    
    
  )
))