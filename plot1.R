PLOT 1

Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 

Using the base plotting system, make a plot showing the total PM2.5 emissions from all sources for each of the years 1999, 2002, 2005, and 2008.

================================================================

R SCRIPT

##1 - opening file to save graph
png("plot1.png", width = 1024, height = 768)


	##2 - loading libraries and datasets
	library(dplyr)
	library(reshape2)
	NEI <- readRDS("summarySCC_PM25.rds")
	SCC <- readRDS("Source_Classification_Code.rds")


		##3 - merging the two datasets
		dataset <- merge(SCC, NEI, by = "SCC")

		
			##4 - creating a tidydataset
			
			##4.1 - subset with year, scc.level.three, emissions
			pm25subset <- subset(dataset[c(2, 9, 18, 20)])

			##4.2 - selecting years 1999, 2002, 2005, 2008
			pm25subset <- subset(pm25subset, year == "1999" | year == "2002" | year == "2005" | year == "2008")	
					
			##4.2 - renaming columns
			names(pm25subset) <- gsub("Data.Category", "datacategory", names(pm25subset))
			names(pm25subset) <- gsub("SCC.Level.Three", "pollutant", names(pm25subset))
			names(pm25subset) <- gsub("Emissions", "emissions", names(pm25subset))
		
			##4.3 - merging datacategory and pollutant into one column
			merged <- paste(pm25subset$pollutant, pm25subset$datacategory, sep = ".")
			
			##4.4 - recombining merged df with pm25subset - columns 3,4
			finalsubset <- cbind(merged, pm25subset[c(3,4)])
			
			##4.5 - renaming merged column
			names(finalsubset) <- gsub("merged", "pollutant", names(finalsubset))
			
			##4.6 - sorting the dataset for easy reading
			finalsubset <- arrange(finalsubset, (year), (pollutant), (emissions))	
			
			
				##5 - calculating mean of each emission for each year and each pollutant type
				meltedsubset <- melt(finalsubset, id.vars = c("year", "pollutant"))
				finalsubset <- dcast(meltedsubset, year + pollutant ~ variable, mean)

						
					##6 - plot 4 graph - one for each year. filling by rows
					par(mfrow = c(2,2), oma = c(5,4,4,2))

					with(finalsubset, {

						##6.1 - year 1999
						
						plot(finalsubset$pollutant, finalsubset$emissions, xlab="Pollutant", ylab = "Emissions (tons)", xaxt="n", main = "1999", type = "n")
						
						lines(finalsubset$emissions, finalsubset$year == 1999, type = "l", lty = 1, lwd = 1)
						
						##6.2 - year 2002
						plot(finalsubset$pollutant, finalsubset$emissions, xlab="Pollutant", ylab = "Emissions (tons)", xaxt="n", main = "2002", type = "n")
						
						lines(finalsubset$pollutant, finalsubset$year == 2002, type = "l", lty = 1, lwd = 1)

						##6.3 - year 2005
						plot(finalsubset$pollutant, finalsubset$emissions, xlab="Pollutant", ylab = "Emissions (tons)", xaxt="n", main = "2005", type = "n")

						lines(finalsubset$pollutant, finalsubset$year == 2005, type = "l", lty = 1, lwd = 1)

						##6.4 - year 2008
						
						plot(finalsubset$pollutant, finalsubset$emissions, xlab="Pollutant", ylab = "Emissions (tons)", xaxt="n", main = "2008", type = "n")

						lines(finalsubset$pollutant, finalsubset$year == 2008, type = "l", lty = 1, lwd = 1)					

						##6.5 - title for all graphs
						mtext("Mean PM2.5 emissions for 2421 pollutants \n in the USA \n for the years 1999, 2002, 2005 and 2008", outer = TRUE, cex = 1)

					##closing the graph
					})
					
						
##7 - closing graph save function
dev.off()

