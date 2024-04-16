library(tidyverse)

###Reads the data tables into R
TestData <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
TrainData <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
TrainLabels <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
TestLabels <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
Features <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
TestSubject <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
TrainSubject <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
print("Data read")

##Merges the training and test sets to create composite data sets
AllData <- rbind(TestData, TrainData)
AllLabels <- rbind(TestLabels, TrainLabels)
AllSubjects <- rbind(TestSubject, TrainSubject)

##renames columns based on Features
colnames(AllData) <- Features$V2

##Extracts measurements conatining "mean" or "std"
MeansAndStd <- select(AllData, matches("mean()|std()"))

##Removes extra measurements on "meanFreq" and "angle"
MeansAndStd <- select(MeansAndStd, !(matches("meanFreq()|angle")))

##Uses descriptive activity names to name the activities in the data set
AllLabels <- as.data.frame(gsub("1","Walking", AllLabels$V1))
colnames(AllLabels) <- c("V1")
AllLabels <- as.data.frame(gsub("2","WalkingUpstairs", AllLabels$V1))
colnames(AllLabels) <- c("V1")
AllLabels <- as.data.frame(gsub("3","WalkingDownstairs", AllLabels$V1))
colnames(AllLabels) <- c("V1")
AllLabels <- as.data.frame(gsub("4","Sitting", AllLabels$V1))
colnames(AllLabels) <- c("V1")
AllLabels <- as.data.frame(gsub("5","Standing", AllLabels$V1))
colnames(AllLabels) <- c("V1")
AllLabels <- as.data.frame(gsub("6","Laying", AllLabels$V1))
colnames(AllLabels) <- c("V1")

##Renames columns of AllSubjects and AllLabels

names(AllSubjects) <- "Subjects"
names(AllLabels) <- "Activities"

##Merges MeansAndStd, AllLabels, and AllSubjects

FullData <- cbind(AllSubjects, AllLabels, MeansAndStd)

##Appropriately labels the data set with descriptive variable names

names(FullData) <- gsub("mean\\()","mean", names(FullData))
names(FullData) <- gsub("std\\()", "std", names(FullData))

##Creates an independent tidy data set with the average of each variable for each activity and each subject.
##Splits data by Subjects and Activities. Also removes the activities column in order to apply mean to it later
splitdata <- split(FullData[c(1,3:68)], list(FullData$Subjects,FullData$Activities))

##Finds the column means of each split and puts it in a new data frame
meandata <- sapply(splitdata, colMeans)
TransposedMeanData <- as.data.frame(t(meandata))

##Adds back the activities column
Activities <- rep(c("Laying", "Sitting", "Standing", "Walking", "Walking_Downstairs", "Walking_Upstairs"), each = 30)
Activitiesdf <- as.data.frame(Activities)
FinalDF <- add_column(TransposedMeanData, Activities, .after="Subjects")

##removes row names on the final data frame for neatness
rownames(FinalDF) <- NULL

##writes the final data frame to a text file
write.table(FinalDF, file = "tidydata.txt")
print("Tidy dataset completed")
