# Getting and Cleaning Data Course Project Code Book

This is the code book for the Getting and Cleaning Data Course Project.

### Original Data

Data used in this project were taken from the UCI machine learning repository on "Human Activity Recognition Using Smartphones"\
Files used:\
- x_test.txt-the test data\
- y_test.txt- the test activity labels\
- x_train.txt- the training data\
- y_train.txt- the training activity labels\
- features.txt- the variable names\
- subject_test.txt- the test subject labels\
- subject_train.txt- the training subject labels\
- activity_labels.txt- the activity names\
- features_info.txt- the text file describing what variables they used in the study

### Importing Data

`read.table` was used to import all of the necessary datasets from the provided data. The data was placed into the following data frames

```         
TestData-The testing data
TrainData-the training data
TrainLabels-the training activity labels
TestLabels-the testing activity labels
Features-the variable names
TestSubject-the testing subject labels
TrainSubject-the training subject labels
```

### Merging and Renaming Data

First, the Testing sets and Training sets were merged into composite data frames.

```         
AllData <- rbind(TestData, TrainData)
AllLabels <- rbind(TestLabels, TrainLabels)
AllSubjects <- rbind(TestSubject, TrainSubject)
```

The columns of `AllData` were then renamed based on the Features dataset.

```         
colnames(AllData) <- Features$V2
```

Based on the column labels, the mean and standard deviation values were extracted.

```         
MeansAndStd <- select(AllData, matches("mean()|std()"))
MeansAndStd <- select(MeansAndStd, !(matches("meanFreq()|angle")))
```

The values in `AllLabels` were then renamed to match the provided values.

```         
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
```

The column names in `AllLabels` and `AllSubjects` were renamed.

```         
names(AllSubjects) <- "Subjects"
names(AllLabels) <- "Activities"
```

`AllSubjects`, `AllLabels`, and `MeanAndStd` were then merged into one data frame.

```         
FullData <- cbind(AllSubjects, AllLabels, MeansAndStd)
```

The variable labels provided were pretty good already so all that was changed was the removal of parenthesis.

```         
names(FullData) <- gsub("mean\\()","mean", names(FullData))
names(FullData) <- gsub("std\\()", "std", names(FullData))
```

### Creating an Independent Tidy Data Set

The first step was to split the data by the Subjects and Activities. The Activities column was also removed in order to apply the mean function more easily later on.

```         
splitdata <- split(FullData[c(1,3:68)], list(FullData$Subjects,FullData$Activities))
```

The column means of each split was then taken and placed in a new data frame. The columns and rows were flipped so the data needed to be transposed.

```         
meandata <- sapply(splitdata, colMeans)
TransposedMeanData <- as.data.frame(t(meandata))
```

The activity column was then added back in and the row names were erased.

```         
Activities <- rep(c("Laying", "Sitting", "Standing", "Walking", "Walking_Downstairs", "Walking_Upstairs"), each = 30)
Activitiesdf <- as.data.frame(Activities)
FinalDF <- add_column(TransposedMeanData, Activities, .after="Subjects")

rownames(FinalDF) <- NULL
```

Finally, the data was written to a txt file using `write.table`

```         
write.table(FinalDF, file = "tidydata.txt")
```
