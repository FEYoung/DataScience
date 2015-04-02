##loading libraries that will be used during the tidying of the raw data
library(data.table)
library(dplyr)
library(reshape2)

##1 - merging the six datasets into one dataset - 

	#1.1 the variable names	
		variables <- read.table("features.txt", col.names = c("variablenumber", "variablename"))

	##1.2 test dataset compilation

		##reading the test txt files into tables
		volunteerstest <- read.table("subject_test.txt", col.names = c("volunteernumber"))
		variablestest <- read.table("X_test.txt", header = F, col.names = variables$variablename)
		activitytest <- read.table("y_test.txt", col.names = c("activitytype"))

			##merging the three datasets into one table - test dataset
			testdataset <- cbind(volunteerstest, activitytest, variablestest)	
		
	##1.3 training dataset compilation
			
		##reading the training txt files into tables
		volunteerstraining <- read.table("subject_train.txt", col.names = c("volunteernumber"))
		variablestraining <- read.table("X_train.txt", header = F, col.names = variables$variablename)
		activitytraining <- read.table("y_train.txt", col.names = c("activitytype"))

			##merging the three datasets into one table - training dataset
			trainingdataset <- cbind(volunteerstraining, activitytraining, variablestraining)

	##merging both datasets
	mergedsubset <- rbind(testdataset, trainingdataset)
			
			
##2 - extracting measurements with mean and standard deviation only for the following 17 variables:

	##tBodyAcc-XYZ, tGravityAcc-XYZ, tBodyAccJerk-XYZ, tBodyGyro-XYZ, tBodyGyroJerk-XYZ, tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag, fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccMag, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag.
	meanstd <- grepl("mean|std|volunteernumber|activitytype", colnames(mergedsubset)) & !grepl("meanFreq", colnames(mergedsubset))
	meanstdsubset <- mergedsubset[, meanstd]

	
##3 - renaming the columns of mergeddataset so they are easier to understand the variable they are referring to

	names(meanstdsubset) <- gsub("^t", "time", names(meanstdsubset))
	names(meanstdsubset) <- gsub("Body", "body", names(meanstdsubset))
	names(meanstdsubset) <- gsub("Gravity", "gravity", names(meanstdsubset))
	names(meanstdsubset) <- gsub("Acc", "accelerometer", names(meanstdsubset))	
	names(meanstdsubset) <- gsub("Gyro", "gyroscope", names(meanstdsubset))
	names(meanstdsubset) <- gsub("Jerk", "jerk", names(meanstdsubset))
	names(meanstdsubset) <- gsub("Mag","magnitude", names(meanstdsubset))
	names(meanstdsubset) <- gsub("^f","frequency", names(meanstdsubset))
	names(meanstdsubset) <- gsub("X", "axisx", names(meanstdsubset))
	names(meanstdsubset) <- gsub("Y", "axisy", names(meanstdsubset))
	names(meanstdsubset) <- gsub("Z", "axisz", names(meanstdsubset))
	names(meanstdsubset) <- gsub("[.]", "", names(meanstdsubset))
	
			
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

			
##saving the output to a text file
write.table(meansubset, "tidydataset.txt", row.name = FALSE)			
