DATA SPECIALISM

MODULE 4 - Exploratory data analysis

Project 2

Assignment

The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999–2008. You may use any R package you want to support your analysis.

Questions

You must address the following questions and tasks in your exploratory analysis.

For each question/task you will need to make a single plot. 

Unless specified, you can use any plotting system in R to make your plot.

==============================================================

PLOT 1

Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 

Using the base plotting system, make a plot showing the total PM2.5 emissions from all sources for each of the years 1999, 2002, 2005, and 2008.

================================================================

R SCRIPT

##1 - opening file to save graph
png("plot1.png")


	##2 - loading libraries and datasets
	library(dplyr)
	library(reshape2)
	NEI <- readRDS("summarySCC_PM25.rds")
	SCC <- readRDS("Source_Classification_Code.rds")


		##3 - merging the two datasets
		dataset <- merge(SCC, NEI, by = "SCC")

		
			##4 - creating a tidydataset
			
			##4.1 - subset with year, emissions
			pm25subset <- subset(dataset[c(18, 20)])
			
			##4.2 - renaming columns
			names(pm25subset) <- gsub("Emissions", "emissions", names(pm25subset))			
			

				##5 - calculating total emissions for each year
			
				##5.1 - reshaping the dataset into individual years
				meltedsubset <- melt(pm25subset, id.vars = c("year"))

				##5.2 - calculating the mean values of all variables
				finalsubset <- dcast(meltedsubset, year ~ variable, mean)

						
					##6 - plotting the graph
					plot(finalsubset$year, finalsubset$emissions, xlab="Year", ylab = "Emissions (tons)", main = "PM2.5 emissions \n for the United States of America \n for years 1999, 2002, 2005, and 2008", type = "o")					
						
##7 - closing graph save function
dev.off()

