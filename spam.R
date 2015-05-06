##1 - loading libraries and dataset
library(kernlab)
data(spam)

	##2 - creating two random datasets from the initial
	##	  data from 4601 data points
	set.seed(3435)
	trainindicator = rbinom(4601, size = 1, prob = 0.5)
	table(trainindicator)

	trainindicator
	   0    1 
	2314 2287 

		##3 - creating two datasets - test and train
		trainspam = spam[trainindicator == 1,]
		testspam = spam[trainindicator == 0,]
		
		##renaming columns to lower case - both datasets
		names(trainspam) <- gsub("S", "s", names(trainspam))
		names(trainspam) <- gsub("R", "r", names(trainspam))
		names(trainspam) <- gsub("E", "e", names(trainspam))
		names(trainspam) <- gsub("D", "d", names(trainspam))
		names(trainspam) <- gsub("H", "h", names(trainspam))
		names(trainspam) <- gsub("A", "a", names(trainspam))
		names(trainspam) <- gsub("L", "l", names(trainspam))
		names(trainspam) <- gsub("T", "t", names(trainspam))

		names(testspam) <- gsub("S", "s", names(testspam))
		names(testspam) <- gsub("R", "r", names(testspam))
		names(testspam) <- gsub("E", "e", names(testspam))
		names(testspam) <- gsub("D", "d", names(testspam))
		names(testspam) <- gsub("H", "h", names(testspam))
		names(testspam) <- gsub("A", "a", names(testspam))
		names(testspam) <- gsub("L", "l", names(testspam))
		names(testspam) <- gsub("T", "t", names(testspam))


##exploring the datasets

##dimensions
		dim(trainspam)
		[1] 2287   58

		dim(testspam)
		[1] 2314   58

##column names?
names(trainspam)
 [1] "make"              "address"           "all"             
 [4] "num3d"             "our"               "over"            
 [7] "remove"            "internet"          "order"           
[10] "mail"              "receive"           "will"            
[13] "people"            "report"            "addresses"       
[16] "free"              "business"          "email"           
[19] "you"               "credit"            "your" 
[22] "font"              "num000"            "money"           
[25] "hp"                "hpl"               "george"          
[28] "num650"            "lab"               "labs"            
[31] "telnet"            "num857"            "data"            
[34] "num415"            "num85"             "technology"      
[37] "num1999"           "parts"             "pm"              
[40] "direct"            "cs"                "meeting"         
[43] "original"          "project"           "re"              
[46] "edu"               "table"             "conference"      
[49] "charsemicolon"     "charroundbracket"	"charsquarebracket"
[52] "charexclamation"   "chardollar"        "charhash"        
[55] "capitalave"        "capitallong"       "capitaltotal" 
[58] "type"

	##trainspam - how much is spam?
	##column - type = spam / nonspam
	table(trainspam$type)

	nonspam    spam 
	   1381     906 
   
		##GRAPH ONE - correlation between spam types and
		##number of capital letters in a row
		plot(trainspam$capitalave ~ trainspam$type)

		##GRAPH TWO - as above using y log axis
		plot(log10(trainspam$capitalave + 1) ~ trainspam$type)
		
		##GRAPH THREE - is there any correlation between the 
		##first four columns
		plot(log10(trainspam[,1:4] + 1))

		##GRAPH FOUR - clustering of data
		hcluster = hclust(dist(t(trainspam[,1:57])))
		plot(hcluster)
		
		##GRAPH FIVE - cluster of data with log
		hclusterlog = hclust(dist(t(log10(trainspam[,1:55] + 1))))
		plot(hclusterlog)
		
##Modelling - finding the variable with the least number of errors that will not generate incorrect results (TYPE ERRORS)

	##function to work through all 55 variables
	##numeric columns
	trainspam$numType = as.numeric(trainspam$type) - 1
	costFunction = function(x,y) sum(x != (y > 0.5))
	cvError = rep(NA, 55)

	library(boot)

	##checking all variables
	for (i in 1:55) {
		lmFormula = reformulate(names(trainspam)[i], response = "numType")
		glmFit = glm(lmFormula, family = "binomial", data = trainspam)
		cvError[i] = cv.glm(trainspam, glmFit, costFunction, 2)$delta[2]
	}

	##Which variable has the minimum amount of cross validated errors?
	names(trainspam)[which.min(cvError)]
	[1] "chardollar"

		##WHAT IS CROSS VALIDATION?
		##Cross-validation, sometimes called rotation estimation is a model validation technique for assessing how the results of a statistical analysis will generalize to an independent dataset. 
		
		##It is mainly used in settings where the goal is prediction, and one wants TO ESTIMATE HOW ACCURATELY A PREDICTIVE MODEL WILL PERFORM IN PRACTICE. In a prediction problem, a model is usually given a dataset of KNOWN DATA on which training is run (TRAINING DATASET), and a dataset of UNKNOWN DATA (or first seen data) against which the model is tested (TESTING DATASET).

		##Cross-validation is important in guarding against testing hypotheses suggested by the data (called "Type III errors"[5]), especially where further samples are hazardous, costly or impossible to collect.

		##TYPE III ERRORS occur when researchers provide the right answer to the wrong question.


##how much uncertainity is there in the chardollar variable?

##modelling - fitting a GLM  = generalized linear model
	##to the variable with least errors = chardollar
	predictionmodel = glm(numType ~ chardollar, family = "binomial", data = trainspam)

		##get a uncertainity prediction on the test dataset
		predictiontest = predict(predictionmodel, testspam)
		predictedspam = rep("nonspam", dim(testspam)[1])

			##classify those variables with a probability 
			##greater than 0.5 as spam
			predictedspam[predictionmodel$fitted > 0.5] = "spam"

				##creating a classification table
				table(predictedspam, testspam$type)
				
				predictedspam 	nonspam spam  TOTAL
					nonspam   	 1346  458	   1804
					spam      	   61  449	    510
								-----  ---	   ----
					TOTAL		 1407  907	   2314

						##what is the error rate in the above table?
						##those specified as spam but were not spam = 61
						##those specific as nonspam but were spam = 458
						errors / total number of emails
						error <- (61 + 458)/(1346 + 458 + 61 + 449)
						error

						[1] 0.2242869						

						##What our dataset initially stated?
						nonspam    spam 
						1381        906

##RESULTS - 

If the number of dollar signs in an email is greater than 6.6% of total words within the email then that email should be classified as spam.

We predicted the error rate in our calculations as 22.4%.  This means only 77.6% accuracy!  Is this enough? Normally we are looking for a minimum of 95% (P = 0.05).

Was the analytical model the correct one to use?




