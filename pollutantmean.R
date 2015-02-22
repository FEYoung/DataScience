##assignment number 1

## sulfate 1:10 calculation

pollutantmean <- function(directory, pollutant, id=1:10) {
  
##define the directory where all the files are held
  
directory <- list.files("specdata", full.names = TRUE)
  
##create an empty dataframe for merging our 332 data csv files
  
completedataset <- data.frame()
  
##fill our dataframe with the relevant ID values
  
for (i in 1:10) {
completedataset <- rbind(completedataset, read.csv(directory[i]))
}
  
##define which pollutant we are taking the mean value of
  
sulfate <- completedataset[c("sulfate")]
  
##convert data to numeric
pollutant <- data.frame(completedataset[c("sulfate")])
  
##calculate mean
colMeans(pollutant, na.rm = TRUE, dims = 1)
}