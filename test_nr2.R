
##########
###TESTING1 - no weighting, no filters, no treshold
##########

myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
           cheap="q79", expensive="q78")


weight=FALSE
filter_variable=FALSE
user_treshold=FALSE
too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"
file_name<-"test_data.sav"

##########
###TESTING2 - weighting, no filters, no treshold
##########

myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
           cheap="q79", expensive="q78", weight<-"weight_exampl")



filter_variable=FALSE
user_treshold=FALSE
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
           cheap="q79", expensive="q78", filter_value = 1, filter_variable = "Group_3_257" )


weight=FALSE
filter_variable="Group_3_257"
filter_value = 1
user_treshold=FALSE
too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"
file_name<-"test_data.sav"

##########
###TESTING4 - weighting, filters, no treshold
##########

myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
           cheap="q79", expensive="q78", filter_variable="Group_3_257", filter_value = 1, weight<-"weight_exampl")
           
           
filter_variable="Group_3_257"
filter_value = 1
too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"
file_name<-"test_data.sav"
weight<-"weight_exampl"
user_treshold=FALSE

##########
###TESTING5 - no weighting, filters, treshold
##########

myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
           cheap="q79", expensive="q78", filter_value = 1, filter_variable = "Group_3_257", user_treshold = 500)


weight=FALSE
filter_variable="Group_3_257"
filter_value = 1
user_treshold=200
too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"
file_name<-"test_data.sav"

##########
###TESTING6 - weighting, filters, treshold
##########

myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
           cheap="q79", expensive="q78", filter_value = 1, filter_variable = "Group_3_257", user_treshold = 500, weight<-"weight_exampl")


weight<-"weight_exampl"
filter_variable="Group_3_257"
filter_value = 1
user_treshold=200
too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"
file_name<-"test_data.sav"











##########
###TESTING7 - no weighting, no filters, treshold
##########

myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
           cheap="q79", expensive="q78", user_treshold=200)


weight=FALSE
filter_variable=FALSE
user_treshold=200
too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"
file_name<-"test_data.sav"

##########
###TESTING8 - weighting, no filters, treshold
##########

myfunction(file_name="test_data.sav",too_expensive="q76", too_cheap="q77", 
           cheap="q79", expensive="q78", user_treshold=200, weight="weight_exampl")


weight="weight_exampl"
filter_variable=FALSE
user_treshold=200
too_expensive<-"q76"
too_cheap<-"q77"
expensive<-"q78"
cheap<-"q79"
file_name<-"test_data.sav"

