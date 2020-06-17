library(tidyverse)
library(data.table)
library(dplyr)
##library(codebook)
##library(magrittr)

##set working directory
setwd("C:/Users/Shahil Sunder/Desktop/Reshay_Project/coursera/Getting_and_Cleaning_Data_Course_Project")

## download ZIP file into working set working directory.
## Zipped file downloaded as UICDataSet.zip and 
## unzipped as UCI HAR Dataset
fileURL = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('./UICDataset.zip')){
  download.file(fileURL,'./UICDataset.zip', mode = 'wb')
  unzip("UICDataset.zip", exdir = getwd())
}

## Read in required data
## Read in activity features data 
activityTbl <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activityID", "activity"))
featuresTbl <- read.table("UCI HAR Dataset/features.txt", col.names = c("featureID", "feature"))

##Read in and merge Test data
subjectTestTbl <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = c("subjectID"))
xTestTbl <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = featuresTbl$feature)
yTestTbl <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = c("activityID"))
testTbl <- cbind.data.frame(subjectTestTbl, yTestTbl, xTestTbl)

##Read in Train data
subjectTrainTbl <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = c("subjectID"))
xTrainTbl <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = featuresTbl$feature)
yTrainTbl <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = c("activityID"))
trainTbl <- cbind.data.frame(subjectTrainTbl, yTrainTbl, xTrainTbl)

##Merge Train and Test Datasets
mergeData <- rbind.data.frame(trainTbl, testTbl)

##Select from the merged data set the following columns: subjectID, activityID, columns that contain mean and STD
##Data is stored in table sumdata
sumData<- data.table(select(mergeData,contains(c("subjectID","activityID","mean","std"), ignore.case = TRUE)))

##Merge activity table and sumData table on activityID
sumData <- merge(activityTbl, sumData, by.x = "activityID", by.y = "activityID", all.x = TRUE, no.dups = FALSE)

##Reorder to ensure that subjectID is first followed by activity
sumData <- data.table(setcolorder(sumData,c(3,2,1)))

##Removed activityID column
sumData <- sumData[,c("activityID"):=NULL]

##Arrange by subjectID in ascending order
sumData <- arrange(sumData, subjectID)

##Appropriately labels the data set with descriptive variable names. Remove abbreviations and periods
names(sumData) <- gsub("^t", "time", names(sumData), ignore.case = TRUE)
names(sumData) <- gsub("^f", "frequencyDomain", names(sumData), ignore.case = TRUE)
names(sumData) <- gsub("Acc", "Accelerometer", names(sumData), ignore.case = TRUE)
names(sumData) <- gsub("Mag", "Magnitude", names(sumData), ignore.case = TRUE)
names(sumData) <- gsub("Gyro", "Gyroscope", names(sumData), ignore.case = TRUE)
names(sumData) <- gsub("BodyBody", "Body", names(sumData), ignore.case = TRUE)
names(sumData) <- gsub("\\.std","StandardDeviation", names(sumData), ignore.case = TRUE)
names(sumData) <- gsub(".tBody","TimeBody", names(sumData), ignore.case = TRUE)
names(sumData) <- gsub(".mean","Mean", names(sumData), ignore.case = TRUE)
names(sumData) <- gsub(".gravitMean","GravityMean", names(sumData), ignore.case = TRUE)
names(sumData) <- gsub("JerMean","JerkMean", names(sumData), ignore.case = TRUE)
names(sumData) <- gsub("\\Freq.","Frequency", names(sumData), ignore.case = TRUE)
names(sumData) <- gsub("\\.","", names(sumData), ignore.case = TRUE)

##Create tidyData table and calculate the means

tidyData <- sumData  %>% 
  group_by(subjectID, activity) %>%
  summarise_all(funs(mean))

##Write final data to tidyData.txt
write.table(tidyData, "tidyData.txt", row.name=FALSE)