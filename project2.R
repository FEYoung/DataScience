Data Science Specialism

Module 5 - Reproducible research (May 2015)

Project Two

Author/Data Analyst: Fiona Young

===============================================================

QUESTION 1 - Across the United States, which types of events (as indicated in the EVTYPE variable) are most harmful with respect to population health?

QUESTION 2 - Across the United States, which types of events have the greatest economic consequences?

===============================================================

R SCRIPT

##PREPROCESSING OF THE RAW DATA FOR LATER ANALYSIS

##1 - loading R libraries (these have been previously downloaded using R itself by typing install.packages("library name here"). Select your CRAN server to download package.
library(data.table)
library(dplyr)
library(reshape2)
library(ggplot2)
library(grid)
library(gridExtra)
library(knitr)
library(rmarkdown)

##NOTE - I AM USING RConsole for this analysis.  For knitr/rmarkdown to work in RCONSOLE you are required to download the PANDOC package available online at: http://pandoc.org/installing.html

	##1.2 - What hardware/software environment am I using for this analysis?  Good to know in case any differences occur during this analysis when you replicate the R code.  As packages become part of rBase in the future you may not require to load them initially.
	sessionInfo()

		##1.3 - get the data from the internet!
		download.file("http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2", "stormdata.csv.bz2")
			
				##1.4 - unzipping and loading the entire dataset into R to view dataset.
				dataset <- read.csv(bzfile("stormdata.csv.bz2"))
					
##2 - what does the dataset contain?

	##2.1 - the number of rows and columns?
	dim(dataset)

		##2.2 - the column headings and their data classes?
		str(dataset)

			##2.3 - the first 5 rows of data
			head(dataset, 5)
			
##3 - Using the information generated in 2 (above) I have extracted nine columns required for this entire analysis (column number in brackets) from the total 39 columns.  And they are:

	##BGN_DATE = recorded start event date (2);
	##STATE = which US state the event occurred (7);
	##EVTYPE = type of weather event (8);
	##FATALITIES = human fatalities (23);
	##INJURIES = human injuries (24);
	##PROPDMG = property damage US Dollars (25);
	##PROPDMGEXP = property damage dollar exponential i.e. thousands, millions (26);
	##CROPDMG (27) = crop damage US Dollars;
	##CROPDMGEXP (28) = crop damage dollar exponential, e.g. thousands, millions, billions.
	
	datasubset <- dataset[c(2, 7, 8, 23, 24, 25, 26, 27, 28)]
	
##4 - renaming the column names show to understand what data they represent.  Also change the weather event letters to lower case

	##4.1 - renaming the column headings
	names(datasubset) <- gsub("BGN_DATE", "date", names(datasubset))
	names(datasubset) <- gsub("STATE", "state", names(datasubset))
	names(datasubset) <- gsub("EVTYPE", "eventtype", names(datasubset))
	names(datasubset) <- gsub("FATALITIES", "fatalities", names(datasubset))
	names(datasubset) <- gsub("INJURIES", "injuries", names(datasubset))
	names(datasubset) <- gsub("PROPDMG", "propertydamage", names(datasubset))
	names(datasubset) <- gsub("CROPDMG", "cropdamage", names(datasubset))
			
		#4.2 - renaming the event type names to lower case letters
		datasubset$eventtype = tolower(datasubset$eventtype)
		
##5 - The reporting of event types has changed over this timeframe.  This information is available online at http://www.ncdc.noaa.gov/stormevents/details.jsp and is summarized below:

	##1950 - 1954 <- tornado
	##1955 - 1992 <- tornado, thunderstorm wind, hail events. Data taken from previously published material.
	##1993 - 1995 <- tornado, thunderstorm wind, hail events. Data taken from records.
	##1996 - 2011 <- all 48 events recorded. Definitions in NWS Directive 10-1605 available online at http://www.nws.noaa.gov/directives/sym/pd01016005curr.pdf

	##Therefore this analysis will only use the data from 1996 - 2011 as using the data from 1950 - 1995 is incomplete and will skew the results.

		##5.1 - converting the dates in the date readable format yyyy-mm-dd
		datasubset$date <- as.Date(datasubset$date, format = "%m/%d/%Y")

			##5.2 - stripping the date to show the year only
			datasubset$date <- as.numeric(format(datasubset$date, format = "%Y"))	 
		 		 
				##5.3 - removing the rows 1950 - 1995
				datasubset = datasubset[datasubset$date > 1995, ]
	
