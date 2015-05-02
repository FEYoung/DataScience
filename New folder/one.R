Case Study One

Accelerometer and gyroscope - Samsung Galaxy 2

##1 - loading the dataset and libraries
##library(data.table) - now part of R3.2.0
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
		
##0 - renaming dataset
samsung <- sortedsubset

==============================================================	
		
	##1 - GRAPH ONE 
	##plotting mean acceleration x & y axis for first subject
	##scatter graph
		par(mfrow = c(1,2), mar = c(5,4,1,1))
		samsung <- transform(samsung, activitytype = factor(activitytype))
		subject1 <- subset(samsung, volunteernumber == 1)
		
		##graph one
		plot(subject1[,3], col = subject1$activitytype, ylab = names(subject1)[3])
		
		##graph two
		plot(subject1[,4], col = subject1$activitytype, ylab = names(subject1)[4])
		
		##legend
		legend("bottomright", legend = unique(subject1$activitytype), col = unique(subject1$activitytype), pch = 1)

==============================================================

	##2 - GRAPH TWO

	##function - myplclust to create dendrogram
	myplclust <- function( hclust, lab=hclust$labels, lab.col=rep(1,length(hclust$labels)), hang=0.1,...){
	 ## modifiction of plclust for plotting hclust objects *in colour*!
	 ## Copyright Eva KF Chan 2009
	 ## Arguments:
	 ## hclust:  hclust object
	 ## lab:  a character vector of labels of the leaves of the tree
	 ## lab.col:  colour for the labels; NA=default device foreground colour
	 ##hang:  as in hclust & plclust
	 ##Side effect:
	 ##A display of hierarchical cluster with coloured leaf labels.
	 y <- rep(hclust$height,2)
	 x <- as.numeric(hclust$merge)
	 y <- y[which(x<0)]
	 x <- x[which(x<0)]
	 x <- abs(x)
	 y <- y[order(x)]
	 x <- x[order(x)]
	 plot( hclust, labels=FALSE, hang=hang, ... )
	 text( x=x, y=y[hclust$order]-(max(hclust$height)*hang), labels=lab[hclust$order], col=lab.col[hclust$order], srt=90, adj=c(1,0.5), xpd=NA, ... )}
	
	
		##2.1 - loading library
		library(ggplot2)

		##2.2 - plotting a cluster graph
		par(mfrow = c(1,1))
		subset <- dist(subject1[, 2:3])
		cluster <- hclust(subset)
		myplclust(cluster, lab.col = unclass(subject1$activitytype))
		
==============================================================	
MAX ACCELERATION FOR VOLUNTEER NUMBER 1
using the entire dataset

##1 - loading the dataset and libraries
##library(data.table) - now part of R3.2.0
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
	

##0 - renaming dataset
entiredataset <- mergedsubset

	##1 - subsetting the dataset for maximum acceleration
	##columns 12 - 14
	maxacceleration <- entiredataset[c(1,2, 12:14)]

		##2 - rename the activities from numeric to descriptive names 
		##defined as 1 = walking, 2 = walkingupstairs, 3 = walkingdownstairs, 4 = sitting, 5 = standing, 6 = laying	
		maxacceleration$activitytype = ifelse(maxacceleration$activitytype == "1", "walking", maxacceleration$activitytype)
		maxacceleration$activitytype = ifelse(maxacceleration$activitytype == "2", "walkingupstairs", maxacceleration$activitytype)
		maxacceleration$activitytype = ifelse(maxacceleration$activitytype == "3", "walkingdownstairs", maxacceleration$activitytype)
		maxacceleration$activitytype = ifelse(maxacceleration$activitytype == "4", "sitting", maxacceleration$activitytype)
		maxacceleration$activitytype = ifelse(maxacceleration$activitytype == "5", "standing", maxacceleration$activitytype)
		maxacceleration$activitytype = ifelse(maxacceleration$activitytype == "6", "laying", maxacceleration$activitytype)
		
			##3 - renaming the columns of mergeddataset so they are easier to understand the variable they are referring to
			names(maxacceleration) <- gsub("^t", "time", names(maxacceleration))
			names(maxacceleration) <- gsub("Body", "body", names(maxacceleration))
			names(maxacceleration) <- gsub("max", "maximum", names(maxacceleration))
			names(maxacceleration) <- gsub("Acc", "accelerometer", names(maxacceleration))
			names(maxacceleration) <- gsub("X", "axisx", names(maxacceleration))
			names(maxacceleration) <- gsub("Y", "axisy", names(maxacceleration))
			names(maxacceleration) <- gsub("Z", "axisz", names(maxacceleration))
			names(maxacceleration) <- gsub("[.]", "", names(maxacceleration))
			
=============================================================	
				##4 - GRAPH ONE
				##xy graph for columns 3, 4, 5
				##for volunteer number one only
				subject1 <- subset(maxacceleration, volunteernumber == 1)
				
				par(mfrow = c(1,3))
				plot(subject1[,3], pch = 19, col = maxacceleration$activitytype, ylab = names(maxacceleration)[3])
				plot(subject1[,4], pch = 19, col = maxacceleration$activitytype, ylab = names(maxacceleration)[4])
				plot(subject1[,5], pch = 19, col = maxacceleration$activitytype, ylab = names(maxacceleration)[5])
				
