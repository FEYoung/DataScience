DATA SPECIALISM

MODULE 4 - Exploratory data analysis

Project 2

Assignment

The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999–2008. You may use any R package you want to support your analysis.

Question

You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. 

Unless specified, you can use any plotting system in R to make your plot.

==============================================================

PLOT 2 
 
Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 

Use the base plotting system to make a plot answering this question.

==============================================================

R SCRIPT

##1 - opening file to save graph
png("plot2.png")


	##2 - loading libraries and datasets
	library(dplyr)
	library(reshape2)
	NEI <- readRDS("summarySCC_PM25.rds")
	SCC <- readRDS("Source_Classification_Code.rds")


		##3 - merging the two datasets
		dataset <- merge(SCC, NEI, by = "SCC")

		
			##4 - creating a tidydataset
			
			##4.1 - subsetting data.category, scc.level.three, fips, emission and year
			pollutantsubset <- subset(dataset[c(2, 9)])
			restsubset <- subset(dataset[c(16, 18, 20)])
			
			##4.2 - merging pollutant and data category columns
			pollutantsubset <- paste(pollutantsubset$SCC.Level.Three, pollutantsubset$Data.Category, sep = ".")
			
			##4.3 - merging pollutantsubset and restsubset
			mergedsubset <- cbind(pollutantsubset, restsubset)

			##4.4 - renaming columns
			names(mergedsubset) <- gsub("pollutantsubset", "pollutant", names(mergedsubset))
			names(mergedsubset) <- gsub("fips", "area", names(mergedsubset))
			names(mergedsubset) <- gsub("Emissions", "emissions", names(mergedsubset))


				##5 - subsetting Baltimore City and sorting by year

				##5.1 - selecting Baltimore City subset "24510"
				baltimoresubset <- subset(mergedsubset, area == 24510)
				baltimoresubset <- subset(baltimoresubset[c(3,4)])

				##5.2 - sorting the data by year
				baltimoresubset <- arrange(baltimoresubset, (year))

					
					##6 - calculating total emissions for each year

					##6.1 - reshaping the dataset into individual years
					meltedsubset <- melt(baltimoresubset, id.vars = c("year"))

					##6.2 - calculating the mean values of all variables
					finalsubset <- dcast(meltedsubset, year ~ variable, mean)

						##7 - plotting the graph	
						plot(finalsubset$year, finalsubset$emissions, xlab="Year", ylab = "Emissions (tons)", main = "PM2.5 emissions \n in Baltimore City, Maryland, USA \n for 1999 to 2008", type = "o")

							##8 - closing graph save function
							dev.off()
