Tidying a raw dataset based on the paper
Anguita D etal., (2012) "Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine" (full reference see readme.txt)
====================================================================================================================

1.	Experiment design

	Hypothesis - can a smartphone accelerometer and gyroscope be used to track the activity of a person?

	There were 30 volunteers within an age bracket of 19 - 48 years of age.

	Each volunteer was asked to complete the following activities one after the other in this order:
	
		sitting = sit down from a standing position, 
		standing = stand up from the sitting position, 
		laying = asked to lay down on a table from a standing position,
		walking = walk along a long corridor, 
		walkingdownstairs = descend 20 stairs, 
		walkingupstairs = ascend 20 stairs.

	A video of a volunteer carrying out the activities entitled "Activity recognition experiment using smartphone
	sensors" is available online from youtube.com at https://www.youtube.com/watch?v=XOEN9W05_4A
		
	The raw data codes and how they relate to descriptive names for each activity is defined here:

		1 -	walking
		
		2 -	walkingupstairs 
		
		3 -	walkingdownstairs
		
		4 -	sitting
		
		5 -	standing
		
		6 -	laying

	Two sets of data were taken: training and test. A number of volunteers were selected for the two tasks:
	
		Test data:	30% or 9 of the 30 volunteers were
						selected for this task.
						
		Training data: 	70% or 21 of the 30 volunteers were
						selected for this task.

	What the variable represent
	(quoted from the original codebook)

	"For each activity type data was collected on the X, Y, Z
	axis of the volunteers motion measured using the accelerometer (Acc) and gyroscope (Gyro) motion detectors embedded in a Samsung Android Galaxy S II smartphone strapped to their waist by a belt.
 
	These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. 

	Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

	Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

	Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals)." 		
						
====================================================================================================================
	
