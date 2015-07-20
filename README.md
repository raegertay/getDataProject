# README
Raeger Tay  
20 July 2015  

# Getting and Cleaning Data Course Project  

The "run_analysis.R" script was used to generate the "tidy_data" dataset in wide form. This guide aims to explain how the analysis script works.

The dataset consists of the following files:

* X_test - contains test measuremnts  
* X_train - contains training measurements  
* y_test - contains test activity id  
* y_train - cotains training activity id  
* subject_test - contains test subjects  
* subject_train - contains training subjects  
* features - contains features pertaining to the measurements  
* activity_labels - contains reference table for the activity  

### 1. Merges the training and the test sets to create one data set.
a. Merge X_test and X_train (measurements) + Add "features" as variables names

```r
library(dplyr)
```


```r
X_test <- read.table(file = "./dataset/test/X_test.txt")
X_train <- read.table(file = "./dataset/train/X_train.txt")
X_all <- rbind(X_test, X_train)
features <- read.table(file = "./dataset/features.txt")
names(X_all) <- make.names(names = features[ ,2], unique = TRUE)
dim(X_all)
```

```
## [1] 10299   561
```
*Note: make.names() was used as the default feature names contains invalid column name syntax like "(", ")" etc.*

b. Merge y_test and y_train (activity labels)

```r
y_test <- read.table(file = "./dataset/test/y_test.txt", col.names = "activity")
y_train <- read.table(file = "./dataset/train/y_train.txt", col.names = "activity")
y_all <- rbind(y_test, y_train)
dim(y_all)
```

```
## [1] 10299     1
```

c. Merge subject_test and subject_train (subject)

```r
subject_test <- read.table(file = "./dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table(file = "./dataset/train/subject_train.txt", col.names = "subject")
subject_all <- rbind(subject_test, subject_train)
dim(subject_all)
```

```
## [1] 10299     1
```

d. Merge subject, activity labels and measurements

```r
data_all <- cbind(y_all, subject_all, X_all)
data_all <- tbl_df(data_all)
dim(data_all)
```

```
## [1] 10299   563
```

### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
angle() measurements were not extracted as they are not mean of any measurements, but are calculated from other measurements' mean.

```r
data_sub <- select(data_all, activity, subject, matches("mean|std", ignore.case = FALSE))
dim(data_sub)
```

```
## [1] 10299    81
```

```r
names(data_sub)
```

```
##  [1] "activity"                        "subject"                        
##  [3] "tBodyAcc.mean...X"               "tBodyAcc.mean...Y"              
##  [5] "tBodyAcc.mean...Z"               "tBodyAcc.std...X"               
##  [7] "tBodyAcc.std...Y"                "tBodyAcc.std...Z"               
##  [9] "tGravityAcc.mean...X"            "tGravityAcc.mean...Y"           
## [11] "tGravityAcc.mean...Z"            "tGravityAcc.std...X"            
## [13] "tGravityAcc.std...Y"             "tGravityAcc.std...Z"            
## [15] "tBodyAccJerk.mean...X"           "tBodyAccJerk.mean...Y"          
## [17] "tBodyAccJerk.mean...Z"           "tBodyAccJerk.std...X"           
## [19] "tBodyAccJerk.std...Y"            "tBodyAccJerk.std...Z"           
## [21] "tBodyGyro.mean...X"              "tBodyGyro.mean...Y"             
## [23] "tBodyGyro.mean...Z"              "tBodyGyro.std...X"              
## [25] "tBodyGyro.std...Y"               "tBodyGyro.std...Z"              
## [27] "tBodyGyroJerk.mean...X"          "tBodyGyroJerk.mean...Y"         
## [29] "tBodyGyroJerk.mean...Z"          "tBodyGyroJerk.std...X"          
## [31] "tBodyGyroJerk.std...Y"           "tBodyGyroJerk.std...Z"          
## [33] "tBodyAccMag.mean.."              "tBodyAccMag.std.."              
## [35] "tGravityAccMag.mean.."           "tGravityAccMag.std.."           
## [37] "tBodyAccJerkMag.mean.."          "tBodyAccJerkMag.std.."          
## [39] "tBodyGyroMag.mean.."             "tBodyGyroMag.std.."             
## [41] "tBodyGyroJerkMag.mean.."         "tBodyGyroJerkMag.std.."         
## [43] "fBodyAcc.mean...X"               "fBodyAcc.mean...Y"              
## [45] "fBodyAcc.mean...Z"               "fBodyAcc.std...X"               
## [47] "fBodyAcc.std...Y"                "fBodyAcc.std...Z"               
## [49] "fBodyAcc.meanFreq...X"           "fBodyAcc.meanFreq...Y"          
## [51] "fBodyAcc.meanFreq...Z"           "fBodyAccJerk.mean...X"          
## [53] "fBodyAccJerk.mean...Y"           "fBodyAccJerk.mean...Z"          
## [55] "fBodyAccJerk.std...X"            "fBodyAccJerk.std...Y"           
## [57] "fBodyAccJerk.std...Z"            "fBodyAccJerk.meanFreq...X"      
## [59] "fBodyAccJerk.meanFreq...Y"       "fBodyAccJerk.meanFreq...Z"      
## [61] "fBodyGyro.mean...X"              "fBodyGyro.mean...Y"             
## [63] "fBodyGyro.mean...Z"              "fBodyGyro.std...X"              
## [65] "fBodyGyro.std...Y"               "fBodyGyro.std...Z"              
## [67] "fBodyGyro.meanFreq...X"          "fBodyGyro.meanFreq...Y"         
## [69] "fBodyGyro.meanFreq...Z"          "fBodyAccMag.mean.."             
## [71] "fBodyAccMag.std.."               "fBodyAccMag.meanFreq.."         
## [73] "fBodyBodyAccJerkMag.mean.."      "fBodyBodyAccJerkMag.std.."      
## [75] "fBodyBodyAccJerkMag.meanFreq.."  "fBodyBodyGyroMag.mean.."        
## [77] "fBodyBodyGyroMag.std.."          "fBodyBodyGyroMag.meanFreq.."    
## [79] "fBodyBodyGyroJerkMag.mean.."     "fBodyBodyGyroJerkMag.std.."     
## [81] "fBodyBodyGyroJerkMag.meanFreq.."
```

