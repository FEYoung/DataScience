Data Science Specialism

Module 4 - Case Study 2

Investigating the USA PM2.5 emissions in 1999 and 2012.

NOTE - PM2.5 monitoring began in 1999 with few monitoring stations but have increased over the time period under analysis.  Therefore the dataset of pm2012 is much larger than pm1999 as shown below: -

dim(pm2012)
[1] 1304287      28
dim(pm1999)
[1] 117421     28
===============================================================

EPA Air Pollution Data - online at http//goo.gl/soQZHM

The files are 

	RD_501_88101_1999-0.txt
	RD_501_88101_2012-0.txt

===============================================================
	
QUESTIONS

Has the level of PM2.5 reduced since 1999?

Do missing values have any significance within your data analysis?

===============================================================

R SCRIPT

##1 - loading the dataset and libraries
	##library(data.table) - now part of R3.2.0
	library(data.table)
	library(dplyr)
	library(reshape2)

	##loading 1999 dataset
	pm1999 <- read.table("RD_501_88101_1999-0.txt", comment.char = "#", header = FALSE, sep = "|", na.strings = "")
	##adding column identifies to 1999 dataset
	cnames1999 <- readLines("RD_501_88101_1999-0.txt", 1)
	cnames1999 <- strsplit(cnames1999, "|", fixed = TRUE)
	##adding the column names to the dataset
	names(pm1999) <- cnames1999[[1]]
	##adding full stops where blank spaces exist
	names(pm1999) <- make.names(cnames1999[[1]])

	##loading 2012 dataset
	pm2012 <- read.table("RD_501_88101_2012-0.txt", comment.char = "#", header = FALSE, sep = "|", na.strings = "")
	##adding column identifies to 1999 dataset
	cnames2012 <- readLines("RD_501_88101_2012-0.txt", 1)
	cnames2012 <- strsplit(cnames2012, "|", fixed = TRUE)
	##adding the column names to the dataset
	names(pm2012) <- cnames2012[[1]]
	##adding full stops where blank spaces exist
	names(pm2012) <- make.names(cnames2012[[1]])

===============================================================

##2 - doing a quick analysis on pm2.5 values 1999 & 2012 using the summary command

	##extracting pm2.5 column from each dataset
	pm25.1999 <- pm1999$Sample.Value
	pm25.2012 <- pm2012$Sample.Value
	
		#1999 data summary
		summary(pm25.1999)
		Min. 1st Qu.  Median    Mean   3rd Qu.  Max.    NA's 
		0.00    7.20   11.50   13.74   17.90  157.10   13217	
		##what percentage of dataset is NA values?
		mean(is.na(pm25.1999))
		[1] 0.1125608
		
		##2012 data summary
		summary(pm25.2012)
		Min. 1st Qu.  Median    Mean    3rd Qu.  Max.    NA's 
		-10.00    4.00    7.63    9.14   12.00  909.00   73133##what percentage of dataset is NA values?
		mean(is.na(pm25.2012)) 		
		[1] 0.05607125

===============================================================
		
##3 - basic exploratory graphics

	##GRAPH ONE - boxplot graph
	boxplot(pm25.1999, pm25.2012)
	
	##GRAPH TWO - boxplot to log values
	boxplot(log10(pm25.1999), log10(pm25.2012))

===============================================================

##4 - why is there negative minimum value in 2012?
	##this is impossible!
	##how many negative values are there?
 	negativevalues <- pm25.2012 < 0
	sum(negativevalues, na.rm = TRUE)
	[1] 26474
	##what percentage of entire dataset are negative values?
	mean(negativevalues, na.rm = TRUE)
	[1] 0.0215034
	
	##examining when the negative values occur during the year
	dates2012 <- pm2012$Date
	##date format yyyymmdd - converting to date format
	dates2012 <- as.Date(as.character(dates2012), "%Y%m%d")
	
	##GRAPH THREE - histogram of pm2.5 values for 2012
	hist(dates2012, "month")
	
	##GRAPH FOUR - histogram of negative pm2.5 values for 2012
	hist(dates2012[negativevalues], "month")

===============================================================
	