##6 - removing any rows with missing values (shown as NA)
datasubset <- na.omit(datasubset)
	
##7 - converting the property damage column to the correct dollar values.

	##7.1 - property damage column
	
		##7.1.1 - removing the [.] from the values
		datasubset$propertydamage <- gsub("1.", "1", datasubset$propertydamage)
		datasubset$propertydamage <- gsub("2.", "2", datasubset$propertydamage)	
		datasubset$propertydamage <- gsub("3.", "3", datasubset$propertydamage)
		datasubset$propertydamage <- gsub("4.", "4", datasubset$propertydamage)
		datasubset$propertydamage <- gsub("5.", "5", datasubset$propertydamage)
		datasubset$propertydamage <- gsub("6.", "6", datasubset$propertydamage)
		datasubset$propertydamage <- gsub("7.", "7", datasubset$propertydamage)
		datasubset$propertydamage <- gsub("8.", "8", datasubset$propertydamage)
		datasubset$propertydamage <- gsub("9.", "9", datasubset$propertydamage)

		##7.2 - property damage	EXP column
		
			##7.2.1 - converting H, K, M, B to hundreds, thousands, millions, and billions (in figures)
			datasubset$propertydamageEXP <- gsub("H", "00", datasubset$propertydamageEXP)
			datasubset$propertydamageEXP <- gsub("h", "00", datasubset$propertydamageEXP)
			datasubset$propertydamageEXP <- gsub("K", "000", datasubset$propertydamageEXP)
			datasubset$propertydamageEXP <- gsub("k", "000", datasubset$propertydamageEXP)
			datasubset$propertydamageEXP <- gsub("M", "000000", datasubset$propertydamageEXP)		
			datasubset$propertydamageEXP <- gsub("m", "000000", datasubset$propertydamageEXP)	
			datasubset$propertydamageEXP <- gsub("B", "000000000", datasubset$propertydamageEXP)
			datasubset$propertydamageEXP <- gsub("b", "000000000", datasubset$propertydamageEXP)
		
			##7.3 - merging the property damage and property damage exp columns into one value column
			datasubset$propertydamage <- as.character(datasubset$propertydamage)
			propertyvalue <- paste0(datasubset$propertydamage, datasubset$propertydamageEXP)
			propertyvalue <- as.numeric(propertyvalue)
	
##8 - converting the crop damage column to the correct dollar values.

	##8.1 - crop damage column
	datasubset$cropdamage <- gsub("1.", "1", datasubset$cropdamage)
	datasubset$cropdamage <- gsub("2.", "2", datasubset$cropdamage)
	datasubset$cropdamage <- gsub("3.", "3", datasubset$cropdamage)
	datasubset$cropdamage <- gsub("4.", "4", datasubset$cropdamage)
	datasubset$cropdamage <- gsub("5.", "5", datasubset$cropdamage)
	datasubset$cropdamage <- gsub("6.", "6", datasubset$cropdamage)
	datasubset$cropdamage <- gsub("7.", "7", datasubset$cropdamage)
	datasubset$cropdamage <- gsub("8.", "8", datasubset$cropdamage)
	datasubset$cropdamage <- gsub("9.", "9", datasubset$cropdamage)
		
		##8.2 - crop damage EXP
		datasubset$cropdamageEXP <- gsub("H", "00", datasubset$propertydamageEXP)
		datasubset$cropdamageEXP <- gsub("h", "00", datasubset$propertydamageEXP)
		datasubset$cropdamageEXP <- gsub("K", "000", datasubset$cropdamageEXP)
		datasubset$cropdamageEXP <- gsub("k", "000", datasubset$cropdamageEXP)
		datasubset$cropdamageEXP <- gsub("M", "000000", datasubset$cropdamageEXP)
		datasubset$cropdamageEXP <- gsub("m", "000000", datasubset$cropdamageEXP)		
		datasubset$cropdamageEXP <- gsub("B", "000000000", datasubset$cropdamageEXP)
		datasubset$cropdamageEXP <- gsub("b", "000000000", datasubset$cropdamageEXP)
	
			##8.3 - merging the crop damage and crop damage exp columns into one value column
			datasubset$cropdamage <- as.character(datasubset$cropdamage)
			cropvalue <- paste(datasubset$cropdamage, datasubset$cropdamageEXP)
			cropvalue <- gsub(" ", "", cropvalue)
			cropvalue <- as.numeric(cropvalue)