### 3. Uses descriptive activity names to name the activities in the data set

```r
activity_labels <- read.table(file = "./dataset/activity_labels.txt")
data_named <- mutate(data_sub, activity = activity_labels[activity, 2])
data_named[1:5, 1:5]
```

```
## Source: local data frame [5 x 5]
## 
##   activity subject tBodyAcc.mean...X tBodyAcc.mean...Y tBodyAcc.mean...Z
## 1 STANDING       2         0.2571778       -0.02328523       -0.01465376
## 2 STANDING       2         0.2860267       -0.01316336       -0.11908252
## 3 STANDING       2         0.2754848       -0.02605042       -0.11815167
## 4 STANDING       2         0.2702982       -0.03261387       -0.11752018
## 5 STANDING       2         0.2748330       -0.02784779       -0.12952716
```

### 4. Appropriately labels the data set with descriptive variable names. 
**Completed in Step 1**

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```r
data_grouped <- group_by(data_named, activity, subject)
data_tidy <- summarise_each(data_grouped, funs(mean))
dim(data_tidy)
```

```
## [1] 180  81
```

```r
data_tidy[1:5,1:5]
```

```
## Source: local data frame [5 x 5]
## Groups: activity
## 
##   activity subject tBodyAcc.mean...X tBodyAcc.mean...Y tBodyAcc.mean...Z
## 1   LAYING       1         0.2215982       -0.04051395        -0.1132036
## 2   LAYING       2         0.2813734       -0.01815874        -0.1072456
## 3   LAYING       3         0.2755169       -0.01895568        -0.1013005
## 4   LAYING       4         0.2635592       -0.01500318        -0.1106882
## 5   LAYING       5         0.2783343       -0.01830421        -0.1079376
```

```r
write.table(data_tidy, file = "data_tidy.txt", row.names = FALSE)
```
Note that output tidy data is in **wide form**.

### 6. Reading data_tidy

```r
data_tidy.read <- read.table(file = "data_tidy.txt", header = TRUE) 
dim(data_tidy.read)
```

```
## [1] 180  81
```

```r
data_tidy.read[1:5,1:5]
```

```
##   activity subject tBodyAcc.mean...X tBodyAcc.mean...Y tBodyAcc.mean...Z
## 1   LAYING       1         0.2215982       -0.04051395        -0.1132036
## 2   LAYING       2         0.2813734       -0.01815874        -0.1072456
## 3   LAYING       3         0.2755169       -0.01895568        -0.1013005
## 4   LAYING       4         0.2635592       -0.01500318        -0.1106882
## 5   LAYING       5         0.2783343       -0.01830421        -0.1079376
```
