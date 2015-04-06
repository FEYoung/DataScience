##ASSIGNMENT 3  - US Hospitals: quality of care
##				- survey: US Department of Health and Human Services

##============================================================================
##PART 2 - HOSPITAL - particular RANK in a given state for a particular disease
##=============================================================================

##where multiple hospitals have the same rate for a given cause of death
#the tied cases should be broken by using the hospital name.

##============================================================================

rankhospital <- function(state, outcome, num = "best") {
  
	##initalizing the input variables
	state <- state
	outcome <- outcome
	num <- num

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

##WORKSPACE SAVED UP TO THIS POINT 
##rankhospital.RData

##selecting the state							
	##checking if state is valid
	if (state == state %in% nasubset$State) {
	  ##state does not exist output error message
	  stop('invalid state')
	  
		} else {
		  ##then sort dataset to find best hospital in that state
		  statesubset <- nasubset[nasubset$State==state, ]
	}

		##sorting the dataset by two variables -  
		##outcome and Hospital.Name
		finalsubset <- statesubset[order(statesubset$outcome,statesubset$Hospital.Name), ]

			##generating the final output from the input value = num
			if (num == "best") {
				hospital <- finalsubset[1, 1]
					} else if (num == "worst") {
						tailsubset <- tail(finalsubset, 1L)
						hospital <- tailsubset[1,1]
						} else {
							hospital <- finalsubset[num, 1]
			}

	hospital
				
}