##9 - merging the 3 datasets back together and removing the unwanted columns

	##9.1 - the merge
	valuedataset <- cbind(datasubset, propertyvalue, cropvalue)

		##9.2 - removing the unwanted columns
		valuedataset <- valuedataset[c(1:5, 10:11)]

##10 - sorting the dataset by weather event type to see what labels we have:

valuedataset <- valuedataset[order(valuedataset$eventtype), ]
	
	##10.1  - let's look at the actual data. Don't forget to scroll through it!  I won't run this code here but it is here for your perusal should you wish -> fix(valuesubset)

	##Now we have a problem!
	
		##According to the NOAA report(pages 2-4) there are 48 types of weather events. Report available at http://www1.ncdc.noaa.gov/pub/orders/IPS/IPS-225AEBB9-0C5E-4CA1-B90C-6EB4C8DA915F.pdf. 
	
		##However the categories have been combined creating many more weather events.

	##Why do this? For the calculations later to have the correct results.  Even if weather events are current zero this is a good idea in order to use this analysis for updated NOAA Storm Data in the future.
	
		##10.2 - the alterations 
		
		##10.2.1 - numerics removal
		valuedataset$eventtype <- gsub("\\(g45)", "", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("\\(g40)", "", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("\\(0.75)", "", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("\\(41)", "", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("\\(g35)", "", valuedataset$eventtype)

		valuedataset$eventtype <- gsub("\\g45", "", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("\\ 40", "", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("\\ 45", "", valuedataset$eventtype)
	
			##10.2.2 - extra spaces removal
			valuedataset$eventtype <- gsub("^   ", "", valuedataset$eventtype)
			valuedataset$eventtype <- gsub("^  ", "", valuedataset$eventtype)
			valuedataset$eventtype <- gsub("^ ", "", valuedataset$eventtype)
			valuedataset$eventtype <- gsub("\\  ", " ", valuedataset$eventtype)
			valuedataset$eventtype <- gsub("  $", "", valuedataset$eventtype)
			valuedataset$eventtype <- gsub(" $", "", valuedataset$eventtype)
			valuedataset$eventtype <- gsub("\\  ", " ", valuedataset$eventtype)

		##removing rows 3339, 387129 to 387103 as they contain summary information
		valuedataset = valuedataset[-c(387129:387203), ]
		valuedataset = valuedataset[-c(3339), ]
	
		##10.2.3 - event types 
			##same event type with different spellings or additional spaces or use the oblique (/) symbol where at other times it is not used.  Finally there are incorrect spellings.  All these problems require alteration.

		##changing flooding to flood
		valuedataset$eventtype <- gsub("flooding", "flood", valuedataset$eventtype)
			
		##AVALANCHE
		valuedataset$eventtype <- gsub("avalance", "avalanche", valuedataset$eventtype)
		
		##BLIZZARD
		valuedataset$eventtype <- gsub("blowing snowfall", "blizzard", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("blowing snow", "blizzard", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("extremewind chill/blowing sno", "blizzard", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("snow/blowing snow", "blizzard", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("snow/blizzard", "blizzard", valuedataset$eventtype)
		
		##COASTAL FLOOD
		valuedataset$eventtype <- gsub("cstl", "coastal", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("coastalflood", "coastal flood", valuedataset$eventtype)

		##DEBRIS FLOW
		valuedataset$eventtype <- gsub("beach erosin", "debris flow", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("beach erosion", "debris flow", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("coastal erosion", "debris flow", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("landslide", "debris flow", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("landslump", "debris flow", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("mud slide", "debris flow", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("mudslide", "debris flow", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("rockslide", "debris flow", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("saharan dust", "debris flow", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("tornado debris", "debris flow", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("debris flows", "debris flow", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("debris flow/debris flow", "debris flow", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("rock slide", "debris flow", valuedataset$eventtype)

		##DENSE FOG
		valuedataset$eventtype <- gsub("^fog", "dense fog", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("patchy dense fog", "dense fog", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("vog", "dense fog", valuedataset$eventtype)
				
		##DENSE SMOKE
		valuedataset$eventtype <- gsub("^smoke", "dense smoke", valuedataset$eventtype)
		
		##DROUGHT
		valuedataset$eventtype <- gsub("abnormally dry", "drought", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("excessively dry", "drought", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("record dryness", "drought", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("unseasonably dry", "drought", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("very dry", "drought", valuedataset$eventtype)

		##DUST DEVIL
		valuedataset$eventtype <- gsub("blowing dust", "dust devil", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("dust devel", "dust devil", valuedataset$eventtype)
		
		##DUST STORM
			##no adjustments
		
		##EXCESSIVE HEAT
		valuedataset$eventtype <- gsub("hyperthermia/exposure", "excessive heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("record temperature", "excessive heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("temperature record", "excessive heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("excessive heats", "excessive heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("excessive heat/drought", "excessive heat", valuedataset$eventtype)

		##FLASH FLOOD
		valuedataset$eventtype <- gsub("flash flood/flood", "flash flood", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("flood/flash flood", "flash flood", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("flood/flash/flood", "flash flood", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("dam break", "flash flood", valuedataset$eventtype)
		
		##FLOOD
		valuedataset$eventtype <- gsub("minor flood", "flood", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("river flood", "flood", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("sml stream fld", "flood", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("snowmelt flood", "flood", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("street flood", "flood", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("tidal flood", "flood", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("urban flood", "flood", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("urban/small strm fldg", "flood", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("urban/sml stream fld", "flood", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("urban/flood", "flood", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("floodg", "flood", valuedataset$eventtype)

		##FREEZING FOG
		valuedataset$eventtype <- gsub("ice fog", "freezing fog", valuedataset$eventtype)
		
		##FROST/FREEZE		
		valuedataset$eventtype <- gsub("agricultural freeze", "frost/freeze", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("black ice", "frost/freeze", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("cold and frost", "frost/freeze", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("damaging freeze", "frost/freeze", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("early frost", "frost/freeze", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("first frost", "frost/freeze", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("glaze", "frost/freeze", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("hard freeze", "frost/freeze", valuedataset$eventtype)

		valuedataset$eventtype <- gsub("ice jam", "frost/freeze", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("ice on road", "frost/freeze", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("ice pellets", "frost/freeze", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("ice road", "frost/freeze", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("icy roads", "frost/freeze", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("late freeze", "frost/freeze", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("patchy ice", "frost/freeze", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("frost/freezes", "frost/freeze", valuedataset$eventtype)

		valuedataset$eventtype <- gsub("[(]", "", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("frost/freeze flood minor", "frost/freeze/flood", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("^ice$", "frost/freeze", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("^frost$", "frost/freeze", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("^freeze$", "frost/freeze", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("falling snow/ice", "frost/freeze", valuedataset$eventtype)

		##FUNNEL CLOUD
		valuedataset$eventtype <- gsub("funnel clouds", "tornado", valuedataset$eventtype)
	
		##HAIL
		valuedataset$eventtype <- gsub("late season hail", "hail", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("non severe hail", "hail", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("small hail", "hail", valuedataset$eventtype)

		##HEAT
		valuedataset$eventtype <- gsub("abnormal warmth", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("heat wave", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("hot spell", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("hot weather", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("prolong warmth", "heat", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("record heat", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("record warm temps.", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("record warmth", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("record warm", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("unseasonably hot", "heat", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("unseasonably warm", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("unseasonably hot", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("unseasonably warm year", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("unusual warmth", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("unusual/record warmth", "heat", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("unusually warm", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("very warm", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("warm weather", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("heat year", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("unusual/heat", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("heat & wet", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("heat/wet", "heat", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("heat and dry", "heat", valuedataset$eventtype)
	
		##HEAVY RAIN
		valuedataset$eventtype <- gsub("abnormally wet", "heavy rain", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("excessive rainfall", "heavy rain", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("excessive rain", "heavy rain", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("extremely wet", "heavy rain", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("heavy rainfall", "heavy rain", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("locally heavy rain", "heavy rain", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("prolong rain", "heavy rain", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("torrential rainfall", "heavy rain", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("heavy rain effects", "heavy rain", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("[)]", "", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("rain heavy", "heavy rain", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("record rainfall", "heavy rain", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("unseasonably wet", "heavy rain", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("heavy rain and wind", "heavy rain/wind", valuedataset$eventtype)

		valuedataset$eventtype <- gsub("prolonged rain", "heavy rain", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("record rainfall", "heavy rain", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("record precipitation", "heavy rain", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("wet year", "heavy rain", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("thunderstorm heavy rain", "heavy rain", valuedataset$eventtype)
			
		##HEAVY SNOW
		valuedataset$eventtype <- gsub("accumulated snowfall", "heavy snow", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("excessive snow", "heavy snow", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("heavy snow shower", "heavy snow", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("heavy snow squalls", "heavy snow", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("record snowfall", "heavy snow", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("record snow", "heavy snow", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("record winter snow", "heavy snow", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("snow accumulation", "heavy snow", valuedataset$eventtype)

		##HIGH SURF
		valuedataset$eventtype <- gsub("high surf advisory", "high surf", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("high surf advisories", "high surf", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("hazardous surf", "high surf", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("heavy surf/high surf", "high surf", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("high swells", "high surf", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("heavy surf", "high surf", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("high surf and wind", "high surf/wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("rough surf", "high surf/wind", valuedataset$eventtype)
			
		##HIGH WIND
		valuedataset$eventtype <- gsub("dry microburst", "high wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("gusty lake wind", "high wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("gusty winds", "high wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("gusty wind", "high wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("high winds", "high wind", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("high wind", "high wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("microburst", "high wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("wind advisory", "high wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("wind damage", "high wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("wind gusts", "high wind", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("winds", "high wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("wnd", "high wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("^wind$", "high wind", valuedataset$eventtype)

		##HURRICANE/TYPHOON
		valuedataset$eventtype <- gsub("hurricane edouard", "hurricane/typhoon", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("typhoon", "hurricane/typhoon", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("^hurricane$", "hurricane/typhoon", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("hurricane/hurricane/typhoon", "hurricane/typhoon", valuedataset$eventtype)

		##ICE STORM
			##no adjustments

		##LAKESHORE FLOOD
			##no adjustments

		##LAKE-EFFECT SNOW
		valuedataset$eventtype <- gsub("lake effect snow", "lake-effect snow", valuedataset$eventtype)

		##LIGHTNING
		valuedataset$eventtype <- gsub("severe thunderstorms", "lightning", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("severe thunderstorm", "lightning", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("^thunderstorm$", "lightning", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("^tstm$", "lightning", valuedataset$eventtype)

		##MARINE HAIL
			##no adjustment
	
		##MARINE HIGH WIND
		valuedataset$eventtype <- gsub("^blow-out tides", "marine high wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("^blow-out tide", "marine high wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("^coastal storm", "marine high wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("^coastalstorm", "marine high wind", valuedataset$eventtype)

		##MARINE STRONG WIND
		valuedataset$eventtype <- gsub("rough seas", "marine strong wind", valuedataset$eventtype)

		##MARINE THUNDERSTORM WIND
		valuedataset$eventtype <- gsub("marine tstm wind", "marine thunderstorm wind", valuedataset$eventtype)
		
		##RIP CURRENT
		valuedataset$eventtype <- gsub("rip currents", "rip current", valuedataset$eventtype)

		##SEICHE
			##no adjustments

		##SLEET
		valuedataset$eventtype <- gsub("sleet/freezing rain", "sleet", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("sleet storm", "sleet", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("freezing drizzle", "sleet", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("freezing rain/sleet", "sleet", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("freezing rain", "sleet", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("rain/snow", "sleet", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("snow/freezing rain", "sleet", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("snow/sleet", "sleet", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("snow and sleet", "sleet", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("light sleet", "sleet", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("heavy precipitation", "sleet", valuedataset$eventtype)
		
		##STORM TIDE
		valuedataset$eventtype <- gsub("storm surge", "storm tide", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("storm surge/tide", "storm tide", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("storm tide/tide", "storm tide", valuedataset$eventtype)

		##STRONG WIND
		valuedataset$eventtype <- gsub("strong wind gust", "strong wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("strong winds", "strong wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("strong high wind", "strong wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("high wind", "strong wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("non-severe strong wind", "strong wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("wet strong wind", "strong wind", valuedataset$eventtype)

		##THUNDERSTORM WIND includes downbursts, gustnados
		valuedataset$eventtype <- gsub("downburst", "thunderstorm wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("wet micoburst", "thunderstorm wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("wet microburst", "thunderstorm wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("gusty thunderstorm winds", "thunderstorm wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("gusty thunderstorm wind", "thunderstorm wind", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("tstm winds", "thunderstorm wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("tstm wind and lightning", "thunderstorm wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("tstm wind", "thunderstorm wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("wall cloud", "thunderstorm wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("tstm strong wind", "thunderstorm wind", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("heat burst", "thunderstorm wind", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("heatburst", "thunderstorm wind", valuedataset$eventtype)
		
		##TORNADO
		valuedataset$eventtype <- gsub("landspout", "tornado", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("whirlwind", "tornado", valuedataset$eventtype)

		##TROPICAL DEPRESSION
			##no adjustments

		##TROPICAL STORM
		valuedataset$eventtype <- gsub("remnants of floyd", "tropical storm", valuedataset$eventtype)
	
		##TSUNAMI
			##no adjustments

		##VOLCANIC ASH
		valuedataset$eventtype <- gsub("volcanic ashfall", "volcanic ash", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("volcanic ash plume", "volcanic ash", valuedataset$eventtype)	

		##WATERSPOUT
		valuedataset$eventtype <- gsub("waterspouts", "waterspout", valuedataset$eventtype)

		##WILDFIRE
		valuedataset$eventtype <- gsub("brush fire", "wildfire", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("wild/forest fire", "wildfire", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("red flag criteria", "wildfire", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("red flag fire wx", "wildfire", valuedataset$eventtype)

		##WINTER STORM
		valuedataset$eventtype <- gsub("icestorm/blizzard", "winter storm", valuedataset$eventtype)

		##WINTER WEATHER
		valuedataset$eventtype <- gsub("drifting snow", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("first snow", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("ice/snow", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("late season snowfall", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("late season snow", "winter weather", valuedataset$eventtype)

		valuedataset$eventtype <- gsub("late snow", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("light snowfall", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("light snow", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("light snow/flurries", "winter weather", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("light snow/freezing precipitation", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("moderate snowfall", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("moderate snow", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("seasonal snowfall", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("^snow$", "winter weather", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("snow advisory", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("snow and ice", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("snow drought", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("snow showers", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("snow squalls", "winter weather", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("snow squall", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("snow/ice", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("thundersnow shower", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("winter mix", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("winter weather mix", "winter weather", valuedataset$eventtype)

		valuedataset$eventtype <- gsub("wintery mix", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("wintry mix", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("winter weather/flurries", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("winter weather/freezing precip", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("winter weather/mix", "winter weather", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("winter storm", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("cold and snow", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("early snowfall", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("late-season snowfall", "winter weather", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("record may snow", "winter weather", valuedataset$eventtype)

		valuedataset$eventtype <- gsub("unusually winter weather", "winter weather", valuedataset$eventtype)
		
		##OTHER
		##"metro storm, may 26". Event investigated online believed hail, thunderstorm wind. see references for link
		valuedataset$eventtype <- gsub("metro storm, may 26", "thunderstorm wind/hail", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("astronomical high tide", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("astronomical low tide", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("coastal flood/erosion", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("driest month", "other", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("drowning", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("^dry$", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("dry conditions", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("dry spell", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("dry weather", "other", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("dryness", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("early rain", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("early rain", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("erosion/coastal flood", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("flood/strong wind", "other", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("freezing spray", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("frost/freeze/flood", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("gradient wind", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("gusty thunderstorm strong wind", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("hail/wind", "other", valuedataset$eventtype)

		valuedataset$eventtype <- gsub("heavy rain/high surf", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("heavy rain/wind", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("heavy seas", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("high water", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("hot and dry", "other", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("marine accident", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("mild and dry pattern", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("mixed precipitation", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("mixed precip", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("monthly precipitation", "other", valuedataset$eventtype)

		valuedataset$eventtype <- gsub("monthly rainfall", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("monthly snowfall", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("monthly temperature", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("mountain snows", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("no severe weather", "other", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("non-thunderstorm wind", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("non thunderstorm wind", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("none", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("northern lights", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("^rain$", "other", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("rain/snow", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("rain damage", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("record dry month", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("record high", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("record low rainfall", "other", valuedataset$eventtype)
	
		valuedataset$eventtype <- gsub("rogue wave", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("high surf/wind", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("high seas", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("wind and wave", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("volcanic eruption", "other", valuedataset$eventtype)
	
		valuedataset$eventtype <- gsub("wake low wind", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("wet month", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("unseasonal rain", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("unseasonably cool & wet", "other", valuedataset$eventtype)

		valuedataset$eventtype <- gsub("strong wind/hail", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("strong wind/hvy rain", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("strong wind/rain", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("thunderstorm wind/hail", "other", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("thunderstorms", "other", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("tstm heavy rain", "other", valuedataset$eventtype)
		
		##COLD/WIND CHILL
		valuedataset$eventtype <- gsub("cold wind chill temperatures", "cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("cold temperatures", "cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("cold temperature", "cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("cold weather", "cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("^cold$", "cold/wind chill", valuedataset$eventtype)

		valuedataset$eventtype <- gsub("^wind chill$", "cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("cool spell", "cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("extended cold", "cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("prolong cold", "cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("record cool", "cold/wind chill", valuedataset$eventtype)
	
		valuedataset$eventtype <- gsub("unseasonable cold", "cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("unseasonably cold", "cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("unseasonably cool", "cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("unseasonal low temperature", "cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("unusually cold", "cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("unseasonal low temp", "cold/wind chill", valuedataset$eventtype)

		##EXTREME COLD/WIND CHILL
		valuedataset$eventtype <- gsub("hypothermia/exposure", "extreme cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("bitter wind chill temperatures", "extreme cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("bitter wind chill", "extreme cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("excessive cold", "extreme cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("record cold", "extreme cold/wind chill", valuedataset$eventtype)
		
		valuedataset$eventtype <- gsub("extreme windchill temperatures", "extreme cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("extreme windchill", "extreme cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("extreme wind chill", "extreme cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("extreme cold/wind chill", "extreme cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("extreme cold", "extreme cold/wind chill", valuedataset$eventtype)
		valuedataset$eventtype <- gsub("extreme cold/wind chill/wind chill", "extreme cold/wind chill", valuedataset$eventtype)

##11 - generating the final and tidy dataset
finaldataset <- valuedataset[order(valuedataset$eventtype), ]

##===============================================================

##QUESTION 1 - Across the United States, which types of events (as indicated in the EVTYPE variable) are MOST HARMFUL with respect to population health?

	##1.1 - PART 1 (Q1) - fatalities/injuries - total records
						##plot figure/graph in RESULTS section
	
		##1.1.1 - fatalities
		healthtotalfatal <- finaldataset[c(3:4)]
		meltedsubset1 <- melt(healthtotalfatal, id.vars = c("eventtype"))
		healthtotalfatal <- dcast(meltedsubset1, eventtype ~ variable, sum)

			##1.1.2 - injuries
			healthtotalinjury <- finaldataset[c(3, 5)]
			meltedsubset2 <- melt(healthtotalinjury, id.vars = c("eventtype"))
			healthtotalinjury <- dcast(meltedsubset2, eventtype ~ variable, sum)
			
	##1.2 - PART 2 (Q1) - fatalities/injuries - by year
	
		##1.2.1 - fatalities
		healthyearfatal <- finaldataset[c(1, 3, 4)]
		meltedsubset3 <- melt(healthyearfatal, id.vars = c("date", "eventtype"))
		healthyearfatal <- dcast(meltedsubset3, date + eventtype ~ variable, sum)
		healthyearfatal <- healthyearfatal[order(-healthyearfatal$fatalities), ]		
	
			##top ten number of fatalities by year
			humanyear1 <- head(healthyearfatal, 20)
		
		##1.2.2 - injuries
		healthyearinjury <- finaldataset[c(1, 3, 5)]
		meltedsubset4 <- melt(healthyearinjury, id.vars = c("date", "eventtype"))
		healthyearinjury <- dcast(meltedsubset4, date + eventtype ~ variable, sum)
		healthyearinjury <- healthyearinjury[order(-healthyearinjury$injuries), ]		
	
			##top ten number of injuries by year
			humanyear2 <- head(healthyearinjury, 20)		
	
			##TABLE 1
			humanyeartotal <- cbind(humanyear1, humanyear2)
			row.names(humancostfinal) <- NULL
			humanyeartotal
			
	##1.3 - PART 3 (Q1) - fatalities/injuries - by state

		##1.3.1 - fatalities
		healthstatefatal <- finaldataset[c(2, 3, 4)]
		meltedsubset5 <- melt(healthstatefatal, id.vars = c("state", "eventtype"))
		healthyearfatal <- dcast(meltedsubset5, state + eventtype ~ variable, sum)
		healthstatefatal <- healthstatefatal[order(-healthstatefatal$fatalities), ]

			##top ten number of fatalities by US state
			humancost1 <- head(healthstatefatal, 20)

		##1.3.2 - injuries
		healthstateinjury <- finaldataset[c(2, 3, 5)]
		meltedsubset6 <- melt(healthstateinjury, id.vars = c("state", "eventtype"))
		healthstateinjury <- dcast(meltedsubset6, state + eventtype ~ variable, sum)
		healthstateinjury <- healthstateinjury[order(-healthstateinjury$injuries), ]		
	
			##top ten number of injuries by state
			humancost2 <- head(healthstateinjury, 20)

			##TABLE 2
			humancostfinal <- cbind(humancost1, humancost2)
			row.names(humancostfinal) <- NULL
			humancostfinal
			
	##GRAPH 1 - REQUIRES R GRAPH, FIG.HEIGHT = 
	fatalities <- ggplot(data = healthtotalfatal, aes(x = eventtype, y = fatalities, label = fatalities)) + geom_bar(stat = "identity", fill = "red") + xlab("") + ylab("Fatalites \n") + ggtitle("Which weather events cause the greatest number of human fatalities... \n") + theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8)) + geom_text(size = 2.75, vjust = -0.75)

	injuries <- ggplot(data = healthtotalinjury, aes(x = eventtype, y = injuries, label = injuries)) + geom_bar(stat = "identity", fill = "red") + xlab("Type of weather \n") + ylab("Injuries \n") + ggtitle("and the greatest number of human injuries? \n") + theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8)) + geom_text(size = 2.75, vjust = -0.75)

	plot <- grid.arrange(fatalities, injuries)

##===============================================================

##QUESTION 2 - Across the United States, which types of events have the greatest economic consequences? (e.g. property and crops)

##1.1 - PART 1 (Q2) - property/crops - total records
					##plots a graph in RESULTS section
	
		##1.1.1 - property
		propertytotal <- finaldataset[c(3, 6)]
		meltedsubset7 <- melt(propertytotal, id.vars = c("eventtype"))
		propertytotal <- dcast(meltedsubset7, eventtype ~ variable, sum)

			##1.1.2 - crops
			cropstotal <- finaldataset[c(3, 7)]
			meltedsubset8 <- melt(cropstotal, id.vars = c("eventtype"))
			cropstotal <- dcast(meltedsubset8, eventtype ~ variable, sum)

##1.2 - PART 2 (Q2) - property/crops - by year
	
		##1.2.1 - property
		propertyyear <- finaldataset[c(1, 3, 6)]
		meltedsubset9 <- melt(propertyyear, id.vars = c("eventtype", "date"))
		propertyear <- dcast(meltedsubset9, eventtype + date ~ variable, sum)
		propertyyear <- propertyyear[order(-propertyyear$propertyvalue), ]		
	
			##top ten cost of property damage by year - FIGURE 2
			propertycost1 <- head(propertyyear, 20)
		
		##1.2.2 - crops
		cropyear <- finaldataset[c(1, 3, 7)]
		meltedsubset10 <- melt(cropyear, id.vars = c("date", "eventtype"))
		cropyear <- dcast(meltedsubset10, date + eventtype ~ variable, sum)
		cropyear <- cropyear[order(-cropyear$cropvalue), ]		
	
			##top ten number of injuries by state - FIGURE 2
			propertycost2 <- head(cropyear, 20)

			##TABLE 3
			propertycostfinal <- cbind(propertycost1, propertycost2)
			row.names(propertycostfinal) <- NULL
			propertycostfinal

##1.3 - PART 3 (Q2) - property/crops - by state

		##1.3.1 - property
		propertystate <- finaldataset[c(2, 3, 6)]
		meltedsubset11 <- melt(propertystate, id.vars = c("state", "eventtype"))
		propertystate <- dcast(meltedsubset11, state + eventtype~ variable, sum)
		propertystate <- propertystate[order(-propertystate$propertyvalue), ]

			##top ten number of fatalities by US state - FIGURE 3
			propertystate1 <- head(propertystate, 20)

		##1.3.2 - crops
		cropstate <- finaldataset[c(2, 3, 7)]
		meltedsubset12 <- melt(cropstate, id.vars = c("state", "eventtype"))
		cropstate <- dcast(meltedsubset12, state + eventtype ~ variable, sum)
		cropstate <- cropstate[order(-cropstate$cropvalue), ]

			##top ten number of fatalities by US state - FIGURE 3
			propertystate2 <- head(cropstate, 20)

			##TABLE 4
			propertystatefinal <- cbind(propertystate1, propertystate2)
			row.names(propertystatefinal) <- NULL
			propertystatefinal
			
			##GRAPH 2 - REQUIRES R GRAPH, FIG.HEIGHT = 
			property <- ggplot(data = propertytotal, aes(x = eventtype, y = propertyvalue)) + geom_bar(stat = "identity", fill = "red") + xlab("") + ylab("Cost  in US Dollars \n") + ggtitle("Which weather events cause the greatest property damage... \n") + theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8))
	
			crops <- ggplot(data = cropstotal, aes(x = eventtype, y = cropvalue)) + geom_bar(stat = "identity", fill = "red") + xlab("Type of weather \n") + ylab("Cost  in US Dollars \n") + ggtitle("and the greatest damage to crops? \n") + theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8))

			plot <- grid.arrange(property, crops)
