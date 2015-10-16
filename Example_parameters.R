file_name=NULL
too_expensive=NULL
too_cheap=NULL
cheap=NULL
expensive=NULL

weight=NULL

filter_variable="child01"
filter_value=0

user_treshold=2000
weight<-"weight_exampl"


weighting=FALSE
filter=FALSE
leave_high_records=TRUE
too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"
file_name<-"test_data.sav"



##########
###TESTING1 - no weighting, no filters, no treshold
##########

myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
                       cheap="q79", expensive="q78",weighting=FALSE,
                       weight=NULL, filter=FALSE, filter_variable=FALSE,
                       filter_value=NULL, leave_high_records=TRUE, user_treshold=NULL ) 


weighting=FALSE
filter=FALSE
leave_high_records=TRUE
too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"
file_name<-"test_data.sav"



##########
###TESTING2 - weighting, no filters, no treshold
##########

myfunction(file_name="",too_expensive="q76", too_cheap="q77", 
           cheap="q79", expensive="q78",weighting=TRUE,
           weight="weight_exampl", filter=FALSE, filter_variable=FALSE,
           filter_value=NULL, leave_high_records=TRUE, user_treshold=NULL )


weighting=TRUE
filter=FALSE
leave_high_records=TRUE
too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"
file_name<-"test_data.sav"
weight<-"weight_exampl"




##########
###TESTING3 - no weighting, filters, no treshold
##########

myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
           cheap="q79", expensive="q78",weighting=FALSE,
           weight=NULL, filter=TRUE, filter_variable="child01",
           filter_value=0, leave_high_records=TRUE, user_treshold=NULL ) 


weighting=FALSE
filter=TRUE
leave_high_records=TRUE
too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"
file_name<-"test_data.sav"
filter_variable="child01"
filter_value=0


##########
###TESTING4 - weighting, filters, no treshold
##########

myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
           cheap="q79", expensive="q78",weighting=TRUE,
           weight="weight_exampl", filter=TRUE, filter_variable="child01",
           filter_value=0, leave_high_records=TRUE, user_treshold=NULL )

weighting=TRUE
filter=TRUE
leave_high_records=TRUE
too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"
file_name<-"test_data.sav"
weight<-"weight_exampl"
filter_variable="child01"
filter_value=0



##########
###TESTING5 - no weighting, filters, treshold
##########

myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
           cheap="q79", expensive="q78",weighting=FALSE,
           weight=NULL, filter=TRUE, filter_variable="child01",
           filter_value=0, leave_high_records=FALSE, user_treshold=200 ) 


myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
           cheap="q79", expensive="q78",weighting=FALSE,
           weight=NULL, filter=TRUE, filter_variable="child01",
           filter_value=0, leave_high_records=TRUE, user_treshold=NULL ) 


weighting=FALSE
filter=TRUE
leave_high_records=FALSE
user_treshold=1000
too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"
file_name<-"test_data.sav"
filter_variable="child01"
filter_value=0


##########
###TESTING6 - weighting, filters, treshold
##########

myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
           cheap="q79", expensive="q78",weighting=TRUE,
           weight="weight_exampl", filter=TRUE, filter_variable="child01",
           filter_value=0, leave_high_records=FALSE, user_treshold=5000 )


weighting=TRUE
filter=TRUE
leave_high_records=FALSE
user_treshold=1000
too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"
file_name<-"test_data.sav"
filter_variable="child01"
filter_value=0
weight<-"weight_exampl"



##########
###TESTING7 - no weighting, no filters, treshold
##########

myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
           cheap="q79", expensive="q78",weighting=FALSE,
           weight=NULL, filter=FALSE, filter_variable=FALSE,
           filter_value=NULL, leave_high_records=FALSE, user_treshold=200 ) 

weighting=FALSE
filter=FALSE
leave_high_records=FALSE
user_treshold=1000
too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"
file_name<-"test_data.sav"

##########
###TESTING8 - weighting, no filters, treshold
##########

myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
           cheap="q79", expensive="q78",weighting=TRUE,
           weight="weight_exampl", filter=FALSE, filter_variable=FALSE,
           filter_value=NULL, leave_high_records=FALSE, user_treshold=1000)


weighting=TRUE
filter=FALSE
leave_high_records=FALSE
user_treshold=1000
too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"
file_name<-"test_data.sav"
weight<-"weight_exampl"


