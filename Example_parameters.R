file_name=NULL
too_expensive=NULL
too_cheap=NULL
cheap=NULL
expensive=NULL
weighting=FALSE
weight=NULL
filter=FALSE
filter_variable="child01"
filter_value=0
leave_high_records=TRUE
user_treshold=2000


too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"

file_name<-"test_data.sav"


weight<-"weight"

##########
###TESTING - no weighting, no filters, no treshold
##########

myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
                       cheap="q79", expensive="q78",weighting=FALSE,
                       weight=NULL, filter=FALSE, filter_variable=FALSE,
                       filter_value=NULL, leave_high_records=TRUE, user_treshold=NULL ) 


##########
###TESTING - weighting, no filters, no treshold
##########

myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
           cheap="q79", expensive="q78",weighting=TRUE,
           weight="weight_exampl", filter=FALSE, filter_variable=FALSE,
           filter_value=NULL, leave_high_records=TRUE, user_treshold=NULL )









