DATA SPECIALISM

MODULE 4 - Exploratory data analysis

Project 2

Assignment

The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999–2008. You may use any R package you want to support your analysis.

Questions

You must address the following questions and tasks in your exploratory analysis.

For each question/task you will need to make a single plot. 

Unless specified, you can use any plotting system in R to make your plot.

========================================================================

PLOT 3 

Of the four types of sources indicated by the 
type (point, nonpoint, onroad, nonroad) variable, 
which of these four sources have seen decreases in emissions from 1999–2008 for 
Baltimore City (fips == "24510")?

Which have seen increases in emissions from 1999–2008? 

Use the ggplot2 plotting system to make a plot answer this question.

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
		
		##3.1 - subsetting data.category, fips, emission and year
		mergedsubset <- subset(dataset[c(2, 16, 18, 20)])

		##3.2 - renaming columns
		names(mergedsubset) <- gsub("Data.Category", "category", names(mergedsubset))
		names(mergedsubset) <- gsub("fips", "area", names(mergedsubset))
		names(mergedsubset) <- gsub("Emissions", "emissions", names(mergedsubset))

		##3.3 - selecting Baltimore City subset "24510"
		baltimoresubset <- subset(mergedsubset, area == 24510)
		baltimoresubset <- subset(baltimoresubset[c(1, 3, 4)])
		
		##3.4 - sorting the data by year
		baltimoresubset <- arrange(baltimoresubset, (year), (category))

				
			##4 - calculating total emissions for each year

			##4.1 - reshaping the dataset into individual years
			meltedsubset <- melt(baltimoresubset, id.vars = c("year", "category"))

			##4.2 - calculating the mean values of all variables
			finalsubset <- dcast(meltedsubset, year + category ~ variable, mean)
			
			##4.3 - removing row one as not applicable
			finalsubset <- finalsubset[-1,]

			
				##5 - plotting the graph using ggplot2 package
				graph <- qplot(year, emissions, data = finalsubset, xlab ="Year", ylab = "Emissions (tons)")

				graph + ggtitle("PM2.5 emissions in Baltimore City \n for four sources: point, nonpoint, onroad, nonroad \n from 1999 to 2008 \n") + facet_grid(category~., scales = "free_y") + stat_smooth()			
 						
				##6 - saving the graph to a png file
				dev.copy(png, "plot3.png")
				dev.off()
