

# reading all data 
features <- read.csv("features.txt", header = F, sep = " ")
activity_labels <- read.csv("activity_labels.txt",  header = F, sep = " ")

X_train <- read.table("./train/X_train.txt")
y_train <- read.csv("./train/y_train.txt",  header = F, sep = " ")
subject_train <- read.csv("./train/subject_train.txt",  header = F, sep = " ")

X_test <- read.table("./test/X_test.txt")
y_test <- read.csv("./test/y_test.txt",  header = F, sep = " ")
subject_test <- read.csv("./test/subject_test.txt",  header = F, sep = " ")

# question 1: merging the training and test data set 
train <- data.frame(subject_train, y_train, X_train)
test <- data.frame(subject_test, y_test, X_test)
all_data <- rbind(train, test)

# question 2: Extracts only the measurements on the mean and standard deviation for each measurement.
names(all_data) <- c(c("subject", "activity"),as.character(features$V2))
index <- c(grep("mean|std", names(all_data)))
meanstd_data <- subset(all_data, select = c(1,2,index))

# question 3: Uses descriptive activity names to name the activities in the data set
meanstd_data$activity <- as.numeric(meanstd_data$activity)
activity_labels$V2 <- as.character(activity_labels$V2) 
for (i in 1:6){
        meanstd_data$activity <- gsub(i,activity_labels[i,2], meanstd_data$activity)
}

# question 4: Appropriately labels the data set with descriptive variable names.
data4<- meanstd_data
names(data4) <- gsub("^t","DenoteTime-",names(data4)) 
names(data4) <- gsub("^f","FrequencyDomain-",names(data4))
names(data4) <- gsub("[(][)]","",names(data4))
names(data4) <- gsub("Body","Body-",names(data4))
names(data4) <- gsub("Gravity","Gravity-",names(data4))

# question 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data5 <- data4 
data_melt <- melt(data5, id=c("subject","activity"))
final_data <- dcast(data_melt, subject+activity ~ variable, mean)

write.table(final_data, file = "final_data.txt", row.name=FALSE)









