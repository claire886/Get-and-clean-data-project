##upload all the files
sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
x_train <- read.table("./UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")

##merge all the files in test/train directory into one data set respectively
test_merge <- cbind(sub_test, y_test, x_test)
train_merge <- cbind(sub_train, y_train, x_train)

##merge test and train data into one one data set
merge_all <- rbind(test_merge, train_merge)

##lable the dataset with descriptive variable names
colnames(merge_all)[1] <- "subject"
colnames(merge_all)[2] <- "activity"
colnames(merge_all)[3:563] <- as.character(features[ , 2])

##use descriptive activity name to name activities
merge_all$activity<-as.character(merge_all$activity)
merge_all$activity <- activity[match(merge_all$activity, activity[ , 1]), 2]

##extract the measurements that contain mean and std in the names
dataextract <- merge_all[, grepl("mean|std|subject|activity", names(merge_all))]

##create a data set with the average of each variable and each subject
meanbysubact <- aggregate(dataextract[,3:81], list(dataextract$subject, dataextract$activity), mean)
colnames(meanbysubact)[1] <- "subject"
colnames(meanbysubact)[2] <- "activity"
##Revise the typo of variable name
colnames(meanbysubact)[72] <- "fBodyAccJerkMag-mean()"
colnames(meanbysubact)[73] <- "fBodyAccJerkMag-std()"
colnames(meanbysubact)[74] <- "fBodyAccJerkMag-meanFreq()"
colnames(meanbysubact)[75] <- "fBodyGyroMag-mean()"
colnames(meanbysubact)[76] <- "fBodyGyroMag-std()"
colnames(meanbysubact)[77] <- "fBodyGyroMag-meanFreq()"
colnames(meanbysubact)[78] <- "fBodyGyroJerkMag-mean()" 
colnames(meanbysubact)[79] <- "fBodyGyroJerkMag-std()"
colnames(meanbysubact)[80] <- "fBodyGyroJerkMag-meanFreq()"
colnames(meanbysubact)[81] <- "fBodyGyroJerkMag-std()"

##write the final data set to a file
write.table(meanbysubact, file="./MeanBySubAct.txt", row.name=FALSE)
