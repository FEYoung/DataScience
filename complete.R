complete <- function(directory, id = 1:332) {
  
 ##setup directory where files are held
 dataset <- list.files(directory, full.names = TRUE)
  
  ##creating the id vector
  id <- id
  
  ##create the base data frames
  completedataset <- data.frame()
  nobssum <- data.frame()
  nobs <- data.frame()
  
  ##creating number of complete cases
  for (i in id) {
  completedataset <- read.csv(dataset[i])
      
  ##sum the number of complete cases
  nobssum <- sum(complete.cases(completedataset))
  }
    
    ##create the output
    nobs <- data.frame(id = id, nobssum = nobssum)
    nobs
    
  }
 
 
 
 
getNobs <- function(data) {
	good.obs <- complete.cases(data$sulfate, data$nitrate)
		sulfate.obs <- length(data$sulfate[good.obs])
			nitrate.obs <- length(data$nitrate[good.obs])
			
if (sulfate.obs < nitrate.obs) {
	nobs <- sulfate.obs
		} else {
			nobs <- nitrate.obs
		}
nobs
}

 nobs <- getNobs(data)
complete.data[n, ] <- c(i, nobs)
n <- n+1
}

