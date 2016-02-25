# Coursera-Getting-and-Cleaning-Data-Project

This is the course project for the Getting and Cleaning Data Course

The R Script "run_analysis.R" does the following:

1.  Download the datasetfrom "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" if it does not         already exist in the working directory.
2.  Using the extracted data:
    a.  Merges the training and the test sets to create one data set.
    b.  Extracts only the measurements on the mean and standard deviation for each measurement.
    c.  Uses descriptive activity names to name the activities in the data set
    d.  Appropriately labels the data set with descriptive variable names.
    e.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and         each subject.
3.  The output of the script is the file "tidyData.txt".