2.	Processing the raw data

	The following six files contained the raw data for this project:
	
	Test data:
		subject_test.txt
			volunteer numbers: 2, 4, 9, 10, 12, 13, 18, 20, 24
		X_test.txt
			measured variables: V1 - V561
		y_test.txt
			activity variables: 1 - 6

	Training data:
		subject_train.txt
			volunteer numbers: 1, 3, 5, 6, 7, 8, 11, 14, 15, 16, 17, 19, 21, 22, 23, 25, 26, 27, 28, 29, 30
		X_train.txt
			measured variables: V1 - V561
		y_train.txt
			activity variables: 1 - 6

	
	1.	three R libraries were loaded before raw data was processed:
	
		data.table
		dplyr
		reshape2
		
	2.	The six raw data files were translated into tables and merged
		into one table - 
		
		2.1	compiling the test data
		2.2	compiling the training data
		2.3 merging both datasets
		
	3.	As per the instructions the columns that related to mean and
		standard deviation for each of the 17 variables (raw data codes below) were extracted from the merged dataset
			tBodyAcc-XYZ (6 columns)
			tGravityAcc-XYZ (6 columns)
			tBodyAccJerk-XYZ (6 columns)
			tBodyGyro-XYZ (6 columns)
			tBodyGyroJerk-XYZ (6 columns)
			tBodyAccMag (2 columns)
			tGravityAccMag (2 columns)
			tBodyAccJerkMag (2 columns)
			tBodyGyroMag (2 columns)
			tBodyGyroJerkMag (2 columns)
			fBodyAcc-XYZ (6 columns)
			fBodyAccJerk-XYZ (6 columns)
			fBodyGyro-XYZ (6 columns)
			fBodyAccMag (2 columns)
			fBodyAccJerkMag (2 columns)
			fBodyGyroMag (2 columns)
			fBodyGyroJerkMag (2 columns)
		ALSO the first two columns of the raw dataset representing volunteer and activity were also extracted
	
	4.	the raw column names were renamed for ease of reading, thus
		V1
			volunteer number
		V1.1
			activity type
		tBodyAcc-XYZ (6 columns)
			timebodyaccelerationmeanaxisx
			timebodyaccelerationmeanaxisy
			timebodyaccelerationmeanaxisz
			timebodyaccelerationstdaxisx
			timebodyaccelerationstdaxisy
			timebodyaccelerationstdaxisz			
	
		tGravityAcc-XYZ (6 columns)
			timegravityaccelerationmeanaxisx
			timegravityaccelerationmeanaxisy
			timegravityaccelerationmeanaxisz
			timegravityaccelerationstdaxisx
			timegravityaccelerationstdaxisy
			timegravityaccelerationstdaxisz	
		
		tBodyAccJerk-XYZ (6 columns)
			timebodyaccelerationjerkmeanaxisx
			timebodyaccelerationjerkmeanaxisy
			timebodyaccelerationjerkmeanaxisz
			timebodyaccelerationjerkstdaxisx
			timebodyaccelerationjerkstdaxisy
			timebodyaccelerationjerkstdaxisz		
		
		tBodyGyro-XYZ (6 columns)
			timebodygyroscopemeanaxisx
			timebodygyroscopemeanaxisy
			timebodygyroscopemeanaxisz
			timebodygyroscopestdaxisx
			timebodygyroscopestdaxisy
			timebodygyroscopestdaxisz		
		
		tBodyGyroJerk-XYZ (6 columns)
			timebodygyroscopejerkmeanaxisx
			timebodygyroscopejerkmeanaxisy
			timebodygyroscopejerkmeanaxisz
			timebodygyroscopejerkstdaxisx
			timebodygyroscopejerkstdaxisy
			timebodygyroscopejerkstdaxisz		
		
		tBodyAccMag (2 columns)
			timebodyaccelerationmagnitudemean
			timebodyaccelerationmagnitudestd
		
		tGravityAccMag (2 columns)
			timegravityaccelerationmagnitudemean
			timegravityaccelerationmagnitudestd		
		
		tBodyAccJerkMag (2 columns)
			timebodyaccelerationjerkmagnitudemean
			timebodyaccelerationjerkmagnitudestd	
		
		tBodyGyroMag (2 columns)
			timebodygyroscopemagnitudemean
			timebodygyroscopemagnitudestd

		tBodyGyroJerkMag (2 columns)
			timebodygyroscopejerkmagnitudemean
			timebodygyroscopejerkmagnitudestd
		
		fBodyAcc-XYZ (6 columns)
			frequencybodyaccelerationmeanaxisx
			frequencybodyaccelerationmeanaxisy
			frequencybodyaccelerationmeanaxisz
			frequencybodyaccelerationstdaxisx
			frequencybodyaccelerationstdaxisy
			frequencybodyaccelerationstdaxisz
		
		fBodyAccJerk-XYZ (6 columns)
			frequencybodyaccelerationjerkmeanaxisx
			frequencybodyaccelerationjerkmeanaxisy
			frequencybodyaccelerationjerkmeanaxisz
			frequencybodyaccelerationjerkstdaxisx
			frequencybodyaccelerationjerkstdaxisy
			frequencybodyaccelerationjerkstdaxisz		
		
		fBodyGyro-XYZ (6 columns)
			frequencybodygyroscopemeanaxisx
			frequencybodygyroscopemeanaxisy
			frequencybodygyroscopemeanaxisz
			frequencybodygyroscopestdaxisx
			frequencybodygyroscopestdaxisy
			frequencybodygyroscopestdaxisz	
		
		fBodyAccMag (2 columns)
			frequencybodyaccelerationmagnitudemean
			frequencybodyaccelerationmagnitudestd		
		
		fBodyAccJerkMag (2 columns)
			frequencybodyaccelerationjerkmagnitudemean
			frequencybodyaccelerationjerkmagnitudestd		
		
		fBodyGyroMag (2 columns)
			frequencybodygyroscopemagnitudemean
			frequencybodygyroscopemagnitudestd		
					
		fBodyGyroJerkMag (2 columns)
			frequencybodygyroscopejerkmagnitudemean
			frequencybodygyroscopejerkmagnitudestd	

	5.	renaming the activities from numeric to descriptive names

	6.	calculating the mean value for each variable, activity type for each volunteer
		6.1 - sorting the data by volunteer and activity
		6.2 - reshaping the data into individual activities for each volunteer for each variable means and standard deviation
		6.3 - calculating the mean of each variable
