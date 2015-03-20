##loading libraries that will be used during the tidying of the raw data
library(data.table)
library(dplyr)
library(reshape2)

##1 - merging the six datasets into one dataset - 
	##1.1 test dataset compilation

		##reading the test txt files into tables
		volunteerstest <- read.table("subject_test.txt")
		variablestest <- read.table("X_test.txt")
		activitytest <- read.table("y_test.txt")

			##merging the three datasets into one table - test dataset
			testdataset <- cbind(volunteerstest, activitytest, variablestest)
			
	##1.2 training dataset compilation
			
		##reading the training txt files into tables
		volunteerstraining <- read.table("subject_train.txt")
		variablestraining <- read.table("X_train.txt")
		activitytraining <- read.table("y_train.txt")

			##merging the three datasets into one table - training dataset
			trainingdataset <- cbind(volunteerstraining, activitytraining, variablestraining)
			
	##1.3 merging the two datasets - testdataset & trainingdataset
	mergedsubset <- rbind(testdataset, trainingdataset)


##2 - extracting measurements with mean and standard deviation only for the following 17 variables:

	##tBodyAcc-XYZ, tGravityAcc-XYZ, tBodyAccJerk-XYZ, tBodyGyro-XYZ, tBodyGyroJerk-XYZ, tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag, fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccMag, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag.
	
		##thus providing a total of 66 columns, plus 2 columns for volunteernumber and activitytype
	meanstdsubset <- mergedsubset[c(1:2, 3:8, 43:48, 83:88, 123:128, 163:168, 203:204, 216:217, 229:230, 242:243, 255:256, 268:273, 347:352, 426:431, 505:506, 518:519, 531:532, 544:545)]
	
##3 - renaming the columns of mergeddataset so they are easier to understanding the variable they are referring to
		columnnames <- c("volunteernumber", "activitytype",
		"timebodyaccelerationmeanaxisx",
		"timebodyaccelerationmeanaxisy",
		"timebodyaccelerationmeanaxisz",
		"timebodyaccelerationstdaxisx",
		"timebodyaccelerationstdaxisy",
		"timebodyaccelerationstdaxisz",
		"timegravityaccelerationmeanaxisx",
		"timegravityaccelerationmeanaxisy",
		"timegravityaccelerationmeanaxisz",
		"timegravityaccelerationstdaxisx",
		"timegravityaccelerationstdaxisy",
		"timegravityaccelerationstdaxisz",
		"timebodyaccelerationjerkmeanaxisx",
		"timebodyaccelerationjerkmeanaxisy",
		"timebodyaccelerationjerkmeanaxisz",
		"timebodyaccelerationjerkstdaxisx",
		"timebodyaccelerationjerkstdaxisy",
		"timebodyaccelerationjerkstdaxisz",
		"timebodygyroscopemeanaxisx",
		"timebodygyroscopemeanaxisy",
		"timebodygyroscopemeanaxisz",
		"timebodygyroscopestdaxisx",
		"timebodygyroscopestdaxisy",
		"timebodygyroscopestdaxisz",
		"timebodygyroscopejerkmeanaxisx",
		"timebodygyroscopejerkmeanaxisy",
		"timebodygyroscopejerkmeanaxisz",
		"timebodygyroscopejerkstdaxisx",
		"timebodygyroscopejerkstdaxisy",
		"timebodygyroscopejerkstdaxisz",
		"timebodyaccelerationmagnitudemean",
		"timebodyaccelerationmagnitudestd",
		"timegravityaccelerationmagnitudemean",
		"timegravityaccelerationmagnitudestd",
		"timebodyaccelerationjerkmagnitudemean",
		"timebodyaccelerationjerkmagnitudestd",
		"timebodygyroscopemagnitudemean",
		"timebodygyroscopemagnitudestd",
		"timebodygyroscopejerkmagnitudemean",
		"timebodygyroscopejerkmagnitudestd",
		"frequencybodyaccelerationmeanaxisx",
		"frequencybodyaccelerationmeanaxisy",
		"frequencybodyaccelerationmeanaxisz",
		"frequencybodyaccelerationstdaxisx",
		"frequencybodyaccelerationstdaxisy",
		"frequencybodyaccelerationstdaxisz",
		"frequencybodyaccelerationjerkmeanaxisx",
		"frequencybodyaccelerationjerkmeanaxisy",
		"frequencybodyaccelerationjerkmeanaxisz",
		"frequencybodyaccelerationjerkstdaxisx",
		"frequencybodyaccelerationjerkstdaxisy",
		"frequencybodyaccelerationjerkstdaxisz",
		"frequencybodygyroscopemeanaxisx",
		"frequencybodygyroscopemeanaxisy",
		"frequencybodygyroscopemeanaxisz",
		"frequencybodygyroscopestdaxisx",
		"frequencybodygyroscopestdaxisy",
		"frequencybodygyroscopestdaxisz",
		"frequencybodyaccelerationmagnitudemean",
		"frequencybodyaccelerationmagnitudestd",
		"frequencybodyaccelerationjerkmagnitudemean",
		"frequencybodyaccelerationjerkmagnitudestd",
		"frequencybodygyroscopemagnitudemean",
		"frequencybodygyroscopemagnitudestd",
		"frequencybodygyroscopejerkmagnitudemean",
		"frequencybodygyroscopejerkmagnitudestd")
			##renaming the columns of meanstdsubset
			colnames(meanstdsubset) <- sapply(columnnames, as.character)

			
##4 - rename the activities from numeric to descriptive names 
	##defined as 1 = walking, 2 = walkingupstairs, 3 = walkingdownstairs, 4 = sitting, 5 = standing, 6 = laying	
	meanstdsubset$activitytype = ifelse(meanstdsubset$activitytype == "1", "walking", meanstdsubset$activitytype)
	meanstdsubset$activitytype = ifelse(meanstdsubset$activitytype == "2", "walkingupstairs", meanstdsubset$activitytype)
	meanstdsubset$activitytype = ifelse(meanstdsubset$activitytype == "3", "walkingdownstairs", meanstdsubset$activitytype)
	meanstdsubset$activitytype = ifelse(meanstdsubset$activitytype == "4", "sitting", meanstdsubset$activitytype)
	meanstdsubset$activitytype = ifelse(meanstdsubset$activitytype == "5", "standing", meanstdsubset$activitytype)
	meanstdsubset$activitytype = ifelse(meanstdsubset$activitytype == "6", "laying", meanstdsubset$activitytype)

##5 - calculating the mean value for each variable by volunteer and each of their individual activities

	##5.1 - sorting the dataset by volunteer and then activity type, makes the dataset easier to read
	sortedsubset <- arrange(meanstdsubset, (volunteernumber), (activitytype))	

		##5.2 - reshaping the dataset into individual activities for each volunteer
		meltedsubset <- melt(sortedsubset, id.vars = c("volunteernumber", "activitytype"))

			##5.3 - calculating the mean values of all variables
			meansubset <- dcast(meltedsubset, volunteernumber + activitytype ~ variable, mean)
