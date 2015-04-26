DATA SPECIALISM

MODULE 4 - Exploratory data analysis

Project 2 Assignment

The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999–2008. You may use any R package you want to support your analysis.

Questions

You must address the following questions and tasks in your exploratory analysis.

For each question/task you will need to make a single plot. 

Unless specified, you can use any plotting system in R to make your plot.

===============================================================

PLOT 5

How have emissions from motor vehicle sources changed from 1999 – 2008 in Baltimore City (fips == "24510")? 

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
		baltimoresubset <- subset(mergedsubset, area == 24510)
		baltimoresubset <- subset(baltimoresubset[c(1:2, 4:5)])

		##3.4 - selecting the motors subset 
		baltimoresubset <- subset(baltimoresubset, category == "Onroad")
		baltimoresubset <- subset(baltimoresubset[c(2:4)])
	
		##3.5 - sorting the data by year
		baltimoresubset <- arrange(baltimoresubset, (year), (pollutant))

		
	        ##4 - calculating total emissions for each year

			##4.1 - reshaping the dataset into individual years
			meltedsubset <- melt(baltimoresubset, id.vars = c("year", "pollutant"))
		   
			##4.2 - calculating the mean values of all variables
			finalsubset <- dcast(meltedsubset, year + pollutant ~ variable, mean)           

			
				##5 - plotting the graph using ggplot2 package
				graph <- qplot(year, emissions, data = finalsubset, xlab ="Year", ylab = "Emissions (tons)")
			   
				graph + ggtitle("PM2.5 emissions in Baltimore City for motor vehicle sources - 1999 to 2008 \n") + facet_grid(pollutant~., scales = "free") + theme(strip.text.y = element_text(size = 8, angle = 0)) + stat_smooth()

	 
					##6 - saving the graph to a png file
					dev.copy(png, "plot5.png", width = 768, height = 480, units = "px")
					dev.off()
