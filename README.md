Young FE (2015) COURSE PROJECT based on the paper entitled:

"Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine" (see below for reference)

assignment for the

DATA SCIENCE SPECIALISM: Module 3 - Getting and Cleaning Data 

Author: Jeff Leek
Associate Professor of Biostatistics
Bloomberg School of Public Health
Johns Hopkins University, Baltimore, Maryland, USA

available online at https://class.coursera.org/getdata-012

==============================================================

The raw dataset is available online from:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

when unzipped "UCI HAR Dataset" includes the following files and directories:

	activity_labels.txt - activity number and name 
	features.txt - list of variables 1 - 561
	features_info.txt - description of variables
	readme.txt - information regarding the experiment
		SUBDIRECTORY - test
		subject_test.txt  
		X_test.txt 
		y_test.txt
			SUBDIRECTORY - Inertial Signals
			body_acc_x_test.txt
			body_acc_y_test.txt
			body_acc_z_test.txt
			body_gyro_x_test.txt
			body_gyro_y_test.txt
			body_gyro_z_test.txt
			total_acc_x_test.txt
			total_acc_y_test.txt
			total_acc_z_test.txt
		SUBDIRECTORY - train
		subject_train.txt
		X_train.txt
		y_train.txt
			SUBDIRECTORY - Inertial Signals
			body_acc_x_train.txt
			body_acc_y_train.txt
			body_acc_z_train.txt
			body_gyro_x_train.txt
			body_gyro_y_train.txt
			body_gyro_z_train.txt
			total_acc_x_train.txt
			total_acc_y_train.txt
			total_acc_z_train.txt
			
==============================================================

A selection of the files above were used in cleaning the dataset and they are :
(included in this branch) 

	features.txt - list of the variable names

	subject_test.txt - volunteer numbers: 2, 4, 9, 10, 12, 13, 18, 20, 24
	X_test.txt - measured variables: V1 - V561
	y_test.txt - activity variables: 1 - 6
	
	subject_train.txt - volunteer numbers: 1, 3, 5, 6, 7, 8, 11, 14, 15, 16, 17, 19, 21, 22, 23, 25, 26, 27, 28, 29, 30
	X_train.txt - measured variables: V1 - V561
	y_train.txt - activity variables: 1 - 6
		
==============================================================	

In addition there are two other files:

1.	codebook.md - contains three sections detailing the:

	1.	design of the experiment;

	2.	choices made to process the dataset;

	3.	information on the variables selected;

2.	run_analysis.R - contains the R script to process the
	dataset following the instructions stated. However, I swapped tasks 3 and 4 as it was easier to rename the
	variables this way around.
	
	1.	Merges the training and the test data sets to create one
		data set. 

	2. 	Extracts only the measurements on the mean and
		standard deviation for each measurement.

	3.	Appropriately labels the data set with descriptive
		variable names. 

	4.	Uses descriptive activity names to name the activities
		in the data set 

	5. 	From the data set in step 4,
		creates a second, independent tidy data set with the average of each variable for each activity and each subject.

==============================================================	

Reference sources:

1.	Inside Activity Tracking (2013) "Data Science, wearable computing and
	the battle for the Throne as World's Top Sports Brand" accessed at 13:30 on 04 March 2015 from
    	http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/

2.	UCI Machine Learning Repository
	"Human Activity Recognition using Smartphones Data Set"
	available online at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

3.	Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra, Jorge L.
	Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector
	Machine. 4th International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012.
	Published in:
	Bravo J, Hervas R, Rodriguez M (Eds.), Lecture Notes in Computer Science - Ambient Assisted Living and Home
	Care, Vol. 7657, pp. 216-223 Stringer-Verlag Berlin, Heidelberg available online at
	www.springer.com/gb/book/9783642353949

4.	A video of the experiment entitled "Activity recognition experiment
	using smartphone sensors" is available online from youtube.com at https://www.youtube.com/watch?v=XOEN9W05_4A
		
==============================================================
