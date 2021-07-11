library(dplyr)


#reading the tables needed for this assignemnt.
features <- read.table("UCI HAR Dataset/features.txt", col.names = c(" ", "features"))
data_test  <- read.table("UCI HAR Dataset/test/x_test.txt", col.names = features$features)
data_train <- read.table("UCI HAR Dataset/train/x_train.txt", col.names = features$features)
activity_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity_label")
activity_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity_label")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")


#binding the data frames into one tidy data frame.
data <- rbind(data_test, data_train)
activity <- rbind(activity_test, activity_train)
subject <- rbind(subject_test, subject_train)
merged_data <- cbind(subject, activity ,data)
tidy_data <- select(merged_data,  subject, activity_label, contains("mean"), contains("std"))


#adding desctiptive activity names to the dataset.
tidy_data[, 2] <- gsub("1", "walking", tidy_data[, 2])
tidy_data[, 2] <- gsub("2", "walking_upstairs", tidy_data[, 2])
tidy_data[, 2] <- gsub("3", "walking_downstairs", tidy_data[, 2])
tidy_data[, 2] <- gsub("4", "sitting", tidy_data[, 2])
tidy_data[, 2] <- gsub("5", "standing", tidy_data[, 2])
tidy_data[, 2] <- gsub("6", "laying", tidy_data[, 2])
names(tidy_data) <- sub("activity_label", "activity", names(tidy_data))


#adding descriptive variable names t the datset.
names(tidy_data)<-gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<-gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data)<-gsub("^t", "Time", names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency", names(tidy_data))


#creating and writing the fanal dataset as a text file.
final_data <- group_by(tidy_data, subject, activity) %>%
  summarise_all(funs(mean))
write.table(final_data, "FinalData.txt", row.names = FALSE)