##5 - analysing data for one location that has values for both
	##1999 and 2012
	##how to find that location?
	
	##36 = NY State
	location1999 <- unique(subset(pm1999, State.Code == 36, c(County.Code, Site.ID)))
	location2012 <- unique(subset(pm2012, State.Code == 36, c(County.Code, Site.ID)))
	
	##joining the two columns together - County.Code, Site.ID
	dim(location1999)
	[1] 33  2
	dim(location2012)
	[1] 18  2
	location1999 <- paste(location1999[,1], location1999[,2], sep = ".")
	location2012 <- paste(location2012[,1], location2012[,2], sep = ".")
	
	##subsetting monitoring sites that appear in both year dataset
	bothlocations <- intersect(location1999, location2012)
	bothlocations
	[1] "1.5"     "1.12"    "5.80"    "13.11"   "29.5"    "31.3"   
	[7] "63.2008" "67.1015" "85.55"   "101.3" 

	===========================================================

	##PROBLEM - not enough data from this location let's find another location! 
	##How do do that from the entire dataset?
	
		##joining the two columns together for the entire datasets for each year as a new column named county.site at end of the dataset
		pm1999$county.site <- with(pm1999, paste(County.Code, Site.ID, sep = "."))
		pm2012$county.site <- with(pm2012, paste(County.Code, Site.ID, sep = "."))
		
		##subsetting for NY State = 36
		nys1999 <- subset(pm1999, State.Code == 36 & county.site %in% bothlocations)
		nys2012 <- subset(pm2012, State.Code == 36 & county.site %in% bothlocations)

	##splitting each dataset into parts in order to count the number of data samples for each location
	sapply(split(nys1999, nys1999$county.site), nrow)
	1.12   1.5   101.3   13.11    29.5    31.3    5.80 63.2008    67.1015   85.55
    61     122     152      61      61     183      61     122     122         7
	sapply(split(nys2012, nys2012$county.site), nrow)
	1.12   1.5   101.3   13.11    29.5    31.3    5.80   63.2008  67.1015   85.55
    31      64      31      31      33      15      31      30       31       7

	##examining data from county.code/Site.ID = 63.2008 
	##1999 - 122 samples
	##2012 - 30 samples

	##extraction of 63.2008 for each year in NY State
	subset1999 <- subset(pm1999, State.Code == 36 & County.Code == 63 & Site.ID == 2008)
	subset2012 <- subset(pm2012, State.Code == 36 & County.Code == 63 & Site.ID == 2008)
	##checking data subset is correct (as sapply above)
	dim(subset1999)
	[1] 122  29
 	dim(subset2012)
	[1] 30 29

	##extracting dates in order to produce graphs
	date1999 <- subset1999$Date
	dates1999 <- as.Date(as.character(date1999), "%Y%m%d")
	date2012 <- subset2012$Date
	dates2012 <- as.Date(as.character(date2012), "%Y%m%d")
	
	##GRAPH FIVE
	##plotting 1999 against PM2.5 values (122 samples - Jun/Jan)
	sample1999 <- subset1999$Sample.Value
	plot(dates1999, sample1999)

	##GRAPH SIX
	##plotting 2012 against PM2.5 values (30 samples - Jan/Mar)
	sample2012 <- subset2012$Sample.Value
	plot(dates2012, sample2012)
	
	##GRAPH SEVEN
	##plotting both years data in a single plot	
	par(mfrow = c(1,2), mar = c(4,4,2,1))
	plot(dates1999, sample1999, pch = 20)
	abline(h = median(sample1999, na.rm = TRUE))
	plot(dates2012, sample2012, pch = 20)
	abline(h = median(sample2012, na.rm = TRUE))	

	##PROBLEM - graphs cannot be compared as y axis ranges are different
	##		  - cannot compare directly as months are different 
	##setting the y axis to be equivalent in both graphs
	range <- range(sample1999, sample2012, na.rm = TRUE)

	##GRAPH EIGHT
	plot(dates1999, sample1999, pch = 20, ylim = range)
	abline(h = median(sample1999, na.rm = TRUE))
	plot(dates2012, sample2012, pch = 20, ylim = range)
	abline(h = median(sample2012, na.rm = TRUE))		

===============================================================
	
##6 - creating analysis of each state mean PM2.5 values for each year

	##calculating the mean value for each state for 1999
	mean1999 <- with(pm1999, tapply(Sample.Value, State.Code, mean, na.rm = TRUE))
	summary(mean1999)
	Min.   1st Qu.  Median  Mean   3rd Qu.  Max. 
	4.862   9.519  12.310  12.410  15.640  19.960 	
	
	##calculating the mean value for each state for 2012
	mean2012 <- with(pm2012, tapply(Sample.Value, State.Code, mean, na.rm = TRUE))
	summary(mean2012)
	Min.   1st Qu.  Median  Mean   3rd Qu.  Max. 
	4.006   7.355   8.729   8.759  10.610  11.990 

	##creating a dataframe with columns state name and mean value for 1999 and 2012
	state1999 <- data.frame(state = names(mean1999), mean = mean1999)
	state2012 <- data.frame(state = names(mean2012), mean = mean2012)

	##merging both datasets
	mergedyears <- merge(state1999, state2012, by = "state")
	
	##renaming columns to 1999 and 2012
	names(mergedyears) <- gsub("mean.x", "1999", names(mergedyears))
	names(mergedyears) <- gsub("mean.y", "2012", names(mergedyears))	
	
	##GRAPH NINE
	##plotting the points of each state for each year
	par(mfrow = c(1,1))
	with(mergedyears,
	plot(rep(1999, 52), mergedyears[,2], xlim = c(1998, 2013)))
	with(mergedyears,
	points(rep(2012, 52), mergedyears[,3]))

	##GRAPH TEN
	##joining each state by year with a line to see whether PM2.5 emissions have decreased
	##NOTE - very messy graph and very difficult to read!
	segments(rep(1999, 52), mergedyears[,2], rep(2012, 52), mergedyears[,3])
	
