##assignment 1 parts 1-4 - calculating mean values of 
##sulfate 1:10, ##nitrate 70:72 and nitrate 23

pollutantmean <- function(directory, pollutant, id = 1:332) {

  ##setup directory where files are held
  dataset <- list.files(directory, full.names = TRUE)

    ##creating the pollutant vector
    pollutant <- pollutant

      ##create the base data frames
      completedataset <- data.frame()

        ##fill our dataframe with the relevant ID values
        for (i in id) {
        completedataset <- rbind(completedataset, read.csv(dataset[i]))
        }
          
          ##calculating mean value of pollutant
          mean(completedataset[, pollutant], na.rm = TRUE)

}
