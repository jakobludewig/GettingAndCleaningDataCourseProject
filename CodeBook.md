Code Book - Getting and Cleaning Data Course Project
====================
Author: Jakob Ludewig
--------------------

### Content
This document will explain the variables contained in the two datasets _mergeddata_ and _aggregateddata_ produced by the script _run\_analysis.R_. This file will only explain the transformation of the raw data to the two tidy data sets on a conceptual level. For a line by line walkthrough of the _run\_analysis.R_ script which explains the actions on a code level please refer to the _Readme.md_ file contained in this repository.

### The raw data
### Raw data and Objective

#### Activities and Subjects

The raw data provided consists of movement data measured with the accelerometer and gyroscope embedded in a mobile phone. 30 test subjects performed six different activities:

* walking
* walking upstairs 
* walking downstairs
* sitting
* standing
* lying


In total 10299 records were obtained and divided into two subject groups, generating the test (approximately 30% of the subjects) and training data (70%) respectively. The training data was stored in text files _train/X\_train.txt_ and the test data was stored in _test/X\_test.txt_. Data identifying the subject and executed activity for each record can be found in the files _subject\_test.txt_ or _subject\_train.txt_ and _y\_train.txt_ or _y\_test.txt_. The activities were coded with integers ranging from 1 to 6. A dictionary for those codes can be found in the file _activity\_labels.txt_.

#### Variables

The signal data which was recorded during these activities was pre-processed (e.g. noise filters were applied and the data was resampled). Using Fast Fourier Transformations (FFT) some of the data was transformed into frequency data. 
The gyroscope and the accelerometer both collected data on a variety of signals. The following list of signals were recorded on a time dimension:

* Body Acceleration (tBodyAcc-XYZ)
* Gravity Acceleration (tGravityAcc-XYZ)
* Body Acceleration Jerk (tBodyAccJerk-XYZ)
* Body Gyro (tBodyGyro-XYZ)
* Body Gyro Jerk (tBodyGyroJerk-XYZ)
* Body Acceleration Magnitude (tBodyAccMag)
* Gravity Acceleration Magnitude (tGravityAccMag)
* Body Acceleration Jerk Magnitude (tBodyAccJerkMag)
* Body Gyro Magnitude (tBodyGyroMag)
* Body Gyro Jerk Magnitude (tBodyGyroJerkMag)

The following variables frequency variables were obtained by transforming the corresponding time variables using the FFT:

* Body Acceleration (fBodyAcc-XYZ)
* Body Acceleration Jerk (fBodyAccJerk-XYZ)
* Body Gyro (fBodyGyro-XYZ) 
* Body Acceleration Magnitude (fBodyAccMag)
* Body Acceleration Jerk Magnitude (fBodyAccJerkMag)
* Body Gyro Magnitude (fBodyGyroMag)
* Body Gyro Jerk Magnitude (fBodyGyroJerkMag)

The first five signals of the time variables and the first three signals of the frequency variables were measured in three spacial dimensions. This results in a total of 33 signals. For each signal the following 17 aggregates/statistics were calculated:

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
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

This resulted in a total of 561 observed variables which were part of the raw data set.

The variables were normalized and accordingly can thus be considered dimensionless.

For more information about the raw data see the _README.txt_ file which is located in the _UCI HAR Dataset_ folder.

### Transformation of the Raw Data into the Tidy Data

The objective of this assignment was to create two tidy data sets: The first one containing the test and training data merged into one data frame and only extracting the variables containing means and standard deviations of the signals. The data frame had to be labelled with descriptive variable names and the codings for the activities had to be replaced with the meaningful descriptions.

From the first data frame a second data frame was to be built which aggregated the records for each subject and each activity by calculating the mean over each variable. 

#### Import of the Raw Data

The raw data was imported from the files _UCI HAR Dataset/test/X\_test.txt_ and _UCI HAR Dataset/train/X\_train.txt_ respectively. The approach for the test data and the training data was identical.

#### Transformation into a Data Frame

After some cleaning up the character data was split up at the correct delimiters and converted into numeric variables. The resulting list was coerced to a matrix and then transformed into a data frame.

#### Merging and Labelling

