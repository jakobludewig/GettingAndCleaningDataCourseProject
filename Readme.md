Readme File - Getting and Cleaning Data Course Project
====================
Author: Jakob Ludewig
--------------------

The creation of the two data sets is carried out by running the _run_analysis.R_ script in R. The script requires that the working directory is set to the folder containing the script itself. Also the folder _UCI HAR Dataset_ from the archive [getdata-projectfiles-UCI HAR Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "Link to data source on Cloudfront") needs to be present.

The following section will walk through the file _run\_analysis.R_ line by line, explaining how the two tidy data sets were created from the raw data.

### Step-by-Step Walkthrough

#### Loading and transforming the raw data into a dataframe
In this step the raw data for the train and the test data set will be loaded into a character vector with as many entries as records in the file, each record will be loaded as one long characters string. The procedure for the training and the test data set are analogous and we will only explain the latter in this documentary in detail. 

Since each record makes up one line of the text file we can use the _readLines_ function without any further arguments.

    rawtestdata <- readLines("UCI HAR Dataset/test/X_test.txt")


Some cleaning up has to be performed: The first line removes double whitespaces which result from the fixed width format for positive numbers as no _-_ sign is present. Those whitespaces are replaced with a _+_ sign using the _gsub_ function in combination with _sapply_. As a result only single spaces will be present in the character strings seperating each entry with the exception of the very first two characters in each character string which will be removed using _substring_.

    testdata <- sapply(rawtestdata,gsub, pattern="  ",replacement=" +")
    testdata <- sapply(testdata,substring, first=2)
    
Now the data can be split by using single whitespaces as the seperator:

    testdata <- sapply(testdata,strsplit," ")

Now the data is transformed into a vector of numeric entries by using _unlist_ (note: setting the arguments _recursive_ and _use.names_ to _FALSE_ provides a huge performance boost). The vector is then turned into a matrix with the correct properties (561 variables/columns for each record) and finally converted into a data frame.

    testdata <- as.numeric(unlist(testdata,FALSE,FALSE))
    testdata <- matrix(testdata,byrow = TRUE,ncol = 561)
    testdata <- data.frame(testdata)

The approach used for the training data set is identical to that used for the test data set:

    rawtraindata <- readLines("UCI HAR Dataset/train/X_train.txt")
    
    traindata <- sapply(rawtraindata,gsub, pattern="  ",replacement=" +")
    
    traindata <- sapply(traindata,substring, first=2)
    traindata <- sapply(traindata,strsplit," ")
    traindata <- as.numeric(unlist(traindata,FALSE,FALSE))
    traindata <- matrix(traindata,byrow = TRUE,ncol = 561)
    traindata <- data.frame(traindata)
    
#### Merging the Data Frames and Adding Subject/Activity Information for Each Record

The data frames are merged using a simple _rbind_:

    mergeddata <- rbind(testdata,traindata)
    
In order to obtain the information about the activity and subject for each record we load the corresponding files and transform them to numeric vectors.

    activities_test <- as.numeric(readLines("UCI HAR Dataset//test//y_test.txt"))
    activities_train <- as.numeric(readLines("UCI HAR Dataset//train/y_train.txt"))
    
    subjects_test <- as.numeric(readLines(con="UCI HAR Dataset/test/subject_test.txt"))
    subjects_train <- as.numeric(readLines(con="UCI HAR Dataset/train/subject_train.txt"))

The vectors are then combined in the right order and added as first and second column to the merged data frame:

    subjects <- c(subjects_test,subjects_train)
    activities <- c(activities_test,activities_train)
    
    mergeddata <- cbind(subjects,activities,mergeddata)
    
#### Adding Descriptive Variable Names and Extracting the Target Columns
To obtain the variable names we load the _features.txt_ file, again using _readLines_.

    features <- readLines("UCI HAR Dataset/features.txt")

The resulting character vector contains entries of the form "_featurenumber_ _variablename_". In order to remove the leading numbers and the white space we construct a _splits_ vector which holds the correcct separator for each entry in _features_. Using _strsplit_ and extracting the second entry of the resulting list we obtain a string vector with the variable names.

    splits <- as.character(1:561)
    splits <- paste(splits," ",sep="")
    
    features <- strsplit(features,splits)
    
    features <- sapply(features,function(x) { x[2]})

The columns of the _mergeddata_ data frame are named.

    colnames(mergeddata) <- c("Subject","Activity",features)

Since we are only interested in the variables containing means and standard deviations we extract those (and the subject and activity column) using regular expressions:

    mergeddata <- mergeddata[,grep("mean\\(\\)|std\\(\\)|Subject|Activity",colnames(mergeddata))]
    
#### Polishing the Variable Names and Adding Descriptive Activity Labels

To make the variable names a little less technical and more intuitive we use _gsub_ on the column names of the merged data frame:

    colnames(mergeddata) <- gsub("-mean\\(\\)-","_Mean-",colnames(mergeddata))
    colnames(mergeddata) <- gsub("-mean\\(\\)","_Mean",colnames(mergeddata))
    colnames(mergeddata) <- gsub("-std\\(\\)-","_StandardDeviation-",colnames(mergeddata))
    colnames(mergeddata) <- gsub("-std\\(\\)","_StandardDeviation",colnames(mergeddata))
    colnames(mergeddata) <- gsub("fBody","frequencyBody",colnames(mergeddata))
    colnames(mergeddata) <- gsub("tBody","timeBody",colnames(mergeddata))
    colnames(mergeddata) <- gsub("Acc","Accelerometer",colnames(mergeddata))
    colnames(mergeddata) <- gsub("Gyro","Gyroscope",colnames(mergeddata))
    colnames(mergeddata) <- gsub("tGravity","timeGravity",colnames(mergeddata))

Finally we add descriptive activity labels by reading and slightly transforming the labels from the _activity_labels.txt_ file:

    activity_labels <- readLines(con="UCI HAR Dataset/activity_labels.txt")
    activity_labels <- substring(activity_labels,3)
    activity_labels <- gsub(tolower(activity_labels),pattern="_",replacement=" ")

    mergeddata$Activity <- activity_labels[mergeddata$Activity]


The first data frame has now been created. We will go on to create the aggregated data frame in the next and final step.

#### Creating the Aggregated Data Frame

The _aggregateddata_ data frame is simply created by using the _aggregate_ function with _mean_ and grouping by subjects and activities. Note that we have to remove the activity and subject column when aggregating since they can not be aggregated with _mean_ in a sensible fashion. The grouping columns will be renamed to _Subject_ and _Activity_ accordingly:

    aggregateddata <- aggregate(mergeddata[,3:ncol(mergeddata)],by=list(mergeddata$Subject,mergeddata$Activity),mean)
    colnames(aggregateddata)[c(1,2)] <- c("Subject","Activity")

### Result

After running the script _run_analysis.R_ we are presented with the two data frames _mergeddata_ and _aggregateddata_ which can be used for further analysis.