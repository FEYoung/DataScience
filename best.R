##ASSIGNMENT 3  - US Hospitals: quality of care
##  			- survey: US Department of Health and Human Services

##============================================================================

##PART 2 - finding the BEST hospital in the state

##============================================================================

##hospitals with ("Not Available") - exclude them before ranking hospitals

##sort (descending) the data - for particular ("outcome")

##calculate name of the hopital ("Hospital.Name") with the lowest value -
##heart attack
##heart failure
##pneumonia

##output ("Hospital.name") - first line of sort

##============================================================================


##Write a function called best
##to discover the US state with the best hospital for a particular disease
##heart attack, heart failure, or pneumonia
best <- function(state, outcome) {
  
	##initalizing the input variables
	state <- state
	outcome <- outcome

		##read the dataset as a character vectors
		##renaming NA <- "Not Available"
		completedataset<- read.csv("outcome-of-care-measures.csv", colClasses = "character", na.strings = "Not Available")

			##reduce the number of columns to those relevant
			##hospital name (2), state (7), 30 day heart attack (11), 30 day heart failure (17), 30 day pneumonia (23)
			columndataset <- completedataset[c(2, 7, 11, 17, 23)]

				##rename column headings to outcome variables
				##heart attack, heart failure, pneumonia
				columnnames <- c("Hospital.Name", "State", "outcome", "outcome", "outcome")
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

  
	##checking if state is valid
	if (state != state %in% nasubset$State) {
	  ##state does not exist output error message
	  stop('invalid state')
	  
  	} else {
  	  ##then sort dataset to find best hospital in that state
  	  statesubset <- nasubset[nasubset$State==state, ]
  	  hospital <- statesubset[order(statesubset[,3]), ]
	}

		##output - to read the Hospital.Name only after the sort
		hospital[1,1]
}