==============================================================	
					##5 - GRAPH TWO
					##cluster graph for columns 3:5
						##function - myplclust to create dendrogram
						myplclust <- function( hclust, lab=hclust$labels, lab.col=rep(1,length(hclust$labels)), hang=0.1,...){
						 ## modifiction of plclust for plotting hclust objects *in colour*!
						 ## Copyright Eva KF Chan 2009
						 ## Arguments:
						 ## hclust:  hclust object
						 ## lab:  a character vector of labels of the leaves of the tree
						 ## lab.col:  colour for the labels; NA=default device foreground colour
						 ##hang:  as in hclust & plclust
						 ##Side effect:
						 ##A display of hierarchical cluster with coloured leaf labels.
						 y <- rep(hclust$height,2)
						 x <- as.numeric(hclust$merge)
						 y <- y[which(x<0)]
						 x <- x[which(x<0)]
						 x <- abs(x)
						 y <- y[order(x)]
						 x <- x[order(x)]
						 plot( hclust, labels=FALSE, hang=hang, ... )
						 text( x=x, y=y[hclust$order]-(max(hclust$height)*hang), labels=lab[hclust$order], col=lab.col[hclust$order], srt=90, adj=c(1,0.5), xpd=NA, ... )}

					subject1 <- subset(maxacceleration, volunteernumber == 1)					
					par(mfrow = c(1,1))
					maxacceleration <- dist(subject1[, 3:5])
					cluster <- hclust(maxacceleration)
					myplclust(cluster, lab.col = unclass(subject1$activitytype))
			
=============================================================

						##6 - GRAPH THREE
						##singular value decomposition graph
						##using entire dataset for
						##volunteer number 1
						##looking at columns 3:5 - x,y,z axes of timebodyaccelerationmean
						subject1 <- subset(entiredataset, volunteernumber == 1)
						svd = svd(scale(subject1[,-c(1:2)]))
						par(mfrow = c(1,3))
						##timebodyaccelerationmeanaxisx
						plot(svd$u[,1], col = subject1$activitytype, pch = 19)
						##timebodyaccelerationmeanaxisy
						plot(svd$u[,2], col = subject1$activitytype, pch = 19)
						##timebodyaccelerationmeanaxisz
						plot(svd$u[,3], col = subject1$activitytype, pch = 19)
						
=============================================================

							##7 - GRAPH FOUR
							##finding the maximum contributor ##for volunteer number 1
							##e.g. greatest variation in the dataset
							subject1 <- subset(entiredataset, volunteernumber == 1)
							svd = svd(scale(subject1[,-c(1,2)]))
							par(mfrow = c(1,1))
							##$v = variation
							plot(svd$v[,2], pch = 19)
							
=============================================================

							##8 - GRAPH FIVE
							##dendrogram of the maximum contributor (variation) for volunteer number 1
							
								##function - myplclust to create dendrogram
								myplclust <- function( hclust, lab=hclust$labels, lab.col=rep(1,length(hclust$labels)), hang=0.1,...){
								 ## modifiction of plclust for plotting hclust objects *in colour*!
								 ## Copyright Eva KF Chan 2009
								 ## Arguments:
								 ## hclust:  hclust object
								 ## lab:  a character vector of labels of the leaves of the tree
								 ## lab.col:  colour for the labels; NA=default device foreground colour
								 ##hang:  as in hclust & plclust
								 ##Side effect:
								 ##A display of hierarchical cluster with coloured leaf labels.
								 y <- rep(hclust$height,2)
								 x <- as.numeric(hclust$merge)
								 y <- y[which(x<0)]
								 x <- x[which(x<0)]
								 x <- abs(x)
								 y <- y[order(x)]
								 x <- x[order(x)]
								 plot( hclust, labels=FALSE, hang=hang, ... )
								 text( x=x, y=y[hclust$order]-(max(hclust$height)*hang), labels=lab[hclust$order], col=lab.col[hclust$order], srt=90, adj=c(1,0.5), xpd=NA, ... )}
						 
							subject1 <- subset(entiredataset, volunteernumber == 1)
							svd = svd(scale(subject1[,-c(1,2)]))
							##looking at maximum variation of columns 10, 11 $ 12
							##timebodyaccelerationmeanaxisx, ##timebodyaccelerationmeanaxisy,
							##timebodyaccelerationmeanaxisz
							maxvar <- which.max(svd$v[,2])
							matrix <- dist(subject1[, c(10:12 , maxvar)])
							cluster <- hclust(matrix)
							myplclust(cluster, lab.col = unclass(subject1$activitytype))
							
=============================================================

