##ASSIGNMENT 3  - US Hospitals: quality of care
##  			- survey: US Department of Health and Human Services

##============================================================================
##PART 3 - HOSPITAL - particular RANK for a particular disease across all states
##=============================================================================

##If the number given by num is larger than the number of hospitals in that state, then the function should return NA.

##============================================================================

rankall <- function(outcome, num = "best") {
  
	##initalizing the input variables
	position <- outcome[2]
	outcome <- outcome[1]
	num <- num

		##read the dataset as a character vectors
		##renaming NA <- "Not Available"
		completedataset<- read.csv("outcome-of-care-measures.csv", colClasses = "character", na.strings = "Not Available")

			##reduce the number of columns to those relevant
			##hospital name (2), state (7), 30 day heart attack (11), 30 day heart failure (17), 30 day pneumonia (23)
			columndataset <- completedataset[c(2, 7, 11, 17, 23)]

				##rename column headings to outcome variables
				##heart attack, heart failure, pneumonia
				columnnames <- c("hospital", "state", "outcome", "outcome", "outcome")
				colnames(columndataset) <- sapply(columnnames, as.character)

					##converting state input to renumeric
					##for selection of correct outcome column in columndataset
					if (outcome == "heart attack") {
					convert = 3

						} else if (outcome == "heart failure") {
						convert = 4

							} else if (outcome == "pneumonia") {
							convert = 5

								} else {
								stop('invalid outcome')
					}

	##selection of relevant columns
	##hospital name (2), state (7), 30 day heart attack (11), 30 day heart failure (17), 30 day pneumonia (23)
	outcomedataset <- columndataset[c(1, 2, convert)]

		##remove rows containing NA == Not Available values
		nasubset <- na.omit(outcomedataset)

			##converting the columns from factor to 
			##alphabetic = as.character 
			##numbers = as.numeric
			##so a sort can be performed on the dataset
			nasubset[, c(1:2)] <- sapply(nasubset[, c(1:2)], as.character)
			nasubset[, c(3)] <- sapply(nasubset[, c(3)], as.numeric)	 

				##sorting the dataset by three variables -  
				##state, outcome and finally alphabetically hospital name
				sortedsubset <- nasubset[order(nasubset$state, nasubset$outcome, nasubset$hospital), ]

					##calculating the number of rows in each state
					##split dataset into states
					splitdataset <- split(sortedsubset, sortedsubset$state)


##WORKSPACE SAVED TO THIS POINT


	##creating a function to create the hospital list output
	# Order by Deaths and then HospitalName
	outputlist <- lapply(splitdataset, function(x, num) {
	x = x[order(x$outcome, x$hospital),]

		##generating the final output from the input value = num
		##calculating the particular rank for each of the 54 states
		if(num == "best") {
		return (x$hospital[1])
		} else if (num == "worst") {
		return (x$hospital[nrow(x)])
		} else {
		return (x$hospital[num])
		}
		}, num)

			##reforming the data for the particular rank
			##for each of the 54 states
			rankedhospital <- data.frame(hospital = unlist(outputlist), state=names(outputlist)) 			


	rankedhospital

	}


