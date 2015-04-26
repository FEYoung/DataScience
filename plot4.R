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

PLOT 4

Across the United States, how have emissions from 

coal combustion-related sources changed from 

1999 – 2008?

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
       
        ##3.1 - subsetting SCC.Level.Three, emission and year
        mergedsubset <- subset(dataset[c(9, 18, 20)])
       
        ##3.2 - renaming columns
        names(mergedsubset) <- gsub("SCC.Level.Three", "pollutant", names(mergedsubset))
        names(mergedsubset) <- gsub("Emissions", "emissions", names(mergedsubset))

        ##3.3 - selecting all the rows (50390 of them!) containing coal in the pollutant column
        coal <- grep('Coal', mergedsubset$pollutant)
        coalsubset = mergedsubset[coal,]
       
        ##3.4 - sorting the data by year
        coalsubset <- arrange(coalsubset, (year), (pollutant))

       
        ##4 - calculating total emissions for each year

        ##4.1 - reshaping the dataset into individual years
        meltedsubset <- melt(coalsubset, id.vars = c("year", "pollutant"))
       
        ##4.2 - calculating the mean values of all variables
        finalsubset <- dcast(meltedsubset, year + pollutant ~ variable, mean)           

           
            ##5 - plotting the graph using ggplot2 package
            graph <- qplot(year, emissions, data = finalsubset, xlab ="Year", ylab = "Emissions (tons)")
           
            graph + ggtitle("PM2.5 emissions in the U.S.A. for coal sources - 1999 to 2008 \n") + facet_grid(pollutant~., scales = "free_y") + theme(strip.text.y = element_text(size = 10, angle = 0)) + stat_smooth(method = "lm")

           
                ##6 - saving the graph to a png file
                dev.copy(png, "plot4.png", width = 960, height = 600, units = "px")
                dev.off()