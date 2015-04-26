DATA SPECIALISM

MODULE 4 - Exploratory data analysis

Project 2

Assignment

The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999–2008. You may use any R package you want to support your analysis.

Questions

You must address the following questions and tasks in your exploratory analysis.

For each question/task you will need to make a single plot. 

Unless specified, you can use any plotting system in R to make your plot.

===============================================================

PLOT 6

Compare emissions from motor vehicle sources in Baltimore City (fips == "24510") with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). 

Which city has seen greater changes over time in motor vehicle emissions?

===============================================================


R SCRIPT

##1 - loading libraries and datasets
library(dplyr)
library(reshape2)
library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


	##2 - merging the two datasets
	dataset <- merge(SCC, NEI, by = "SCC")
	
	
		##3 - creating a tidydataset
		
		##3.1 - subsetting pollutant, fips, emission and year
		mergedsubset <- subset(dataset[c(2, 9, 16, 18, 20)])

		##3.2 - renaming columns
		names(mergedsubset) <- gsub("Data.Category", "category", names(mergedsubset))
		names(mergedsubset) <- gsub("SCC.Level.Three", "pollutant", names(mergedsubset))
		names(mergedsubset) <- gsub("fips", "area", names(mergedsubset))
		names(mergedsubset) <- gsub("Emissions", "emissions", names(mergedsubset))
	
		##3.3 - selecting Baltimore City subset "24510"
		baltimoresubset <- subset(mergedsubset, area == "24510")

		##3.4 - selecting Los Angeles subset "06037"
		lasubset <- subset(mergedsubset, area == "06037")

		##3.5 - merging Baltimore City and LA subsets
		citysubset <- rbind(baltimoresubset, lasubset)
				
		##3.4 - selecting the motors subset 
		motorsubset <- subset(citysubset, category == "Onroad")
		motorsubset <- subset(motorsubset[c(2:5)])

		##3.5 - renaming area codes to city names
		motorsubset$area = ifelse(motorsubset$area == "06037", "Los Angeles County", motorsubset$area)
		motorsubset$area = ifelse(motorsubset$area == "24510", "Baltimore City", motorsubset$area)		
		
		##3.6 - sorting the data by year
		motorsubset <- arrange(motorsubset, (area), (year), (pollutant))

		
	        ##4 - calculating total emissions for each year

			##4.1 - reshaping the dataset into individual years
			meltedsubset <- melt(motorsubset, id.vars = c("year", "area", "pollutant"))
		   
			##4.2 - calculating the mean values of all variables
			finalsubset <- dcast(meltedsubset, year + area + pollutant ~ variable, mean)           

			
				##5 - plotting the graph using ggplot2 package
				##compare motor vehicle emissions 
				##Baltimore City and Los Angeles			
				graph <- qplot(year, emissions, data = finalsubset, color = area, xlab ="Year", ylab = "Emissions (tons)")

				graph + ggtitle("PM2.5 emissions in Baltimore City and Los Angeles County \n for motor vehicle sources from 1999 to 2008\n") + facet_grid(pollutant~., scales = "free_y") + theme(strip.text.y = element_text(size = 8, angle = 0)) + stat_smooth()

		
					##6 - saving the graph to a png file
					dev.copy(png, "plot6.png", width = 1024, height = 640)
					dev.off()
