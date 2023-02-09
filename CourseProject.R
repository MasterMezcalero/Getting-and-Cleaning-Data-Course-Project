## Zip file previously downloaded to project directory
unzip("getdata_projectfiles_UCI HAR Dataset.zip")

## Initializing test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

## Initializing train data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

## 1. Merges the training and the test sets to create one data set.
x <- rbind(x_test, x_train)
y <- rbind(y_test, y_train)
subject <- rbind(subject_test, subject_train)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## Taking the names from the features data frame based on them containing mean or std in their names.
## \\ to escape the meta characters, then returning the number of features containing mean or std

features <- read.table("UCI HAR Dataset/features.txt")
MeanAndStd <- grep("mean\\(\\)|std\\(\\)", features[,2])

## 3. Uses descriptive activity names to name the activities in the data set
## First reading in the activity labels data, then naming the activities in the y data set.

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
y[,1] <- activity_labels[y[,1], 2]

## 4. Appropriately labels the data set with descriptive variable names. 
## Getting the activity names, then assigning them to the columns in x. Then defining column names
## for subject and y, before tying the data sets together.

activity_names <- features[MeanAndStd, 2]
names(x) <- activity_names
names(subject) <- "ActivityID"
names(y) <- "ActivityName"

CleanData <- cbind(subject, y, x)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of 
## each variable for each activity and each subject.

CleanData <- data.table(CleanData)
Tidy <- CleanData[, lapply(CleanData, mean), by = 'ActivityID,ActivityName']

write.table(Tidy, file = "Tidy.txt", row.name = FALSE)