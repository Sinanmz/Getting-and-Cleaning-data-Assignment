### This file explains all the steps that was performed in the run_analysis.R to get from the raw data to the cleaned-up data in the FinalData.txt.


1. **Reading the data and assigning variable names to them:**

```
features <- read.table("UCI HAR Dataset/features.txt", col.names = c(" ", "features"))
data_test  <- read.table("UCI HAR Dataset/test/x_test.txt", col.names = features$features)
data_train <- read.table("UCI HAR Dataset/train/x_train.txt", col.names = features$features)
activity_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity_label")
activity_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity_label")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

```
These lines of code basically read the raw datasets and assign appropriate variable names to their columns.


2. **Merging the training and test datasets to create one single dataset:**

```
data <- rbind(data_test, data_train)
activity <- rbind(activity_test, activity_train)
subject <- rbind(subject_test, subject_train)
merged_data <- cbind(subject, activity ,data)
tidy_data <- select(merged_data,  subject, activity_label, contains("mean"), contains("std"))

```
These lines of code merge the datasets and create a dataset called "mergeddata" and then by selecting the appropriate columns we get to a tidyer dataset called "tidy".


3. **Adding descriptive names to the activities and dataset columns:**

```
tidy_data[, 2] <- gsub("1", "walking", tidy_data[, 2])
tidy_data[, 2] <- gsub("2", "walking_upstairs", tidy_data[, 2])
tidy_data[, 2] <- gsub("3", "walking_downstairs", tidy_data[, 2])
tidy_data[, 2] <- gsub("4", "sitting", tidy_data[, 2])
tidy_data[, 2] <- gsub("5", "standing", tidy_data[, 2])
tidy_data[, 2] <- gsub("6", "laying", tidy_data[, 2])
names(tidy_data) <- sub("activity_label", "activity", names(tidy_data))


names(tidy_data)<-gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<-gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data)<-gsub("^t", "Time", names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency", names(tidy_data))

```
These lines of code add descriptive names to the activity labels column and then change its name to the activity column,also they add descriptive variable names to the dataset using the gsub() function.


4. **Averaging each variable in the latest dataset and exporting the final table as a text file:**

```
final_data <- group_by(tidy_data, subject, activity) %>%
  summarise_all(funs(mean))
write.table(final_data, "FinalData.txt", row.names = FALSE)

```
These lines of code first group the dataset based on the subject and activity columns and then average each variable for those groups and store them into a final dataset. After all that, the final data frame is going to be stored in a text file named "FinalData.txt" 