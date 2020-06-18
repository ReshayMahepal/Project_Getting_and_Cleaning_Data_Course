---
title: "CodeBook"
author: "Reshay Mahepal"
date: "17/06/2020"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# 1. Project Brief

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# 2. Data Description
## 2.1. Data Sets

The following datasets were downloaded from the 
- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

## 2.2 Variables and Measures

The 'features.txt'information outlines signals were used to estimate variables of the feature vector for each pattern:  
'XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window
* angle(): Angle between to vectors

Other variables include:


* subjectID 
* activityID
* activity, which includes: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.    

# 3. Creating the run_analysis.R R Script

## 3.1. Merginging Data

### 3.1.1. Load Required Packages

The libraries used included the following:

```{r}
library(tidyverse)
library(data.table)
library(dplyr)
```

### 3.1.2. Set working directory

The working directory was set as per below:

```{r}
setwd("C:/Users/Shahil Sunder/Desktop/Reshay_Project/coursera/ProgrammingAssignment2/Project_Getting_and_Cleaning_Data_Course")

```

### 3.1.3. Read in data

The data was downloaded from the URL as per the project brief, into the specified working directory, and  then unzipped.

* Zipped file downloaded as UICDataSet.zip and   
* unzipped as UCI HAR Dataset  

```{r}
fileURL = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('./UICDataset.zip')){
  download.file(fileURL,'./UICDataset.zip', mode = 'wb')
  unzip("UICDataset.zip", exdir = getwd())
}
```

### 3.1.4. Load Data Tables

The data sets were loaded were loaded into data tables using the code as follows. Variables (column names) of each table were assigned.

The activityTbl included the activity_labels.txt data and the featuresTbl, the features.txt data. 
```{r}
activityTbl <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activityID", "activity"))
  featuresTbl <- read.table("UCI HAR Dataset/features.txt", col.names = c("featureID", "feature"))
```  

Data related to the test subjects where loaded into the follwing tables: subjectTestTbl, xTestTbl, yTestTbl and then merged into the testTbl. A similar method was applied to the train subject data.
```{r}
subjectTestTbl <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = c("subjectID"))
  xTestTbl <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = featuresTbl$feature)
    yTestTbl <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = c("activityID"))
      testTbl <- cbind.data.frame(subjectTestTbl, yTestTbl, xTestTbl)
```

```{r}
subjectTrainTbl <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = c("subjectID"))
  xTrainTbl <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = featuresTbl$feature)
    yTrainTbl <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = c("activityID"))
      trainTbl <- cbind.data.frame(subjectTrainTbl, yTrainTbl, xTrainTbl)
```

### 3.1.5. Merge Train and Test Datasets into one data set

The Test data and Train data was then merged into a single data table named mergeData, consisting of *10299 observations* and *563 variables*.
```{r}
mergeData <- rbind.data.frame(trainTbl, testTbl)
```
## 3.2. Extracting Required Data

From mergeData, the following columns: subjectID, activityID, columns that contain mean and Std, where selected and  stored in a data table, sumData (summary data), consisting of *10299 observarions* and *88 variables*.
```{r}
sumData<- data.table(select(mergeData,contains(c("subjectID","activityID","mean","std"), ignore.case = TRUE)))
```
## 3.3. Ensuring Descriptive Activity Names

The activityTbl and sumData table were merged on activityID.
```{r}
sumData <- merge(activityTbl, sumData, by.x = "activityID", by.y = "activityID", all.x = TRUE, no.dups = FALSE)
```
The columns of the sumData table were then reorder to ensure that subjectID is first followed by activity, and then the activity ID
```{r}
sumData <- data.table(setcolorder(sumData,c(3,2,1)))
```
The activityID column was then removed, as the column was deemed redundant.
```{r}
sumData <- sumData[,c("activityID"):=NULL]
```
The sumData table was then arranged by subjectID in ascending order
```{r}
sumData <- arrange(sumData, subjectID)
```
## 3.4. Appropriate labels for Variables/ Column Names

The variables (column names) of the sumData tables was then amended with more descriptive variable names. Abbreviations were changed to full names, and periods were removed. The variable names contain no spaces. Changes include:
1. t -> time
2. f -> frequencyDomain
3. Acc -> Accelerometer
4. Mag -> Magnitude
5. Gyro -> Gyroscope
6. BodyBody -> Body
7. std -> StandardDeviation
8. tBody -> TimeBody
9. .mean -> Mean
10. .gravitMean -> GravityMean
11. JerMean -> JerkMean
12. Freq. -> Frequency

```{r}
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
head(str(sumData),2)
```
## 3.5. Tidy Data Output

### 3.5.1. Create tidyData table and calculate the means

The means of each variable was determined per subject, per activity and stored in a data table named tidyData, consisting of *180 observations* and *88 variables*.
```{r}
tidyData <- sumData  %>% 
  group_by(subjectID, activity) %>%
  summarise_all(funs(mean))
```
### 3.5.2. Write final data to tidyData.txt

The tidyData table was then written to a .txt output file.

```{r}
write.table(tidyData, "tidyData.txt", row.name=FALSE)
```