The two data frames were then merged in a union style. Two additional columns were added containing subject labels and activity labels for each record (originating from the files _UCI HAR Dataset//test//y\_test.txt_, _UCI HAR Dataset//train/y\_train.txt_, _UCI HAR Dataset/test/subject\_test.txt_, _UCI HAR Dataset/train/subject\_train.txt_).

#### Adding Descriptive Variable Names

In this step descriptive variable names were read in from the file _UCI HAR Dataset/features.txt_, cleaned up and added as column names to the data frame.

#### Extracting the Relevant Columns, Cleaning up Variable Names

Using these variable names the columns containing the standard deviations and the means of the measured signals were extracted. Using regular expressions, the variable names were transformed in a more intuitive naming.

#### Adding Descriptive Activity Labels

The coding for the activities were replaced using the activity labels in the file _UCI HAR Dataset/activity\_labels.txt_.

#### Create the Aggregated Data from the Tidy Data

From the tidy data frame created another data frame was created using containing the mean of all the signals grouped by subjects and activities.

### Result
#### Data Frame _mergeddata_

The merged data frame contains 10299 observations of 68 variables (two of which are labels for activities and subjects). The list of variables is as follows:

* Subject
* Activity
* timeBodyAccelerometer_Mean-X
* timeBodyAccelerometer_Mean-Y
* timeBodyAccelerometer_Mean-Z
* timeBodyAccelerometer_StandardDeviation-X
* timeBodyAccelerometer_StandardDeviation-Y
* timeBodyAccelerometer_StandardDeviation-Z
* timeGravityAccelerometer_Mean-X
* timeGravityAccelerometer_Mean-Y
* timeGravityAccelerometer_Mean-Z
* timeGravityAccelerometer_StandardDeviation-X
* timeGravityAccelerometer_StandardDeviation-Y
* timeGravityAccelerometer_StandardDeviation-Z
* timeBodyAccelerometerJerk_Mean-X
* timeBodyAccelerometerJerk_Mean-Y
* timeBodyAccelerometerJerk_Mean-Z
* timeBodyAccelerometerJerk_StandardDeviation-X
* timeBodyAccelerometerJerk_StandardDeviation-Y
* timeBodyAccelerometerJerk_StandardDeviation-Z
* timeBodyGyroscope_Mean-X
* timeBodyGyroscope_Mean-Y
* timeBodyGyroscope_Mean-Z
* timeBodyGyroscope_StandardDeviation-X
* timeBodyGyroscope_StandardDeviation-Y
* timeBodyGyroscope_StandardDeviation-Z
* timeBodyGyroscopeJerk_Mean-X
* timeBodyGyroscopeJerk_Mean-Y
* timeBodyGyroscopeJerk_Mean-Z
* timeBodyGyroscopeJerk_StandardDeviation-X
* timeBodyGyroscopeJerk_StandardDeviation-Y
* timeBodyGyroscopeJerk_StandardDeviation-Z
* timeBodyAccelerometerMag_Mean
* timeBodyAccelerometerMag_StandardDeviation
* timeGravityAccelerometerMag_Mean
* timeGravityAccelerometerMag_StandardDeviation
* timeBodyAccelerometerJerkMag_Mean
* timeBodyAccelerometerJerkMag_StandardDeviation
* timeBodyGyroscopeMag_Mean
* timeBodyGyroscopeMag_StandardDeviation
* timeBodyGyroscopeJerkMag_Mean
* timeBodyGyroscopeJerkMag_StandardDeviation
* frequencyBodyAccelerometer_Mean-X
* frequencyBodyAccelerometer_Mean-Y
* frequencyBodyAccelerometer_Mean-Z
* frequencyBodyAccelerometer_StandardDeviation-X
* frequencyBodyAccelerometer_StandardDeviation-Y
* frequencyBodyAccelerometer_StandardDeviation-Z
* frequencyBodyAccelerometerJerk_Mean-X
* frequencyBodyAccelerometerJerk_Mean-Y
* frequencyBodyAccelerometerJerk_Mean-Z
* frequencyBodyAccelerometerJerk_StandardDeviation-X
* frequencyBodyAccelerometerJerk_StandardDeviation-Y
* frequencyBodyAccelerometerJerk_StandardDeviation-Z
* frequencyBodyGyroscope_Mean-X
* frequencyBodyGyroscope_Mean-Y
* frequencyBodyGyroscope_Mean-Z
* frequencyBodyGyroscope_StandardDeviation-X
* frequencyBodyGyroscope_StandardDeviation-Y
* frequencyBodyGyroscope_StandardDeviation-Z
* frequencyBodyAccelerometerMag_Mean
* frequencyBodyAccelerometerMag_StandardDeviation
* frequencyBodyBodyAccelerometerJerkMag_Mean
* frequencyBodyBodyAccelerometerJerkMag_StandardDeviation
* frequencyBodyBodyGyroscopeMag_Mean
* frequencyBodyBodyGyroscopeMag_StandardDeviation
* frequencyBodyBodyGyroscopeJerkMag_Mean
* frequencyBodyBodyGyroscopeJerkMag_StandardDeviation

As for the raw data set these variables were normalized and are without dimension.

#### Data Frame _aggregateddata_

The second data frame consists of 180 observations of 68 variables. The variables are the same as for the _mergeddata_ data frame but contain the mean of intial variables grouped by subjects and activity.