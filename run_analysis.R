library(dplyr)

## 1. Merges the training and the test sets to create one data set.

### a. Merge X_test and X_train (measurements) + Add "features" as variables names
X_test <- read.table(file = "./dataset/test/X_test.txt")
X_train <- read.table(file = "./dataset/train/X_train.txt")
X_all <- rbind(X_test, X_train)
features <- read.table(file = "./dataset/features.txt")
names(X_all) <- make.names(names = features[ ,2], unique = TRUE)
dim(X_all)

### b. Merge y_test and y_train (activity labels)
y_test <- read.table(file = "./dataset/test/y_test.txt", col.names = "activity")
y_train <- read.table(file = "./dataset/train/y_train.txt", col.names = "activity")
y_all <- rbind(y_test, y_train)
dim(y_all)

### c. Merge subject_test and subject_train (subject)
subject_test <- read.table(file = "./dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table(file = "./dataset/train/subject_train.txt", col.names = "subject")
subject_all <- rbind(subject_test, subject_train)
dim(subject_all)

### d. Merge subject, activity labels and measurements
data_all <- cbind(y_all, subject_all, X_all)
data_all <- tbl_df(data_all)
dim(data_all)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
        ### angle() measurements were not extracted as they are not mean of any measurements, but are calculated from other measurements' mean.
data_sub <- select(data_all, activity, subject, matches("mean|std", ignore.case = FALSE))
dim(data_sub)
names(data_sub)

## 3. Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table(file = "./dataset/activity_labels.txt")
data_named <- mutate(data_sub, activity = activity_labels[activity, 2])
data_named[1:5, 1:5]

## 4. Appropriately labels the data set with descriptive variable names. 
        ### Completed in Step 1

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
### Note that output tidy data is in wide form.
data_grouped <- group_by(data_named, activity, subject)
data_tidy <- summarise_each(data_grouped, funs(mean))
dim(data_tidy)
data_tidy[1:5,1:5]
write.table(data_tidy, file = "data_tidy.txt", row.names = FALSE)

## 6. Reading data_tidy
data_tidy.read <- read.table(file = "data_tidy.txt", header = TRUE) 
dim(data_tidy.read)
data_tidy.read[1:5,1:5]