##K-MEANS CLUSTERING
##entiredataset for volunteer number 1

	##2 - rename the activities from numeric to descriptive names 
	##defined as 1 = walking, 2 = walkingupstairs, 3 = walkingdownstairs, 4 = sitting, 5 = standing, 6 = laying	
	kmeansdataset <- entiredataset
		
	kmeansdataset$activitytype = ifelse(kmeansdataset$activitytype == "1", "walking", kmeansdataset$activitytype)
	kmeansdataset$activitytype = ifelse(kmeansdataset$activitytype == "2", "walkingupstairs", kmeansdataset$activitytype)
	kmeansdataset$activitytype = ifelse(kmeansdataset$activitytype == "3", "walkingdownstairs", kmeansdataset$activitytype)
	kmeansdataset$activitytype = ifelse(kmeansdataset$activitytype == "4", "sitting", kmeansdataset$activitytype)
	kmeansdataset$activitytype = ifelse(kmeansdataset$activitytype == "5", "standing", kmeansdataset$activitytype)
	kmeansdataset$activitytype = ifelse(kmeansdataset$activitytype == "6", "laying", kmeansdataset$activitytype)


##1 - CLUSTER TABLE 1 - creating the cluster table
subject1 <- subset(kmeansdataset, volunteernumber == 1)
##centers relate to each activity type
kClust <- kmeans(subject1[, -c(1:2)], centers = 6)
table(kClust$cluster, subject1$activitytype)

RESULT - 

     laying   sitting standing walking walkingdownstairs walkingupstairs
  1     27       0        0       0                 0               0
  2      9       2        0       0                 0               0
  3      0      34       50       0                 0               0
  4      0       0        0      95                49               0
  5     14      11        3       0                 0               0
  6      0       0        0       0                 0              53

 
	##2 - CLUSTER TABLE 2 - creating the cluster table
	subject1 <- subset(kmeansdataset, volunteernumber == 1)
	##centers relate to each activity type
	##nstart = number of times the algorithm works in order to final the optimum solution <- 1
	kClust <- kmeans(subject1[, -c(1:2)], centers = 6, nstart = 1)
	table(kClust$cluster, subject1$activitytype) 
 
RESULT - 
 
      laying sitting standing walking walkingdownstairs walkingupstairs
  1     16      12        7       0                 0               0
  2     24      33       46       0                 0               0
  3     10       2        0       0                 0               0
  4      0       0        0       0                 0              53
  5      0       0        0       0                49               0
  6      0       0        0      95                 0               0
  
		##3 - CLUSTER TABLE 3 - creating the cluster table
		subject1 <- subset(kmeansdataset, volunteernumber == 1)
		##centers relate to each activity type
		##nstart = number of times the algorithm works in order to final the optimum solution <- 100
		kClust <- kmeans(subject1[, -c(1:2)], centers = 6, nstart = 1000)
		table(kClust$cluster, subject1$activitytype) 

RESULT - 

      laying sitting standing walking walkingdownstairs walkingupstairs
  1      0      37       51       0                 0               0
  2      0       0        0       0                49               0
  3      3       0        0       0                 0              53
  4     29       0        0       0                 0               0
  5      0       0        0      95                 0               0
  6     18      10        2       0                 0               0

  
##3 - CLUSTER TABLE 3 - creating the cluster table
		subject1 <- subset(kmeansdataset, volunteernumber == 1)
		##centers relate to each activity type
		##nstart = number of times the algorithm works in order to final the optimum solution <- 100
		kClust <- kmeans(subject1[, -c(1:2)], centers = 6, nstart = 1000)
		table(kClust$cluster, subject1$activitytype)

RESULT - 

   laying sitting standing walking walkingdownstairs walkingupstairs
  1     29       0        0       0                 0               0
  2      0      37       51       0                 0               0
  3      0       0        0       0                49               0
  4      3       0        0       0                 0              53
  5     18      10        2       0                 0               0
  6      0       0        0      95                 0               0

OPTIMUM VALUE THE SAME AS nstart = 100


##K-MEANS CLUSTERING GRAPHS

	##graph 1 - laying
	##for columns 1 - 30
	plot(kClust$center[1, 1:30], pch = 19, ylab = "Cluster Centre", xlab ="", main = "Activity type - laying")

 ##graph 2 - sitting
	##for columns 1 - 30
	plot(kClust$center[2, 1:30], pch = 19, ylab = "Cluster Centre", xlab ="", main = "Activity type - sitting")
	
 ##graph 3 - standing
	##for columns 1 - 30
	plot(kClust$center[3, 1:30], pch = 19, ylab = "Cluster Centre", xlab ="", main = "Activity type - standing")

##graph 4 - walking
	##for columns 1 - 30
	plot(kClust$center[4, 1:30], pch = 19, ylab = "Cluster Centre", xlab ="", main = "Activity type - walking")
	
##graph 5 - walking downstairs
	##for columns 1 - 30
	plot(kClust$center[5, 1:30], pch = 19, ylab = "Cluster Centre", xlab ="", main = "Activity type - walking downstairs")
	
##graph 6 - walking upstairs
	##for columns 1 - 30
	plot(kClust$center[6, 1:30], pch = 19, ylab = "Cluster Centre", xlab ="", main = "Activity type - walking upstairs")
	
		