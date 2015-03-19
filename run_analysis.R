### Filename: run_analysis.R
### Author: Jakob Ludewig
### This script creates two tidy data frames from the UCI HAR Dataset. Please refer to 
### the 'CodeBook.md' and the 'Readme.md' file for more information.

# Read in the raw test data
rawtestdata <- readLines("UCI HAR Dataset/test/X_test.txt")

# Transform the test data to make it suitable for splitting with the strsplit() function
testdata <- sapply(rawtestdata,gsub, pattern="  ",replacement=" +")
testdata <- sapply(testdata,substring, first=2)
testdata <- sapply(testdata,strsplit," ")

# Transform the list containing character variables into a numeric vector, setting the
# arguments 'recursive' and 'use.names' to FALSE provides a huge performance boost over
# the standard settings
testdata <- as.numeric(unlist(testdata,recursive=FALSE,use.names=FALSE))

# Transform the vector to a matrix of correct dimensions and subsequently to a data frame
testdata <- matrix(testdata,byrow = TRUE,ncol = 561)
testdata <- data.frame(testdata)

# Read in the raw training data
rawtraindata <- readLines("UCI HAR Dataset/train/X_train.txt")

# Transform the training data to make it suitable for splitting with the strsplit() function
traindata <- sapply(rawtraindata,gsub, pattern="  ",replacement=" +")
traindata <- sapply(traindata,substring, first=2)
traindata <- sapply(traindata,strsplit," ")

# Transform the list containing character variables into a numeric vector (as seen above)
traindata <- as.numeric(unlist(traindata,recursive=FALSE,use.names=FALSE))

# Transform the vector to a matrix of correct dimensions and subsequently to a data frame
traindata <- matrix(traindata,byrow = TRUE,ncol = 561)
traindata <- data.frame(traindata)

# Merge the two data frames (in the fashion of a union)
mergeddata <- rbind(testdata,traindata)

# Read in the activity labels for earch record in the two data sets
activities_test <- as.numeric(readLines("UCI HAR Dataset//test//y_test.txt"))
activities_train <- as.numeric(readLines("UCI HAR Dataset//train/y_train.txt"))

# Read in the subjects labels for each record in the two data sets
subjects_test <- as.numeric(readLines(con="UCI HAR Dataset/test/subject_test.txt"))
subjects_train <- as.numeric(readLines(con="UCI HAR Dataset/train/subject_train.txt"))

# Create two vectors and add them as first and second column to the merged data frame
subjects <- c(subjects_test,subjects_train)
activities <- c(activities_test,activities_train)
mergeddata <- cbind(subjects,activities,mergeddata)

# Read in the features, i. e. variable names for the data sets
features <- readLines("UCI HAR Dataset/features.txt")

# Split the entries of the character vecctor by the seperators of the pattern 'number featurename'
splits <- as.character(1:561)
splits <- paste(splits," ",sep="")
features <- strsplit(features,splits)

# Extract the second entry for the entry of each list which contains the activity description
features <- sapply(features,function(x) { x[2]})

# Name the columns with the new descriptive features
colnames(mergeddata) <- c("Subject","Activity",features)

# Extract only the relevant columns using regular expressions
mergeddata <- mergeddata[,grep("mean\\(\\)|std\\(\\)|Subject|Activity",colnames(mergeddata))]

# Make the columns slightly more intuitively comprehensible using gsub
colnames(mergeddata) <- gsub("-mean\\(\\)-","_Mean-",colnames(mergeddata))
colnames(mergeddata) <- gsub("-mean\\(\\)","_Mean",colnames(mergeddata))
colnames(mergeddata) <- gsub("-std\\(\\)-","_StandardDeviation-",colnames(mergeddata))
colnames(mergeddata) <- gsub("-std\\(\\)","_StandardDeviation",colnames(mergeddata))
colnames(mergeddata) <- gsub("fBody","frequencyBody",colnames(mergeddata))
colnames(mergeddata) <- gsub("tBody","timeBody",colnames(mergeddata))
colnames(mergeddata) <- gsub("Acc","Accelerometer",colnames(mergeddata))
colnames(mergeddata) <- gsub("Gyro","Gyroscope",colnames(mergeddata))
colnames(mergeddata) <- gsub("tGravity","timeGravity",colnames(mergeddata))

# Read in the activity labels from the file, removing the code for each activity, the code
# is identical to the position of the activity in the string vector
activity_labels <- readLines(con="UCI HAR Dataset/activity_labels.txt")
activity_labels <- substring(activity_labels,3)

# Make the activities more readable
activity_labels <- gsub(tolower(activity_labels),pattern="_",replacement=" ")

# Map the activity descriptions to the labels and replace the activity code column with the
# resulting vector
mergeddata$Activity <- activity_labels[mergeddata$Activity]

# The merged data frame has been created

# From the tidy merged data frame an aggregated data frame is created using the aggregate() function with 
# the mean() function, group by Subject and Activity and rename the grouping columns appropriately
aggregateddata <- aggregate(mergeddata[,3:ncol(mergeddata)],by=list(mergeddata$Subject,mergeddata$Activity),mean)
colnames(aggregateddata)[c(1,2)] <- c("Subject","Activity")

# The aggregated data frame has been created from the merged data frame

# Do some cleaning up
rm(testdata,traindata,activities,activities_test,activities_train,activity_labels,features,rawtestdata,
   rawtraindata,splits,subjects,subjects_test,subjects_train)