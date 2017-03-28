# Getting-and-cleaning-data

## The purpose of this project is to demonstrate ability to collect, work with, and clean a data set. 
## The goal is to prepare tidy data that can be used for later analysis. Required to submit: 
## 1) a tidy data set as described below, 
## 2) a link to a Github repository with script for performing the analysis, and 
## 3) a code book that describes the variables, the data, and any transformations or work that performed to clean up the data called CodeBook.md

## We have to create one R script called run_analysis.R that does the following
## In this file, all commands are aligned in an order requested from the assignment, starting from the second phase, which means after downloading the datasets


## A. Merging the training and the test sets to create one data set

  # Reading trainings tables:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

  # Reading testing tables:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

  # Reading feature vector:
features <- read.table('./data/UCI HAR Dataset/features.txt')

  # Reading activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')


  ## Column assignment

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

  ## Merging of data 

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)


## B. Extracting only the measurements on the mean and standard deviation for each measurement

  ## Readubg column names

colNames <- colnames(setAllInOne)


  ## Create vector for defining ID, mean and standard deviation

mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)



  ## Making nessesary subset from setAllInOne

setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]



## C. Using descriptive activity names to name the activities in the data set

  ## Using descriptive activity names to name the activities in the data set

setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

## D. Creating a second, independent tidy data set with the average of each variable for each activity and each subject

  ## Making second tidy data set

secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]


  ## Writing second tidy data set in txt file 

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
