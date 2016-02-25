#Getting and Cleaning Data Course Project
#
#This script will perform the following steps, using data extracted from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr)

# Clean up workspace
rm(list=ls())

#0. Extract the data

## create "data" directory on working directory

if(!file.exists("./data")) {dir.create("./data")}

##download the dataset from the given URL

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/dataset.zip")
unzip("./data/dataset.zip")

#1. Merge the training and the test sets to create one data set.

#  Read train data from extracted files
features     <- read.table('./UCI HAR Dataset/features.txt',header=FALSE) 
activityType <- read.table('./UCI HAR Dataset/activity_labels.txt',header=FALSE)
subjectTrain <- read.table('./UCI HAR Dataset/train/subject_train.txt',header=FALSE)
xTrain       <- read.table('./UCI HAR Dataset/train/x_train.txt',header=FALSE)
yTrain       <- read.table('./UCI HAR Dataset/train/y_train.txt',header=FALSE)

# Assign column names to extracted train data
colnames(activityType)  <- c('activityId','activityType')
colnames(subjectTrain)  <- "subjectId"
colnames(xTrain)        <- features[,2] 
colnames(yTrain)        <- "activityId"

# Create one training data set by merging subjectTrain, xTrain and yTrain
trainData <- cbind(yTrain,subjectTrain,xTrain)

# Read test data from extracted files
subjectTest <- read.table('./test/subject_test.txt',header=FALSE)
xTest       <- read.table('./test/x_test.txt',header=FALSE)
yTest       <- read.table('./test/y_test.txt',header=FALSE)

# Assign column names to extracted test data
colnames(subjectTest) <- "subjectId"
colnames(xTest)       <- features[,2] 
colnames(yTest)       <- "activityId"

# Create one test data set by merging subjectTest, xTest and yTest
testData <- cbind(yTest, subjectTest, xTest)

# Merge training and test data to create one data set
allData <- rbind(trainData, testData)

# Create a vector for column names from allData 
colNames <- colnames(allData)

# Create a logical vector columnSelect to extract desired column (mean and std)
columnSelect <- (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames))

# Subset allData using columnSelect to keep only desired columns
allData <- allData[columnSelect==TRUE]

#3. Use descriptive activity names to name the activities in the data set
allData <- merge(allData,activityType,by='activityId',all.x=TRUE)

#4. Appropriately label the data set with descriptive variable names.

names(allData) <- gsub("\\()","",names(allData))
names(allData) <- gsub("-std","StdDev",names(allData))
names(allData) <- gsub("-mean","Mean",names(allData))
names(allData) <- gsub("^(t)","time.",names(allData))
names(allData) <- gsub("^(f)","frequency.",names(allData))
names(allData) <- gsub("([Gg]ravity)","Gravity",names(allData))
names(allData) <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",names(allData))
names(allData) <- gsub("[Gg]yro","Gyro",names(allData))
names(allData) <- gsub("AccMag","AccMagnitude",names(allData))
names(allData) <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",names(allData))
names(allData) <- gsub("JerkMag","JerkMagnitude",names(allData))
names(allData) <- gsub("GyroMag","GyroMagnitude",names(allData))

#5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

tidyData <- ddply(allData,c("subjectId","activityId"),numcolwise(mean))
write.table(tidyData, './tidyData.txt',row.names=TRUE,sep='\t')
