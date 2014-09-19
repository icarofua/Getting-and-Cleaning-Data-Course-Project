train <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=F)
train.activity <- read.csv("UCI HAR Dataset/train/y_train.txt", sep="", header=F)
train.subject <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=F)

test <- read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=F)
test.activity <- read.csv("UCI HAR Dataset/test/y_test.txt", sep="", header=F)
test.subject <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=F)

activityLabels <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=F)
feats <- read.csv("UCI HAR Dataset/features.txt", sep="", header=F)

# Create one data set with merges the training and the test sets.
allData <- rbind(train, test)
allActivity <- rbind(train.activity, test.activity)
allSubject <- rbind(train.subject, test.subject)

# Mean and standard deviation for each measurement are extracted. 
feats[,2] = gsub('-mean', 'Mean', feats[,2])
feats[,2] = gsub('-std', 'Std', feats[,2])
feats[,2] = gsub('[-()]', '', feats[,2])
cols <- grep(".*Mean.*|.*Std.*", feats[,2])
feats <- feats[cols,]

#The name of the activities in the data set are obtained by the descriptive activity names
allActivity<-lapply(allActivity,factorConv<-function(f){activityLabels$V2[f]})

allData <- allData[,cols]
names(allData) <- c(feats$V2)

#Second database that contains the average of each variable for each activity and each subject. 
tidy <- aggregate(allData, by=c(activity = allActivity, subject=allSubject), mean)
write.table(tidy, "tidy.txt", sep="\t",row.names=F)
