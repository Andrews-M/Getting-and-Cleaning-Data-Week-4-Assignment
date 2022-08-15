
path = file.path("E:/CursoR/Curso_preparingData/cproject/UCI HAR Dataset/")

# 1. Merges the training and the test sets to create one data set
#Read files
xtrain = read.table(file.path(path, "train", "X_train.txt"),header = FALSE)
ytrain = read.table(file.path(path, "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
#test
xtest = read.table(file.path(path, "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path(path, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(path, "test", "subject_test.txt"),header = FALSE)
#features
features = read.table(file.path(path, "features.txt"),header = FALSE)
#labels
activityLabels = read.table(file.path(path, "activity_labels.txt"),header = FALSE)

#Column names for each data

colnames(xtrain) = features[,2]
colnames(ytrain) = "Activity_ID"
colnames(subject_train) = "Subject_ID"
colnames(xtest) = features[,2]
colnames(ytest) = "Activity_ID"
colnames(subject_test) = "Subject_ID"
colnames(activityLabels) <- c('Activity_ID','Activity_Type')
train = cbind(ytrain, subject_train, xtrain)
test = cbind(ytest, subject_test, xtest)

fulldata = rbind(train, test) #DATA MERGED

#2. Extracts only the measurements on the mean and standard deviation for each measurement

meanstdcol <- grep(".*Mean.*|.*Std.*", names(fulldata), ignore.case=TRUE)

columns <- c(meanstdcol, 562, 563)

data <- fulldata[,columns]

data <- cbind(fulldata[,1:2],data)

#3 & 4. Uses descriptive activity names to name the activities in the data set, Appropriately labels the data set with descriptive variable names. 
activitydata = merge(data, activityLabels, by='Activity_ID', all.x=TRUE)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#secondset <- aggregate(. ~Subject_ID + Activity_ID, activitydata, mean, na.rm=TRUE, na.action=NULL)

activitydata$Subject_ID <- as.factor(activitydata$Subject_ID)
activitydata <- data.table(activitydata)


secondData <- aggregate(. ~Subject_ID + Activity_ID, activitydata, mean)
secondData <- secondData[order(secondData$Subject_ID,secondData$Activity_ID),]
write.table(secondData, file = "Tidy.txt", row.names = FALSE)


